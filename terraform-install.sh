curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt upgrade -y && sudo apt-get install terraform -y
terraform --version
mkdir example_1
cd example_1/
code main.tf
provider "aws" {
    access_key = "# input access key"
    secret_key = "# input secret key"
    region = "eu-west-2"
}

resource "aws_instance" "example" {
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
}

terraform init
terraform plan
terraform apply
# terraform destroy
