#!/usr/bin/env bash

# ==== Resource Group ====
export RESOURCE_GROUP=zhiyongli
export REGION=eastus
export SPRING_CLOUD_SERVICE=zhiyongli-asc-e
export APP_NAME=tanzu101

export APPLICATION_JAR="target/demo-0.0.1-SNAPSHOT.jar"
az cloud set -n AzureCloud
az login
az account set -s "Azure Spring Cloud Dogfood Test v3 - TTL = 1 Days"

# ==== JARS ====
export APPLICATION_JAR="target/demo-0.0.1-SNAPSHOT.jar"

# ==== Create Resource Group ====
# az group create --name ${RESOURCE_GROUP} --location ${REGION}

az configure --defaults \
    group=${RESOURCE_GROUP} \
    location=${REGION} \
    spring-cloud=${SPRING_CLOUD_SERVICE}

# ==== Create Azure Spring Cloud ====
# az spring-cloud create --name ${SPRING_CLOUD_SERVICE} \
#     --resource-group ${RESOURCE_GROUP} \
#     --location ${REGION}

# ==== Create the gateway app ====
az spring-cloud app create --name ${APP_NAME} --instance-count 1 --is-public true 

# ==== Build for cloud ====
# mvn clean package -DskipTests -Denv=cloud

# ==== Deploy apps ====

az spring-cloud app deploy --name ${APP_NAME} --artifact-path ${APPLICATION_JAR} --service ${SPRING_CLOUD_SERVICE} --resource-group ${RESOURCE_GROUP} --verbose

az spring-cloud app deployment create --app ${APP_NAME} --name test --artifact-path ${APPLICATION_JAR} --builder java-builder
                                  