cd terraformlab/
touch main.tf

printf '\nterraform {\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = "3.7"\n    }\n  }\n}\nprovider "aws" {\n  region = "us-west-2"\n}\nresource "aws_dynamodb_table_item" "example" {\n  table_name = "example-name"\n  hash_key   = "exampleHashKey"\n  item = <<ITEM\n{\n  "exampleHashKey": {"S": "something"},\n  "one": {"N": "11111"},\n  "two": {"N": "22222"},\n  "three": {"N": "33333"},\n  "four": {"N": "44444"}\n}\nITEM\n}\nresource "aws_dynamodb_table" "example" {\n  name           = "example-name"\n  read_capacity  = 10\n  write_capacity = 10\n  hash_key       = "exampleHashKey"\n  attribute {\n    name = "exampleHashKey"\n    type = "S"\n  }\n}\n' >> main.tf

terraform init

terraform apply
yes | command-that-asks-for-input

terraform graph

printf '\nterraform {\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = "3.7"\n    }\n  }\n}\nprovider "aws" {\n  region = "us-west-2"\n}\nresource "aws_dynamodb_table_item" "example" {\n  table_name = aws_dynamodb_table.example.name\n  hash_key   = aws_dynamodb_table.example.hash_key\n  item = <<ITEM\n{\n  "exampleHashKey": {"S": "something"},\n  "one": {"N": "11111"},\n  "two": {"N": "22222"},\n  "three": {"N": "33333"},\n  "four": {"N": "44444"}\n}\nITEM\n}\nresource "aws_dynamodb_table" "example" {\n  name           = "example-name"\n  read_capacity  = 10\n  write_capacity = 10\n  hash_key       = "exampleHashKey"\n  attribute {\n    name = "exampleHashKey"\n    type = "S"\n  }\n}\n' >> main.tf

terraform apply
yes | command-that-asks-for-input

terraform graph

terraform destroy
yes | command-that-asks-for-input

