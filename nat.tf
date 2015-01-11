# NAT instance

resource "aws_instance" "nat" {
    ami = "${lookup(var.ubuntu_amis, var.aws_region)}"
    availability_zone = "${var.aws_availability_zone}"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.dmz.id}"
    associate_public_ip_address = true
    source_dest_check = false
}

resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}
