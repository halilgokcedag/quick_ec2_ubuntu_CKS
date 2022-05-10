data "aws_vpc" "myvpc" {default = true}

data "template_file" "init" {
  count = var.instance_count
  template = "${file("install_tools.sh")}"

  vars = {
    #hostname = "quick-EC2-ubuntu ${count.index+1}"
    hostname = count.index+1
  }
}

resource "aws_key_pair" "demo-key" {
  key_name   = "demo-ec2-key"
  public_key = file("${path.cwd}/${var.keypair}")

}

resource "aws_instance" "quick-ec2_ubuntu" {
  count = var.instance_count
  instance_type          = "t3.medium"
  ami                    = "ami-04505e74c0741db8d"
  key_name               = aws_key_pair.demo-key.id
  user_data              = data.template_file.init[count.index].rendered
  vpc_security_group_ids = [aws_security_group.allow_HTTP_SSH.id, aws_security_group.allow_traffic_within_cluster.id]
  tags = {
    "Name" = "quick-EC2-ubuntu ${count.index+1}"
  }
  root_block_device {
    volume_size = 40
  }
  # provisioner "remote-exec" {
  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     host        = self.public_ip
  #     private_key = file("${path.cwd}/${var.keypair-private}")
  #     script_path = "/home/ubuntu/install_tools.sh"
  #   }
  #   inline = [
  #     "sudo echo {$self.private_ip}  ubuntuk8s-${count.index+1}>>/etc/hosts"
  #   ]
  # }
}

resource "aws_security_group" "allow_HTTP_SSH" {
  name        = "allow_HTTP_SSH"
  description = "Allow quick EC2 instance inbound traffic"
  vpc_id      = data.aws_vpc.myvpc.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSh from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description      = "dashboard from anywhere"
    from_port        = 30000
    to_port          = 32000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_some ports"
  }
}


resource "aws_security_group" "allow_traffic_within_cluster" {
  name        = "allow_K8s_traffic"
  description = "Allow K8s traffic inbound traffic"
  vpc_id      = data.aws_vpc.myvpc.id

  ingress {
    description      = "Allow all traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = [aws_security_group.allow_HTTP_SSH.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all ports within the SG allow_HTTP_SSH"
  }
}