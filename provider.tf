variable "aws_access_key" {
    description = "AWS Access Key"
}

variable "aws_secret_key" {
    description = "AWS Secret Key"
}

variable "aws_key_name" {
    description = "Name of the SSH keypair to use in AWS."
}

variable "aws_key_path" {
    description = "Path to the SSH key pair."
}

# AWS Creds
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}
