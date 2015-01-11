/* Security Groups and stuff */

resource "aws_security_group" "nat" {
    name = "nat"
    description = "Allow services from the private subnet through NAT"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["${aws_subnet.internal.cidr_block}"]
    }

    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group" "allow_all" {

    name = "allow_all"
    description = "Allow all inbound TCP/UDP traffic"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "allow_all"
    }
}

resource "aws_security_group" "http" {

    name = "http"
    description = "Allow only inbound TCP HTTP(s) traffic"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${aws_subnet.common.cidr_block}"]
        tags {
            Name = "ssh"
        }
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        tags {
            Name = "http"
        }
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        tags {
            Name = "https"
        }
    }

    tags {
        Name = "web_servers"
    }
}


resource "aws_security_group" "ssh" {

    name = "ssh_only_sg"
    description = "Allow all inbound TCP SSH traffic"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        tags {
            Name = "ssh"
        }
    }
}
