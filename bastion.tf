# Bastion
resource "aws_instance" "bastion" {
    ami = "${lookup(var.ubuntu_amis, var.aws_region)}"
    availability_zone = "${var.aws_availability_zone}"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.ssh.id}"]
    subnet_id = "${aws_subnet.dmz.id}"

    connection {
        user = "ubuntu"
        key_file = "${var.aws_key_path}"
    }

    # Provision SSH key
    provisioner "file" {
        source = "${var.aws_key_path}"
        destination = "/home/ubuntu/.ssh/id_rsa"
    }
}

resource "aws_eip" "bastion" {
    instance = "${aws_instance.bastion.id}"
    vpc = true
}
