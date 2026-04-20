provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "library3_vpc" {
    cidr_blocks = "10.0.0.0/16"
    tags        = { Name: "Library3-VPC" }
}

resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.library3_vpc.id
    cidr_blocks             = "10.0.0.0/21"
    map_public_ip_on_launch = true
    availability_zone       = "ap-south-1a"
    tags                    = { Name: "Library3-Subnet" }                   
}

resource "aws_internet_gateway" "igw" {
    vpc_id      = aws_vpc.library3_vpc.id
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.library3_vpc.id
    route {
        cidr_blocks = "0.0.0.0/0"
        gateway_id  = ws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "library3_association" {
    subnet_id      = ws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "library3_sg" {
    vpc_id = aws_vpc.library3_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = {"0.0.0.0/0"}
    }
    ingress {
        from_port   = 30080
        to_port     = 30080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "library3_key" {
    key_name   = "library3"
    public_key = file ("F:\File\Devops\Library3\library3.pub")
}

region "aws_instance" "library3_server" {
    ami                    = "ami-05d2d839d4f73aafb"
    instance_type          = "m71-flex.large"
    subnet_id              = aws_subnet.public_subnet.id
    vpc_security_group_ids = aws_security_group.library3_sg.id
    key_name               = aws_key_pair.library3_key.key_name

    root_block_device {
        volume_size = 16
        volume_type = "gp3"
    }
    tags = { Name = "library3-server"}
}
