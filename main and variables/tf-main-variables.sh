aws configure
mkdir tf-main-variables && cd $_
code main.tf
# provider "aws" {
#     region                  = "eu-west-2"
#     shared_credentials_file = "~/.aws/credentials"
# }
# resource "aws_instance" "EC2" {
#     ami           = var.ami-id
#     instance_type = var.instance-type
#     key_name      = var.pem-key

# }

code variables.tf
# variable "ami-id" {
#     description = "AMI ID of ubuntu 20.04LTS eu-west-2"
#     default     = "ami-0015a39e4b7c0966f"
# }
# variable "instance-type" {
#     description = "Free tier EC2 Instance type"
#     default     = "t2.micro"
# }
# variable "pem-key" {
#     description = "Associated Key to SSH into the EC2 Instance"
#     default     = "# NAME OF PEM KEY"
# }

terraform init
terraform plan
terraform apply
terraform destroy
