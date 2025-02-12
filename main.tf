# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
    aws_key = "CLD_AWS_KEY"   # SSH key pair name for EC2 instance access
}

# Configure the S3 backend for storing the Terraform state
terraform {
  backend "s3" {
    bucket         = "aws-terraform-check-status-tf-bucket"
    key            = "tfstate-folder/terraform.tfstate"
    region         = "us-east-1"
    encrypt = false
  }
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "${local.aws_key}"          # Specify the SSH key pair name
   vpc_security_group_ids = [aws_security_group.my_sg.id]
   user_data = filebase64("wp_install.sh")
  
   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }                  
}
