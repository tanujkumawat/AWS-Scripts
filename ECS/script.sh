#!/bin/bash

# build docker image
docker build --no-cache -t my-hello-image .

# Retrieve an authentication token and authenticate your Docker client to your registry
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 959764943449.dkr.ecr.us-east-1.amazonaws.com

# Tag image so you can push the image to this repository
docker tag my-hello-image:latest 959764943449.dkr.ecr.us-east-1.amazonaws.com/my-hello-image:latest

# Push the image to ECR 
docker push 959764943449.dkr.ecr.us-east-1.amazonaws.com/my-hello-image:latest

# create the new revision of the task defination 
# for more arguments 
# https://docs.aws.amazon.com/cli/latest/reference/ecs/register-task-definition.html
aws ecs register-task-definition --cli-input-json file://container.json

# update the service 
# for more arguents
# https://docs.aws.amazon.com/cli/latest/reference/ecs/update-service.html
aws ecs update-service --cluster hello-image --service hello-service --task-definition hello-image --desired-count 4
