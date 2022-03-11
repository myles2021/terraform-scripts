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
 
mkdir tflab && cd $_
touch main.tf

printf '\nterraform {\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = "3.7"\n    }\n  }\n  backend "s3" {\n    bucket = "RENAMEME!"\n    key    = "calabs/production/us-west-2/rslab/terraform.tfstate"\n    region = "us-west-2"\n    dynamodb_table = "terraform-state-lock"\n    encrypt        = true\n  }\n}\nprovider "aws" {\n  region = "us-west-2"\n}\nresource "aws_vpc" "example" {\n  cidr_block = "10.0.0.0/16"\n}\nresource "aws_subnet" "example" {\n  vpc_id     = aws_vpc.example.id\n  cidr_block = "10.0.1.0/24"\n  availability_zone = "us-west-2a"\n  tags = {\n    Name = "calabvm-subnet"\n  }\n}\n' >> main.tf

sed -i 's/RENAMEME!/'"${S3NAME}"'/g' main.tf

terraform init

terraform apply
yes | command-that-asks-for-input

aws s3 ls s3://$S3NAME/calabs/production/us-west-2/rslab/


