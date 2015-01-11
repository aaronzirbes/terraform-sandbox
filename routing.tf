# Routing table for DMZ (public) subnets

resource "aws_route_table" "dmz" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}

resource "aws_route_table_association" "dmz" {
    subnet_id = "${aws_subnet.dmz.id}"
    route_table_id = "${aws_route_table.dmz.id}"
}

# Routing table for internal (private) subnets

resource "aws_route_table" "internal" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }
}

resource "aws_route_table_association" "internal" {
    subnet_id = "${aws_subnet.internal.id}"
    route_table_id = "${aws_route_table.internal.id}"
}

