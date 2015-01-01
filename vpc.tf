variable "aws_environment" {
    default = "dev"
    description = "The environment to launch (dev, qa, staging, prod)"
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
