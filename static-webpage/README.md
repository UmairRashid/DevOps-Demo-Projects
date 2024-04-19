## Overview
Host simple static webpage using AWS EC2 through Terrafrom running on docker.

## Pre-requisite
Install Docker and pull this repo. We will use it for terraform.
https://hub.docker.com/r/umairrashid/terraform-terragrunt

## How to run
First run the docker image with mounting this repo path
```
docker run -d --name tf-container -v <local-path-to-your-repository>:/home/repos umairrashid/terraform-terragrunt sh -c "tail -f /dev/null"
```
Make sure to run source command every time you spin container of this image
```
source envs
```
Export your AWS access keys and run terraform init.
```
cd /home/repos/project-1/terraform
terraform init
```
Run terraform code and provide AWS region and AWS keyName
```
terraform apply
```

This will create a EC2 instance with simple Apache server and a Security Group in which your IP is whitelisted.

Can access on http://<your_server_public_DNS>