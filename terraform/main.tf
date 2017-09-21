provider "aws" {
  region = "eu-west-2"
} 

#Create VPC
resource "aws_vpc" "melson" {
  tags {
    Name = "Melson - VPC"
  }
  cidr_block = "11.6.0.0/16"
}

resource "aws_subnet" "web" {
  vpc_id     = "${aws_vpc.melson.id}"
  cidr_block = "11.6.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "Web - Private"
  }
}

resource "aws_subnet" "mel-db" {
  cidr_block = "11.6.2.0/24"
  vpc_id ="${aws_vpc.melson.id}"
  map_public_ip_on_launch = false
  tags {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "Web-melson"  {
  name ="Web-melson"
  description = "Allow all inbound traffic through port 80 only"
  vpc_id ="${aws_vpc.melson.id}"

  ingress{
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress{
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags {
    Name = "Web-melson"
  }
}

resource "aws_security_group" "db_security" {
  vpc_id ="${aws_vpc.melson.id}"
  name = "db_security"
  

  ingress{
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups =["${aws_security_group.Web-melson.id}"]
  }
  egress{
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

data "template_file" "init_script" {
  template = "${file("${path.module}/init.sh")}"
} 

resource "aws_instance" "web" {
  ami           = "ami-03dccf67"
  instance_type = "t2.micro"
  vpc_security_group_ids =["${aws_security_group.Web-melson.id}"]
  subnet_id ="${aws_subnet.web.id}"
  user_data = "${data.template_file.init_script.rendered}"
  depends_on = ["aws_instance.database"]
  tags {
    Name = "web-melson"
  }
}

resource "aws_instance" "database" {

  ami           = "ami-0fddce6b"
  instance_type = "t2.micro"
  vpc_security_group_ids =["${aws_security_group.db_security.id}"] 
  subnet_id ="${aws_subnet.mel-db.id}"
  private_ip = "11.6.2.60"
  tags {
    Name = "db-melson"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.melson.id}"
}

# Add route to internet gateway in route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.melson.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table" "local" {
 vpc_id = "${aws_vpc.melson.id}"
 tags{
  Name = "Melson"
 }
}

resource "aws_route_table_association" "db" {
  subnet_id = "${aws_subnet.mel-db.id}"
  route_table_id = "${aws_route_table.local.id}"
}