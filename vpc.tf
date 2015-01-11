variable "aws_environment" {
    default = "dev"
    description = "The environment to launch (dev, qa, staging, prod)"
}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "us-east-1"
}

variable "aws_availability_zone" {
    description = "AWS availability zone to launch servers."
    default = "us-east-1b"
}

resource "aws_vpc" "main" {
    cidr_block = "172.29.0.0/16"
    tags = {
        Environment = "${var.aws_environment}"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"
}

/*
resource "aws_key_pair" "aaronzirbes" {
    key_name = "aaronzirbes"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9YrNRgdFP7GUUu+YJdFx1N/htxqLw7qgrhji2zCB/WWPdWfSx78LeNoA/5HVY4dHmB9pQQj4ahf+1qe62tn1nsmeQC7B3vYo1UPHrlt7ZrK6het73huWs/iJu6mZkmYWO2Wkr4uIJMaUAEJFbEeSoEnmQb7aN68KyxH03dbEd/DbvYtRrTMOKqcWCuApZyTyD8rAhU52APH63sLrMWUtP/+d9NhSOqRrRtWksu1brftzL1h2NhfXiEsYkY2/1DwkafqQWx1C73+xzUwmaz0D4mVFtRPNTwc6Nfh1wBqCjoDlwvl2+AWHSu6Qy6QdVJyO5b8JOg8Xs7B9ZJ8stK4N9 aaronzirbes"
}
*/
