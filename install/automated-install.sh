curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt upgrade -y && sudo apt-get install terraform -y
terraform --version
mkdir example_1
cd example_1/
touch main.tf
printf 'provider "aws" {\n    access_key = "# input access key"\n    secret_key = "# input secret key"\n    region = "eu-west-2"\n}\nresource "aws_instance" "example" {\n    ami = "ami-0015a39e4b7c0966f"\n    instance_type = "t2.micro"\n}' >> main.tf

terraform init
terraform plan
terraform apply
# terraform destroy
