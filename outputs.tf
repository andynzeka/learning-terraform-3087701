output "instance_ami" {
  value = aws_instance.blog.ami
}

output "instance_arn" {
  value = aws_instance.blog.arn
}

output "module_security_group_id" {
  value = module.blog_module-SG.security_group_id
}