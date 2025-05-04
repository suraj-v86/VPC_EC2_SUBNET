resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
      Name = "my-vpc"
    }

  
}

resource "aws_subnet" "my_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.101.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "my-subnet"
    }

  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "my-igw"
    }
  
}

resource "aws_route_table" "rtlb" {
    vpc_id = aws_vpc.my_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "my-rtlb"
    }
  
}

resource "aws_route_table_association" "public_association" {
    subnet_id = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.rtlb.id
  
}

resource "aws_security_group" "ec2_sg" {
    description = "Allow SSH and HTTP"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "ec2-sg"
    }
  
}


resource "aws_instance" "server" {
    ami = var.ami
    key_name = var.key
    instance_type = var.instance
    subnet_id = aws_subnet.my_subnet.id
    associate_public_ip_address = true

    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    tags = {
      Name = "server"
    }

    user_data = file("userdata.sh")
  
}

output "public_ip" {
    value = aws_instance.server.public_ip
  
}