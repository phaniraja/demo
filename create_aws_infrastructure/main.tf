#
# create VPC and assign cidr,vpc_name
#


resource "aws_vpc" "cluster" {
    cidr_block = "${var.cidr_block}"
    instance_tenancy = "default"
    tags {
        Name = "${var.vpc_name}"
    }

}

#
# create internet gateway and assign to VPC
#

resource "aws_internet_gateway" "cluster" {
    vpc_id = "${aws_vpc.cluster.id}"

    tags {
        Name = "${var.vpc_name}"
    }
}

#
# create public subnet and assign to VPC
#

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.cluster.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
        Name = "${var.public_subnet_name}"
    }

}

#
# create route table and create route table entry 0.0.0.0/0 to internet gateway
#

resource "aws_route_table" "cluster" {
    vpc_id = "${aws_vpc.cluster.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cluster.id}"
    }

    tags {
        Name = "${var.route_table_public_name}"
    }
}

#
# Associate route table to public subnet
#

resource "aws_route_table_association" "cluster" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.cluster.id}"
}

#
# create EIP for NAT gateway
#

resource "aws_eip" "nat" {
  vpc      = true
}


#
# create NAT gateway
#

resource "aws_nat_gateway" "cluster" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.public.id}"
}

#
# create private subnet and assign to VPC
#

resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.cluster.id}"
  cidr_block              = "10.0.2.0/24"

  tags {
        Name = "${var.private_subnet_name}"
    }

}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.cluster.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.cluster.id}"
    }

    tags {
        Name = "${var.route_table_private_name}"
    }
}

#
# Associate route table to public subnet
#

resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}

#
# create EC2 instance and assign to public subnet
#

resource "aws_instance" "webserver" {
    ami = "ami-5e63d13e"
    subnet_id = "${aws_subnet.public.id}"
    instance_type = "t2.micro"
    key_name = "phani_aws"
    tags {
        Name = "webserver"
    }
}

#
# create EC2 instance and assign to public subnet
#

resource "aws_instance" "dbserver" {
    ami = "ami-5e63d13e"
    subnet_id = "${aws_subnet.private.id}"
    instance_type = "t2.micro"
    key_name = "phani_aws"
    tags {
        Name = "dbserver"
    }
}

