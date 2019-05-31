provider "aws" {
  version = "1.39"
  region  = "${var.os_region}"

  assume_role {
    role_arn = "${var.os_role_arn}"
  }
}

terraform {
  backend "s3" {
    key     = "kdp"
    encrypt = true
  }
}

data "terraform_remote_state" "env_remote_state" {
  backend   = "s3"
  workspace = "${terraform.workspace}"

  config {
    bucket   = "${var.state_bucket}"
    key      = "operating-system"
    region   = "${var.alm_region}"
    role_arn = "${var.alm_role_arn}"
  }
}

resource "local_file" "kubeconfig" {
  filename = "${path.module}/outputs/kubeconfig"
  content  = "${data.terraform_remote_state.env_remote_state.eks_cluster_kubeconfig}"
}

resource "aws_kms_key" "metastore_key" {
  description = "metastore database encryption key for ${terraform.workspace}"
}

resource "aws_kms_alias" "metastore_key_alias" {
  name_prefix   = "alias/hive"
  target_key_id = "${aws_kms_key.metastore_key.key_id}"
}

resource "random_string" "metastore_password" {
  length  = 40
  special = false
}

resource "aws_secretsmanager_secret" "presto_metastore_password" {
  name = "presto_metastore_database_password"
}

resource "aws_secretsmanager_secret_version" "presto_metastore_password_version" {
  secret_id     = "${aws_secretsmanager_secret.presto_metastore_password.id}"
  secret_string = "${aws_db_instance.metastore_database.password}"
}

resource "aws_db_subnet_group" "metastore_subnet_group" {
  name        = "metastore database ${terraform.workspace} subnet group"
  description = "DB Subnet Group"
  subnet_ids  = ["${data.terraform_remote_state.env_remote_state.private_subnets}"]

  tags {
    Name = "Subnet Group for metastore database in Environment ${terraform.workspace} VPC"
  }
}

resource "aws_security_group" "metastore_allow" {
  name_prefix = "db_allow_vpc"
  vpc_id      = "${data.terraform_remote_state.env_remote_state.vpc_id}"

  tags {
    Name = "Postgres Allow VPC"
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.env_remote_state.chatter_sg_id}"] #TODO
    description     = "Allow postgres traffic from main VPC (effectively EKS)"
  }
}

resource "aws_db_instance" "metastore_database" {
  identifier                 = "${terraform.workspace}-hive-metastore"
  name                       = "metastore"
  instance_class             = "${var.metastore_instance_class}"
  vpc_security_group_ids     = ["${aws_security_group.metastore_allow.id}"]
  db_subnet_group_name       = "${aws_db_subnet_group.metastore_subnet_group.name}"
  engine                     = "postgres"
  engine_version             = "10.6"
  auto_minor_version_upgrade = false
  allocated_storage          = 100                                                  # The allocated storage in gibibytes.
  storage_type               = "gp2"
  username                   = "metastore"
  password                   = "${random_string.metastore_password.result}"
  multi_az                   = true
  backup_window              = "04:54-05:24"
  backup_retention_period    = 7
  storage_encrypted          = true
  kms_key_id                 = "${aws_kms_key.metastore_key.arn}"
  apply_immediately          = false
  skip_final_snapshot        = false
}

resource "aws_s3_bucket" "presto_hive_storage" {
  bucket = "presto-hive-storage-${terraform.workspace}"
  acl    = "private"

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "presto_hive_storage" {
  bucket = "${aws_s3_bucket.presto_hive_storage.id}"

  policy = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
        {
         "Effect": "Allow",
         "Principal": {
           "AWS":
            [
              "${data.terraform_remote_state.env_remote_state.eks_worker_role_arn}"
            ]
         },
         "Action": [
            "s3:ListBucket"
         ],
         "Resource": "${aws_s3_bucket.presto_hive_storage.arn}"
      },
      {
         "Effect": "Allow",
         "Principal": {
           "AWS":
            [
              "${data.terraform_remote_state.env_remote_state.eks_worker_role_arn}"
            ]
         },
         "Action": [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion"
         ],
         "Resource": "${aws_s3_bucket.presto_hive_storage.arn}/*"
      }
   ]
}
POLICY
}

