provider "aws" {
  region = var.region
  version = "~> 4.0"
}

data "http" "myip" {
  # to fetch my public IP.
  url = "https://ipv4.icanhazip.com"
  insecure = true
}

resource "aws_security_group" "ec2_sg" {
  name        = "mlops-tf-sg"
  ingress  {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["${chomp(data.http.myip.response_body)}/32"]
    description     = "My public IP"
    self            = true
  }
  egress  {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_ami" "amz_image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.amz_image.id
  key_name      = var.key_name
  instance_type = "t2.2xlarge"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  metadata_options {
    # Since we are fetching instance metadata from inside the instance.
    http_endpoint   = "enabled"
    http_tokens     = "optional"
  }
  user_data = "${file("resources/init.sh")}"
  tags = {
    Name  = "mlops-tf-instance"
    Owner = var.tag_owner
  }
}