variable "keypair" {
    default = "demokey.pub"
  
}
variable "instance_count" {
    description = "Number of the EC2 instances: 1 Controller, 2 workers"
    default = 2
  
}