variable "keypair" {
  default = "demokey.pub"

}
variable "instance_count" {
  description = "Number of the EC2 instances: 1 Controller, 2 workers"
  default     = 2

}
variable "cluster_version" {
  default = "1.23.6-00"
  #default = "1.22.2-00"
}