variable "consul_servers" {
    default = "3"
    description = "The number of Consul servers to launch."
}

resource "aws_instance" "consul" {
    ami = "${lookup(var.ubuntu_amis, var.aws_region)}"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    count = "${var.consul_servers}"
    security_groups = [
        "${aws_security_group.consul.id}",
        "${aws_security_group.ssh.id}"
    ]
    subnet_id = "${aws_subnet.dmz.id}"
    availability_zone = "${var.aws_availability_zone}"

    connection {
        user = "ubuntu"
        key_file = "${var.aws_key_path}"
        timeout = "90s"
        host = "${aws_eip.frontend.public_ip}"
    }

    provisioner "file" {
        source = "scripts/upstart.conf"
        destination = "/tmp/upstart.conf"
    }

    provisioner "file" {
        source = "scripts/upstart-join.conf"
        destination = "/tmp/upstart-join.conf"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.consul_servers} > /tmp/consul-server-count",
            "echo ${aws_instance.consul.0.private_dns} > /tmp/consul-server-addr"
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "scripts/install.sh",
            "scripts/server.sh",
            "scripts/service.sh"
        ]
    }
}

