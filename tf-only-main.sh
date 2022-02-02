aws configure
mkdir tf-only-main && cd $_
code main.tf
# provider "aws" {
#     region                  = "eu-west-2"
#     shared_credentials_file = "~/.aws/credentials"
# }
# Creating an EC2 Instance requires a resource block using "aws_instance". This tells terraform that we want to create an EC2 Instance. Copy and paste the following code:
# resource "aws_instance" "EC2" {
#     ami           = "ami-0015a39e4b7c0966f"
#     instance_type = "t2.micro"
#     key_name      = "# UNIQUE KEY PAIR NAME"
# }

terraform init
terraform plan
terraform apply
terraform destroy
