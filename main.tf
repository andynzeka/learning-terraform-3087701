data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "blog" {
  ami = data.aws_ami.app_ami.id
  # instance_type = "t3.nano"
  # instance_type = "t2.micro"
  instance_type = var.instance_type

  vpc_security_group_ids = [module.blog_module-SG.security_group_id]

  tags = {
    Name = "AppInstance"
  }
}

module "blog_module-SG" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"
  name    = "module_blog_new"

  vpc_id = data.aws_vpc.default.id

  ingress_rules       = ["http-80-tcp", "https-443-tcp", "22"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

}

# resource "aws_security_group" "blog_sg" {
#   name        = "blog_sg"
#   description = "Allow HTTP and HTTPS inbound traffic"
#   vpc_id      = data.aws_vpc.default.id

#   tags = {
#     Name = "Blog-SG"
#   }
# }

# resource "aws_security_group_rule" "allow_http_inbound" {
#   type        = "ingress"
#   from_port   = 80
#   to_port     = 80
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]

#   security_group_id = aws_security_group.blog_sg.id
# }

# resource "aws_security_group_rule" "allow_https_inbound" {
#   type        = "ingress"
#   from_port   = 443
#   to_port     = 443
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]

#   security_group_id = aws_security_group.blog_sg.id
# }

# resource "aws_security_group_rule" "allow_http_outbound" {
#   type        = "egress"
#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = ["0.0.0.0/0"]

#   security_group_id = aws_security_group.blog_sg.id
# }
