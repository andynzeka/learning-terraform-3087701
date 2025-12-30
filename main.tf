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
  name    = "Module_AppInstance_SG"

  vpc_id = data.aws_vpc.default.id

  ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

}
