# AWS Configuration using Terraform

# To generate private key
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a security group
resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for allow SSH and HTTP in EC2"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# To create a key pair
resource "aws_key_pair" "key_pair" {
  key_name   = var.aws_key_name
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

# To create a private key file
resource "local_file" "private_key" {
  content  = tls_private_key.rsa-4096.private_key_pem
  filename = var.aws_key_name

  provisioner "local-exec" {
    command = "chmod 400 ${var.aws_key_name}"
  }
}

# To create a EC2 instance
resource "aws_instance" "k8s-master-instance" {
  ami                    = var.aws_ami # ID de la imagen de Ubuntu 22.04
  instance_type          = var.aws_instance_type
  key_name               = aws_key_pair.key_pair.key_name # Cambia esto por el nombre de tu par de claves
  vpc_security_group_ids = [aws_security_group.sg_ec2.id] # Cambia esto por el ID de tu grupo de seguridad
  tags = {
    Name = "k8s-master-instance"
  }

  root_block_device {
	  volume_size = 30
	  volume_type = "gp2"
  }

  provisioner "local-exec" {
    command = "touch dynamic_inventory.ini"
  }

  provisioner "remote-exec" {
    inline = [ "echo 'EC2 Instance K8s Master is Ready!.'" ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.rsa-4096.private_key_pem
  }
}

# To create a EC2 instance
resource "aws_instance" "k8s-worker-instance" {
  ami                    = var.aws_ami # ID de la imagen de Ubuntu 22.04
  instance_type          = var.aws_instance_type
  key_name               = aws_key_pair.key_pair.key_name # Cambia esto por el nombre de tu par de claves
  vpc_security_group_ids = [aws_security_group.sg_ec2.id] # Cambia esto por el ID de tu grupo de seguridad
  tags = {
    Name = "k8s-worker-instance"
  }

  root_block_device {
	  volume_size = 30
	  volume_type = "gp2"
  }

  provisioner "local-exec" {
    command = "touch dynamic_inventory.ini"
  }

  provisioner "remote-exec" {
    inline = [ "echo 'EC2 Instance K8s Worker is Ready!.'" ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.rsa-4096.private_key_pem
  }
}

data "template_file" "inventory" {
  template = <<-EOT
    [ubuntu-master]
    ${aws_instance.k8s-master-instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${path.module}/${var.aws_key_name}
    [ubuntu-worker]
    ${aws_instance.k8s-worker-instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${path.module}/${var.aws_key_name}
  EOT
}

resource "local_file" "dynamic_inventory" {
  depends_on = [ aws_instance.k8s-master-instance, aws_instance.k8s-worker-instance ]

  filename   = "dynamic_inventory.ini"
  content    = data.template_file.inventory.rendered

  provisioner "local-exec" {
    command = "chmod 400 ${local_file.dynamic_inventory.filename}"
  }
}

resource "null_resource" "run_ansible" {
  depends_on = [ local_file.dynamic_inventory ]

  provisioner "local-exec" {
    command     = "ansible-playbook -i dynamic_inventory.ini /home/luis/aws-ec2-kubernetes/ansible/docker.yml"
    working_dir = path.module
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i dynamic_inventory.ini /home/luis/aws-ec2-kubernetes/ansible/kubernetes.yml"
    working_dir = path.module
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i dynamic_inventory.ini /home/luis/aws-ec2-kubernetes/ansible/kubernetes-config.yml"
    working_dir = path.module
  }
}