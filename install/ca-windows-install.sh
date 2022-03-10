# Terraform is written in Golang, this gives is many advantages and one of them is the ability to easily provide a binary to a diverse range of platforms. Installing Terraform on a Windows platform involves downloading the binary and adding the directory to the PATH environment variable.

# Connecting to an EC2 instance and install Terraform on a Windows Server using PowerShell.

mkdir C:\terraform
cd C:\terraform
Invoke-WebRequest -Uri https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_windows_amd64.zip -outfile terraform_0.13.4_windows_amd64.zip
Expand-Archive -Path .\terraform_0.13.4_windows_amd64.zip -DestinationPath .\
rm .\terraform_0.13.4_windows_amd64.zip -Force
setx PATH "$env:path;C:\terraform" -m
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
terraform version
