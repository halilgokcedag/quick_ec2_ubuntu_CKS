output "public_ip" {
  value = aws_instance.quick-ec2_ubuntu[*].public_ip
}