mkdir terraform_resources_example && cd $_
code main.tf
# provider "aws" {
#     region = "eu-west-2"
#     alias  = "aws-uk"
# }

# variable "ami-uk" {
#     description = "machine image uk"
#     default     = "ami-0015a39e4b7c0966f"
# }

# variable "type" {
#     default = "t2.micro"
# }

# variable "zone" {
#     description = "map of availability zones for eu-west-2"
#     default     = {
#         1 = "eu-west-2a"
#         2 = "eu-west-2b"
#     }
# }

# resource "aws_instance" "example" {
#     provider = "aws.aws-uk"
#     for_each = var.zone
#     availability_zone = each.value
#     ami           = var.ami-uk
#     instance_type = var.type

#     lifecycle {
#         prevent_destroy = true
#     }

#     timeouts {
#         create = "5m"
#         delete = "2h"
#     }
# }

terraform fmt
terraform init
terraform plan
terraform apply
code main.tf
# remove the prevent_destroy meta argument
terraform destroy
