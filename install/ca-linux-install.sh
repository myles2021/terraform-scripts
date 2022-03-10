# Installing Terraform on a Linux platform is similar to Windows. This time the binary is moved to the /usr/local/bin directory.

# Connecting to an EC2 instance and install Terraform on a Linux Server.

cd ~/
wget https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip
unzip terraform_0.13.4_linux_amd64.zip
sudo mv terraform /usr/local/bin
terraform version
