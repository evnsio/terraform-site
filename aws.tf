provider "aws" {
  region = "${var.aws_region}"
}


data "aws_ami" "coreos" {
  most_recent = true
  owners = ["595879546273"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }
}


resource "aws_instance" "web" {
  ami = "${data.aws_ami.coreos.id}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.ssh_public_key.key_name}"

  security_groups = [
    "${aws_security_group.web.name}",
    "${aws_security_group.ssh.name}"
  ]

  iam_instance_profile = "${aws_iam_instance_profile.web.id}"

  tags {
    Name = "${var.site_name_tag}"
  }
}


resource "aws_eip" "web" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}


resource "aws_key_pair" "ssh_public_key" {
  key_name = "my-public-key"
  public_key = "${var.public_key}"
}



resource "aws_iam_role" "web" {
  name = "web"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_instance_profile" "web" {
  name = "web"
  roles = ["web"]
}


resource "aws_iam_role_policy" "web" {
  name = "web"
  role = "${aws_iam_role.web.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_security_group" "web" {
  name = "web"
  description = "Allow all inbound traffic on 80/443"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.site_name_tag}"
  }
}


resource "aws_security_group" "ssh" {
  name = "ssh"
  description = "Allow SSH access"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # You may want to restrict this
  }

  tags {
    Name = "${var.site_name_tag}"
  }
}




resource "aws_s3_bucket" "backups" {
  bucket = "${var.backup_bucket_name}"
  acl = "private"

  tags {
    Name = "${var.site_name_tag}"
  }
}