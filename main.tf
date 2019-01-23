provider "aws" {
  version = "1.39"
  region  = "${var.region}"

  assume_role {
    role_arn = "${var.role_arn}"
  }
}

data "terraform_remote_state" "env_remote_state" {
  backend   = "s3"
  workspace = "${terraform.workspace}"

  config {
    bucket   = "${var.state_bucket}"
    key      = "operating-system"
    region   = "${var.region}"
    role_arn = "${var.role_arn}"
  }
}

resource "local_file" "kubeconfig" {
  filename = "${path.module}/outputs/kubeconfig"
  content  = "${data.terraform_remote_state.env_remote_state.eks_cluster_kubeconfig}"
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
presto:
  ingress:
    hosts:
    - "presto.${data.terraform_remote_state.env_remote_state.dns_zone_name}/*"
    annotations:
      alb.ingress.kubernetes.io/healthcheck-path: /v1/cluster
minio:
  ingress:
    hosts:
    - "minio.${data.terraform_remote_state.env_remote_state.dns_zone_name}/*"
    annotations:
      alb.ingress.kubernetes.io/healthcheck-path: /minio/health/live
EOF
}

resource "null_resource" "helm_deploy" {
  provisioner "local-exec" {
    command = <<EOF
set -x

export KUBECONFIG=${local_file.kubeconfig.filename}

export AWS_DEFAULT_REGION=us-east-2

helm upgrade --install kdp . --namespace kdp \
    --values ${local_file.helm_vars.filename}
EOF
  }

  triggers {
    # Triggers a list of values that, when changed, will cause the resource to be recreated
    # ${uuid()} will always be different thus always executing above local-exec
    hack_that_always_forces_null_resources_to_execute = "${uuid()}"
  }
}

variable "region" {
  description = "Region of ALM resources"
  default     = "us-east-2"
}

variable "is_internal" {
  description = "Should the ALBs be internal facing"
  default     = false
}

variable "role_arn" {
  description = "The ARN for the assume role for ALM access"
  default     = "arn:aws:iam::199837183662:role/jenkins_role"
}

variable "state_bucket" {
  description = "The name of the S3 state bucket for ALM"
  default     = "scos-alm-terraform-state"
}

variable "image_tag" {
  description = "The tag to deploy the component images"
  default     = "latest"
}