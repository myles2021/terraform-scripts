mkdir terraformlab && cd $_
mkdir modules && cd $_
mkdir ec2 && cd $_
touch main.tf variables.tf
printf 'terraform {\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = ">=3.7.0"\n    }\n  }\n}\ndata "aws_ami" "default" {\n  most_recent = "true"\n  filter {\n    name   = "name"\n    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]\n  }\n  filter {\n    name   = "virtualization-type"\n    values = ["hvm"]\n  }\n  owners = ["099720109477"]\n}\nresource "aws_instance" "server" {\n    ami           = var.ami != "" ? var.ami : data.aws_ami.default.image_id\n    instance_type = var.instance_size\n    tags = {\n        Name = "calabvm"\n    }\n}\n' >> main.tf
printf 'variable "servername"{\n    description = "Name of the server"\n    type = string\n}\nvariable "ami" {\n    description = "AMI ID to deploy"\n    type = string\n    default = ""\n}\nvariable "instance_size" {\n    description = "Size of the EC2 instance"\n    type = string\n    default = "t2.micro"\n}\n' >> variables.tf
cd ../..
touch main.tf
printf 'terraform {\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = "3.7"\n    }\n  }\n}\nprovider "aws" {\n  region = "us-west-2"\n}\nmodule "webserver" {\n    source = "./modules/ec2"\n    servername = "calabvm"\n    instance_size = "t2.micro"\n}\n' >> main.tf
terraform init
terraform plan
# add ami = "ami-0528a5175983e7f28" under source in module of terraformlab/main.tf
terraform apply
