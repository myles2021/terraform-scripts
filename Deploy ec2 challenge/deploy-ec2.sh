S3NAME="terraformstate$(date | md5sum | head -c 8)" 

aws s3api create-bucket \
    --bucket $S3NAME \
    --region us-west-2 \
    --create-bucket-configuration \
    LocationConstraint=us-west-2
    
aws s3api put-bucket-encryption \
    --bucket $S3NAME \
    --server-side-encryption-configuration={\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}
    
aws s3api put-bucket-versioning --bucket $S3NAME --versioning-configuration Status=Enabled

aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions \
        AttributeName=LockID,AttributeType=S \
    --key-schema \
        AttributeName=LockID,KeyType=HASH \
    --region us-west-2 \
    --provisioned-throughput \
        ReadCapacityUnits=20,WriteCapacityUnits=20

mkdir lab && cd $_
mkdir modules && cd $_
mkdir ec2 && cd $_
touch main.tf variables.tf

printf 'terraform {\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = ">=3.7.0"\n    }\n  }\n}\ndata "aws_ami" "default" {\n  most_recent = "true"\n  filter {\n    name   = "name"\n    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]\n  }\n  filter {\n    name   = "virtualization-type"\n    values = ["hvm"]\n  }\n  owners = ["099720109477"]\n}\nresource "aws_instance" "server" {\n    ami           = var.ami != "" ? var.ami : data.aws_ami.default.image_id\n    instance_type = var.instance_size\n    tags = {\n        Name = "cloudacademylabs"\n    }\n}\n' >> main.tf
printf 'variable "servername"{\n    description = "Name of the server"\n    type = string\n}\nvariable "ami" {\n    description = "AMI ID to deploy"\n    type = string\n    default = ""\n}\nvariable "instance_size" {\n    description = "Size of the EC2 instance"\n    type = string\n    default = "t2.micro"\n}\n' >> variables.tf

cd ../..
touch main.tf

printf 'terraform {\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = "3.7"\n    }\n  }\n  backend "s3" {\n    bucket = "RENAMEME!"\n    key    = "calabs/production/us-west-2/rslab/terraform.tfstate"\n    region = "us-west-2"\n    dynamodb_table = "terraform-state-lock"\n    encrypt        = true\n  }\n}\nprovider "aws" {\n  region = "us-west-2"\n}\nresource "aws_vpc" "example" {\n  cidr_block = "10.0.0.0/16"\n}\nresource "aws_subnet" "example" {\n  vpc_id     = aws_vpc.example.id\n  cidr_block = "10.0.1.0/24"\n  availability_zone = "us-west-2a"\n  tags = {\n    Name = "cloudacademylabs"\n  }\n}\nmodule "webserver" {\n    source = "./modules/ec2"\n    ami = "ami-0528a5175983e7f28"\n    servername = "cloudacademylabs"\n    instance_size = "t2.micro"\n}\n' >> main.tf

sed -i 's/RENAMEME!/'"${S3NAME}"'/g' main.tf

terraform init
terraform apply
yes | command-that-asks-for-input

aws s3 ls s3://$S3NAME/calabs/production/us-west-2/rslab/
