mkdir terraformlab && cd $_
touch main.tf

printf '\nterraform {\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = "3.7"\n    }\n  }\n}\nprovider "aws" {\n  region = "us-west-2"\n}\nresource "aws_vpc" "example" {\n  cidr_block = "10.0.0.0/16"\n}\n' >> main.tf

terraform init
terraform plan
terraform apply
yes | command-that-asks-for-input
terraform destroy
yes | command-that-asks-for-input