resource "local_file" "helm_vars" {
  filename = "${path.module}/outputs/${terraform.workspace}.yaml"

  content = <<EOF
global:
  environment: ${terraform.workspace}
  ingress:
    annotations:
      alb.ingress.kubernetes.io/scheme: "${var.is_internal ? "internal" : "internet-facing"}"
      alb.ingress.kubernetes.io/subnets: "${join(",", data.terraform_remote_state.env_remote_state.public_subnets)}"
      alb.ingress.kubernetes.io/security-groups: "${data.terraform_remote_state.env_remote_state.allow_all_security_group}"
      alb.ingress.kubernetes.io/certificate-arn: "${data.terraform_remote_state.env_remote_state.tls_certificate_arn}"
      alb.ingress.kubernetes.io/tags: scos.delete.on.teardown=true
      alb.ingress.kubernetes.io/actions.redirect: '{"Type": "redirect", "RedirectConfig":{"Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
      kubernetes.io/ingress.class: alb
  objectStore:
    bucketName: ${aws_s3_bucket.presto_hive_storage.bucket}
metastore:
  deploy:
    container:
      tag: ${var.image_tag}
  allowDropTable: ${var.allow_drop_table ? "true": "false"}
presto:
  deploy:
    container:
      tag: ${var.image_tag}
  ingress:
    hosts:
    - "presto.${data.terraform_remote_state.env_remote_state.internal_dns_zone_name}/*"
    annotations:
      alb.ingress.kubernetes.io/healthcheck-path: /v1/cluster
    serviceName: redirect
    servicePort: use-annotation
postgres:
  enable: false
  service:
    externalAddress: ${aws_db_instance.metastore_database.address}
  db:
    name: ${aws_db_instance.metastore_database.name}
    user: ${aws_db_instance.metastore_database.username}
    password: ${aws_db_instance.metastore_database.password}
hive:
  enable: false
minio:
  enable: false
EOF
}

resource "null_resource" "helm_deploy" {
  provisioner "local-exec" {
    command = <<EOF
set -ex

cd ../charts

export KUBECONFIG=${local_file.kubeconfig.filename}

export AWS_DEFAULT_REGION=us-east-2

helm upgrade --install kdp . --namespace kdp \
    -f ${local_file.helm_vars.filename} \
    -f ../helm_config/${var.environment}_values.yaml
EOF
  }

  triggers {
    # Triggers a list of values that, when changed, will cause the resource to be recreated
    # ${uuid()} will always be different thus always executing above local-exec
    hack_that_always_forces_null_resources_to_execute = "${uuid()}"
  }
}

variable "is_internal" {
  description = "Should the ALBs be internal facing"
  default     = true
}

variable "alm_region" {
  description = "Region of ALM resources"
  default     = "us-east-2"
}

variable "alm_role_arn" {
  description = "The ARN for the assume role for ALM access"
  default     = "arn:aws:iam::199837183662:role/jenkins_role"
}

variable "os_region" {
  description = "Region of OS resources"
  default     = "us-west-2"
}

variable "os_role_arn" {
  description = "The ARN for the assume role for OS access"
}

variable "state_bucket" {
  description = "The name of the S3 state bucket for ALM"
  default     = "scos-alm-terraform-state"
}

variable "image_tag" {
  description = "The tag to deploy the component images"
  default     = "latest"
}

variable "environment" {
  description = "The environment to deploy kdp to"
}

variable "metastore_instance_class" {
  description = "The size of the hive metastore rds instance"
  default     = "db.t3.small"
}

variable "allow_drop_table" {
  description = "Configures presto to allow drop, rename table and columns"
  default     = false
}
