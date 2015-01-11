/*
 * RFC 1918 Subnets!
 */

resource "aws_subnet" "common" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "172.29.0.0/24"
    availability_zone = "${var.aws_availability_zone}"
}

resource "aws_subnet" "dmz" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "172.29.1.0/24"
    availability_zone = "${var.aws_availability_zone}"
}

resource "aws_subnet" "internal" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "172.29.2.0/24"
    availability_zone = "${var.aws_availability_zone}"
}
