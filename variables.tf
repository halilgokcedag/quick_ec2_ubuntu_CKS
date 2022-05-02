variable "keypair" {
    default = "demokey.pub"
  
}
# variable "keypair-private" {
#     default = "demokey"
  
# }

variable "instance_count" {
    description = "Number of the EC2 instances: 1 Controller, 2 workers"
    default = 1
  
}