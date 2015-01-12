/* Auto-scaling Front End App */

/* The OEM Portal Web Frontend. */
resource "aws_instance" "frontend" {

    ami = "${lookup(var.ubuntu_amis, var.aws_region)}"
    instance_type = "m1.small"
    key_name = "aaronzirbes"
    security_groups = [
        "${aws_security_group.http.id}",
        "${aws_security_group.ssh.id}"
    ]
    subnet_id = "${aws_subnet.dmz.id}"
    availability_zone = "${var.aws_availability_zone}"

    depends_on = "aws_internet_gateway.gw"

    tags = { 
        Environment = "${var.aws_environment}"
    }

    # TODO: Add consul host
    user_data = "consul_address=192.0.0.1"
    #user_data = "consul_address=${aws_elb.consul.server_address}"
}

resource "aws_eip" "frontend" {
    instance = "${aws_instance.frontend.id}"
    vpc = true

    connection {
        user = "ubuntu"
        key_file = "${var.aws_key_path}"
        timeout = "90s"
        host = "${aws_eip.frontend.public_ip}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get -y install nginx"
        ]
    }
}

/* Register the frontend's IP address */
resource "aws_route53_record" "frontend" {
   zone_id = "${aws_route53_zone.primary.zone_id}"
   name = "frontend.${aws_route53_zone.primary.name}"
   type = "A"
   ttl = "90"

   # records = ["${aws_elb.frontend.public_ip}"]
   records = ["${aws_eip.frontend.public_ip}"]
}

/* To ELB or EIP? That is the question.
resource "aws_elb" "frontend" {
    name = "frontent-elb"

    # The same availability zone as our instance
    availability_zones = ["${var.availability_zone}"]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    # The instance is registered automatically
    #instances = ["${aws_instance.frontend.id}"]
}

resource "aws_launch_configuration" "frontend" {
    name = "frontend-scaling-config"
    image_id = "${lookup(var.ubuntu_amis, var.aws_region)}"
    instance_type = "m1.small"
    key_name = "aaronzirbes"
    security_groups = [
        "${aws_security_group.http.id}",
        "${aws_security_group.ssh.id}"
    ]
    user_data = "consul_address=192.0.0.1"

    # user_data = "consul_address=${module.consul.server_address}"
}

resource "aws_autoscaling_group" "frontend" {
    availability_zones = ["${var.aws_availability_zone}"]
    name = "frontend-scaling-group"
    max_size = 3
    min_size = 1
    health_check_grace_period = 300
    health_check_type = "ELB"
    desired_capacity = 2
    force_delete = true
    launch_configuration = "${aws_launch_configuration.frontend.name}"
}
*/
