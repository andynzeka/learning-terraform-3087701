# output "instance_ami" {
#   value = aws_instance.blog.ami
# }

# output "instance_arn" {
#   value = aws_instance.blog.arn
# }


# output "instance" {
#   value = aws_instance.blog.public_ip
# }

output "module_security_group_id" {
  value = module.blog_SG.security_group_id
}
