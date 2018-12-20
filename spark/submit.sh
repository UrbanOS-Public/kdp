wget http://www.us.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz
tar -xvf spark-2.4.0-bin-hadoop2.7.tgz
cd spark-2.4.0-bin-hadoop2.7/
docker build -t jarredolson/spark-2.4.0-hadoop-2.7:1.0 -f kubernetes/dockerfiles/spark/Dockerfile .
docker push jarredolson/spark-2.4.0-hadoop-2.7:1.0


opt/spark-2.4.0-bin-hadoop2.7/bin/spark-submit \
 --master k8s://kubernetes:443 \
 --deploy-mode cluster \
 --name spark-pi-$(date +"%s") \
 --class org.apache.spark.examples.SparkPi \
 --conf spark.executor.instances=1 \
 --conf spark.kubernetes.container.image=jarredolson/spark-2.4.0-hadoop-2.7:1.0 \
 --conf spark.kubernetes.driver.pod.name=spark-pi-driver-$(date +"%s") \
 --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark-jalson \
 local:///opt/spark/examples/jars/spark-examples_2.11-2.4.0.jar

CREATE TABLE nifi (stream String) LOCATION 's3a://jeff-jarred-751/hive-s3/peeps';


bin/hive --hiveconf hive.root.logger=DEBUG,console
CREATE TABLE nifi (flow String);
insert into table nifi values ('bbrewer5');


create table nifi4 (flow String) clustered by (flow) into 5 buckets stored as orc tblproperties ('transactional'='true');
ALTER TABLE istari SET TBLPROPERTIES ('transactional' = 'true');

curl http://www.us.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz | tar -zx
cd spark-2.4.0-bin-hadoop2.7/jars

mv spark-network-common_2.11-2.4.0.jar $HIVE_HOME/lib/
mv spark-core_2.11-2.4.0.jar $HIVE_HOME/lib/
mv scala-library-2.11.12.jar $HIVE_HOME/lib/
mv spark-launcher_2.11-2.4.0.jar $HIVE_HOME/lib/

!connect jdbc:hive2://hive-server:10000




Running client driver with argv: 
/usr/local/spark/bin/spark-submit 
--properties-file /tmp/spark-submit.6335086042254747756.properties 
--class org.apache.hive.spark.client.RemoteDriver /usr/local/hive/lib/hive-exec-3.0.0.jar 
--remote-host hive-server-7b6fb84-4xn59 
--remote-port 46751 
--conf hive.spark.client.connect.timeout=1000 
--conf hive.spark.client.server.connect.timeout=90000 
--conf hive.spark.client.channel.log.level=null 
--conf hive.spark.client.rpc.max.size=52428800 
--conf hive.spark.client.rpc.threads=8 
--conf hive.spark.client.secret.bits=256 
--conf hive.spark.client.rpc.server.address=null

