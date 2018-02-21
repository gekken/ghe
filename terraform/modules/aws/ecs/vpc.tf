# Find the availability_zones
data "aws_availability_zones" "available" {}

# Define the VPC

resource "aws_vpc" "ecs_gheVPC" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "ecs_gheVPC"
  }
}

# Define the Public Subnet

resource "aws_subnet" "ecs_ghePSN01" {
  vpc_id = "${aws_vpc.ecs_gheVPC.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags {
    Name = "ecs_ghePSN-1"
  }
}

resource "aws_subnet" "ecs_ghePSN02" {
  vpc_id = "${aws_vpc.ecs_gheVPC.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
    Name = "ecs_ghePSN-2"
  }
}

# Define the IG and place in the VPC

resource "aws_internet_gateway" "ecs_gheIG" {
  vpc_id = "${aws_vpc.ecs_gheVPC.id}"
  tags {
    Name = "ecs_gheIG"
  }
}

# Set route table

resource "aws_route_table" "ecs_ghePSN01-RT" {
  vpc_id = "${aws_vpc.ecs_gheVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ecs_gheIG.id}"
  }
  tags {
    Name = "ecs_ghePubSN01-RT"
  }
}

resource "aws_route_table" "ecs_ghePSN02-RT" {
  vpc_id = "${aws_vpc.ecs_gheVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ecs_gheIG.id}"
  }
  tags {
    Name = "ecs_ghePubSN02-RT"
  }
}


# associate routing for ecs_ghePSN

resource "aws_route_table_association" "ecs_ghePSN01-RtAssc" {
  subnet_id = "${aws_subnet.ecs_ghePSN01.id}"
  route_table_id = "${aws_route_table.ecs_ghePSN01-RT.id}"
}

resource "aws_route_table_association" "ecs_ghePSN02-RtAssc" {
  subnet_id = "${aws_subnet.ecs_ghePSN02.id}"
  route_table_id = "${aws_route_table.ecs_ghePSN02-RT.id}"
}


# Ingress SG

resource "aws_security_group" "ecs_ghePubSG" {
  name = "ingress_public_SG"
  description = "Ingress Security Group for GHE ECS demo"
  vpc_id = "${aws_vpc.ecs_gheVPC.id}"

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP - not setting up HTTPS for this demo
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal routing
  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [
      "10.0.1.0/24",
      "10.0.0.0/24"
    ]
  }

  # Letting traffic out
  egress {
    # allow all from internal
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ecs_ghePubSG"
  }
}
