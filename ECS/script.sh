#!/bin/bash

image_name="hello_world:latest"
repo_name="hello-image"

# build docker image
docker build --no-cache -t $image_name .

# Retrieve an authentication token and authenticate your Docker client to your registry
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws-account-number>.dkr.ecr.<region>.amazonaws.com

# Create the Repository to push the image
aws ecr create-repository --repository-name $repo_name

# Tag image so you can push the image to this repository
docker tag $image_name <aws-account-number>.dkr.ecr.<region>.amazonaws.com/$repo_name

# Push the image to ECR 
docker push <aws-account-number>.dkr.ecr.<region>.amazonaws.com/$image_name

# create the new revision of the task defination 
ecs deploy cluster-name service-name --no-deregister --image container-name image-name --tag tag-name

# update the service 
ecs scale cluster-name service-name count
