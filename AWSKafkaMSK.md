# Create and Connect to AWS Kafka MSK Cluster using IAM and SASL Authenticaiton


# Kafka Download

https://kafka.apache.org/downloads 


# Create authorization policies for the IAM role

/root/kafka_2.12-3.6.0/config/client.properties

https://docs.aws.amazon.com/msk/latest/developerguide/create-iam-access-control-policies.html


# Configure clients for IAM access control

/root/kafka_2.12-3.6.0/libs/

https://docs.aws.amazon.com/msk/latest/developerguide/configure-clients-for-iam-access-control.html 

https://github.com/aws/aws-msk-iam-auth/releases 


# Create

bin/kafka-topics.sh --create --topic sample-topic --command-config config/client.properties --bootstrap-server b-2.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9098,b-1.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9098

# Producer

bin/kafka-console-producer.sh --topic sample-topic --producer.config config/client.properties --bootstrap-server b-2.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9098,b-1.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9098

# Consumer

bin/kafka-console-consumer.sh --topic sample-topic --consumer.config config/client.properties --bootstrap-server b-2.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9098,b-1.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9098



Kafka UI: 

Download the Jar file
https://github.com/kafbat/kafka-ui/releases/
wget https://github.com/kafbat/kafka-ui/releases/download/v1.2.0/api-v1.2.0.jar

EC2 instance: 

sudo dnf install java-21-amazon-corretto

https://docs.kafka-ui.provectus.io/configuration/authentication/sasl_scram

Configuring by application.yaml

kafka:
  clusters:
    - name: local
      bootstrapServers: b-1.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9096,b-2.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9096,b-1.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9098,b-2.demokafka.qkih0u.c18.kafka.us-east-1.amazonaws.com:9098
      properties:
        security.protocol: SASL_SSL
        sasl.mechanism: SCRAM-SHA-512        
        sasl.jaas.config: org.apache.kafka.common.security.scram.ScramLoginModule required username="<KAFKA_USERNAME>" password="<KAFKA_PASSWORD>";


execute below command: 
java -Dspring.config.additional-location=application.yaml -jar 


