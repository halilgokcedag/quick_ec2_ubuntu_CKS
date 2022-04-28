output "public_ips" {
  value = aws_instance.quick-ec2_ubuntu[*].public_ip
}

output "private_ips" {
  description = "Private IP addresses"
  value = aws_instance.quick-ec2_ubuntu[*].private_ip
}