/* Security Groups and stuff */
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

/* Security Groups and stuff */
resource "aws_security_group" "http_https_ssh" {

    name = "http_https_ssh"
    description = "Allow all inbound TCP/UDP traffic"
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
