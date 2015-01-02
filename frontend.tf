/* Auto-scaling Front End App */

# The Ami AMI
variable "frontend_ami" {
    # ubuntu/images/ebs/ubuntu-trusty-14.04-amd64-server-20141125
    default = "ami-64e27e0c"
    description = "the AMI to use for front end"
}

/* The OEM Portal Web Frontend. */
resource "aws_instance" "frontend" {
    ami = "${var.frontend_ami}"
    instance_type = "m1.small"
    key_name = "aaronzirbes"
    security_groups = [ "${aws_security_group.http_https_ssh.id}" ]
    subnet_id = "${aws_subnet.dmz.id}"
    associate_public_ip_address = true
    user_data = "consul_address=192.0.0.1"
    tags = { 
        Environment = "ajz-terraform"
    }

    # TODO: Add provisioning
    # user_data = "consul_address=${module.consul.server_address}"
}

resource "aws_launch_configuration" "frontend" {

    name = "frontend-scaling-config"
    image_id = "${var.frontend_ami}"
    instance_type = "m1.small"
    key_name = "aaronzirbes"
    security_groups = [ "${aws_security_group.http_https_ssh.id}" ]
    user_data = "consul_address=192.0.0.1"

    # user_data = "consul_address=${module.consul.server_address}"
}

resource "aws_autoscaling_group" "frontend" {
  availability_zones = ["us-east-1a"]
  name = "frontend-scaling-group"
  max_size = 3
  min_size = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = 2
  force_delete = true
  launch_configuration = "${aws_launch_configuration.frontend.name}"
}


/* Register the frontend's IP address */
resource "aws_route53_record" "frontend" {
   zone_id = "${aws_route53_zone.primary.zone_id}"
   name = "frontend.${aws_route53_zone.primary.name}"
   type = "A"
   ttl = "90"
   # records = ["${aws_elb.frontend_lb.public_ip}"]
   records = ["${aws_instance.frontend.public_ip}"]
}
