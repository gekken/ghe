# Define the VPC

resource "aws_vpc" "ecs_gheVPC" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "ecs_ecs_gheVPC"
  }
}

# Define the Public Subnet

resource "aws_subnet" "ecs_ghePSN" {
  vpc_id = "${aws_vpc.ecs_gheVPC.id}"
  cidr_block = "10.0.0.0/24"
  #TODO: Parameterize this! 
  availability_zone = "us-west-2a"
  tags {
    Name = "ecs_ghePSN-1"
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

# associate routing for ecs_ghePSN

resource "aws_route_table_association" "ecs_ghePSN-RtAssc" {
  subnet_id = "${aws_subnet.ecs_ghePSN.id}"
  route_table_id = "${aws_route_table.ecs_ghePSN01-RT.id}"
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
    cidr_blocks = ["10.0.0.0/16"]
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
