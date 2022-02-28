# using the branch model to deploy two ec2 instances in two different regions

mkdir tf-branch-model-2 && cd $_ && mkdir environments modules && cd environments && mkdir production staging && touch production/production.tf production/production.tfvars staging/staging.tf staging/staging.tfvars && cd ../modules && mkdir infrastructure && cd infrastructure && touch main.tf output.tf variables.tf
mkdir ec2 && cd $_ && touch main.tf output.tf variables.tf
cd .. && mkdir vpc && cd $_ && touch main.tf output.tf variables.tf
cd .. && mkdir subnets && cd $_ && touch main.tf output.tf variables.tf
cd ..

printf 'module "vpc" {\n   source      = "./vpc"\n\n   environment = var.environment\n   region      = var.region\n }\n module "ec2" {\n   source      = "./ec2"\n\n   environment       = var.environment\n   region            = var.region\n   ami_id            = var.ami_id\n   public_subnet_id  = module.subnets.public_subnet_id\n   private_subnet_id = module.subnets.private_subnet_id\n }\n module "subnets" {\n   source      = "./subnets"\n\n   environment = var.environment\n   region      = var.region\n   vpc_id      = module.vpc.vpc_id\n }' >> main.tf

printf 'variable "environment" {\n}\nvariable "region" {\n}\nvariable "ami_id" {\n}' >> variables.tf

printf 'resource "aws_vpc" "main" {\n  cidr_block = "10.0.0.0/16"\n\n  tags = {\n    Name = "${var.region}-${var.environment}-vpc"\n  }\n}' >> vpc/main.tf

printf 'resource "aws_subnet" "public_subnet" {\n  vpc_id     =  "${var.vpc_id}"\n  cidr_block = "10.0.0.0/24"\n\n  tags = {\n    Name = "${var.environment}-${var.region}-Public-Subnet"\n  }\n}\nresource "aws_subnet" "private_subnet" {\n  vpc_id     =  "${var.vpc_id}"\n  cidr_block = "10.0.1.0/24"\n\n  tags = {\n    Name = "${var.environment}-${var.region}-Private-Subnet"\n  }\n}' >> subnets/main.tf

printf 'resource "aws_instance" "public_instance" {\n   ami                         = "${var.ami_id}"\n   instance_type               = "t2.micro"\n   subnet_id                   = "${var.public_subnet_id}"\n   associate_public_ip_address = true\n tags = {\n    Name = "${var.environment}-${var.region}-Public"\n  }\n}\nresource "aws_instance" "private_instance" {\n   ami                         = "${var.ami_id}"\n   instance_type               = "t2.micro"\n   subnet_id                   = "${var.private_subnet_id}"\n   associate_public_ip_address = false\n tags = {\n    Name = "${var.environment}-${var.region}-Private"\n  }\n}' >> ec2/main.tf

cd ../../environments

printf 'variable "environment" {\n}\nvariable "region" {\n}\nvariable "access_key" {\n}\nvariable "secret_key" {\n}\nvariable "ami_id" {\n}\nprovider "aws" {\n   region = var.region\n   version = "~> 2.7"\n   access_key = var.access_key\n   secret_key = var.secret_key\n}\nmodule "infrastructure" {\n   source      = "../../modules/infrastructure"\n   environment = var.environment\n   region      = var.region\n   ami_id      = var.ami_id\n}' >> production/production.tf

printf '# Operates in London\nenvironment  = "production"\nregion       = "eu-west-2"\naccess_key   = "input access key"\nsecret_key   = "input secret key"\nami_id       = "ami-0015a39e4b7c0966f"' >> production/production.tfvars
          
printf 'variable "environment" {\n}\nvariable "region" {\n}\nvariable "access_key" {\n}\nvariable "secret_key" {\n}\nvariable "ami_id" {\n}\nprovider "aws" {\n   region = var.region\n   version = "~> 2.7"\n   access_key = var.access_key\n   secret_key = var.secret_key\n}\nmodule "infrastructure" {\n   source      = "../../modules/infrastructure"\n   environment = var.environment\n   region      = var.region\n   ami_id      = var.ami_id\n}' >> staging/staging.tf

printf '# Operates in Ireland\nenvironment  = "staging"\nregion       = "eu-west-1"\naccess_key   = "input access key"\nsecret_key   = "input secret key"\nami_id       = "ami-0713f98de93617bb4"' >> staging/staging.tfvars

cd staging
terraform init
terraform plan --var-file=staging.tfvars -out=stagingplan
terraform apply "stagingplan"
# terraform destroy --var-file=staging.tfvars
