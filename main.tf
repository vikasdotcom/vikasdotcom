provider "aws" {
    region = "us-east-1"
    access_key = "AKIAR4EI5CS6NKWGXNG3"
    secret_key = "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"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name = "vikas_vpc"
    }
}

resource "aws_subnet" "pub" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "default"
    tags = {
        name = "public"
    }
    
}


resource "aws_subnet" "pri" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "default"
    tags = {
        name = "private"
    }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "ip" {
    vpc      = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ip
  subnet_id     = aws_subnet.pri.id

  tags = {
    Name = "NGW"
  }

}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

tags = {
    Name = "custom"
}
}

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ngw.id
  }

tags = {
    Name = "main"
}
}

resource "aws_route_table_association" "association_1" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "association_2" {
  subnet_id      = aws_subnet.pri.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_security_group" "SecurityGroup" {
  name        = "New-SecurityGroup"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.my_vpc.cidr_block]
  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "Security_Group"
  }
}