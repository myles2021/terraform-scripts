pip install awscli
aws configure
mkdir terraform-variables-aws-environment-variables && cd $_
code main.tf
# provider "aws" {
#   region = "eu-west-2"
# }

# resource "aws_instance" "example" {
#   ami           = var.ami
#   instance_type = var.type
# }

code variables.tf
# variable "ami" {
#   description = "machine image"
# }

# variable "type" {
#   description = "machine size"
# }

terraform init
terraform plan
TF_VAR_ami
TF_VAR_type

terraform apply
TF_VAR_ami
TF_VAR_type


terraform destroy
