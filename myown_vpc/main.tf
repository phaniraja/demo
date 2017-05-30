#creating vpc

resource "aws_vpc" "main" {
    cidr_block = "${var.cidr_block}"
    instance_tenancy = "default"

    tags {
        Name = "${var.vpc_name}"
    }
}


# creating internet gateway

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "main"
    }
}

# creating public subnet

resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"

    tags {
        Name = "publicsubnet"
    }
}

#creating private subnet

resource "aws_subnet" "main1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.2.0/24"

    tags {
        Name = "Main"
    }
}


# creating routtable and assing it to public subnet and associta to igw

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "10.0.1.0/24"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "main"
    }
}


# creating natgateway

resource "aws_nat_gateway" "ngw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.publicsubnet.id}"
}







