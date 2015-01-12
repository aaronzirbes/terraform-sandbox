# Bastion host

resource "aws_instance" "bastion" {
    ami = "${lookup(var.ubuntu_amis, var.aws_region)}"
    availability_zone = "${var.aws_availability_zone}"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.ssh.id}"]
    subnet_id = "${aws_subnet.dmz.id}"
}

resource "aws_eip" "bastion" {
    instance = "${aws_instance.bastion.id}"
    vpc = true

    connection {
        user = "ubuntu"
        key_file = "${var.aws_key_path}"
        timeout = "90s"
        host = "${aws_eip.bastion.public_ip}"
    }

    /*
    # Provision SSH key
    provisioner "file" {
        source = "${var.aws_key_path}"
        destination = "/home/ubuntu/.ssh/id_rsa"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod 0400 ~/.ssh/id_rsa"
        ]
    }
    */

}

/* Register the bastion's IP address */
resource "aws_route53_record" "bastion" {
   zone_id = "${aws_route53_zone.primary.zone_id}"
   name = "bastion.${aws_route53_zone.primary.name}"
   type = "A"
   ttl = "90"

   records = ["${aws_eip.bastion.public_ip}"]
}
