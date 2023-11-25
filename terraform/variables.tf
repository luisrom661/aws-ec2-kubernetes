# AWS Variables

variable "aws_access_key" {
  description = "AWS API token"
}

variable "aws_secret_key" {
  description = "AWS API token"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1" # Cambiar a la región que desees
}

variable "aws_ami" {
  description = "AWS AMI"
  default     = "ami-0fc5d935ebf8bc3bc" # Cambiar a la imagen que desees
}

variable "aws_instance_type" {
  description = "AWS instance type"
  default     = "t2.micro" # Cambiar a la instancia que desees
}

variable "aws_key_name" {
  description = "AWS key name"
}

variable "ingress_rules" {
  description = "Ingress rules"
  default = {
    ssh = {
      from_port = 22
      to_port   = 22
    },
    app = {
      from_port = 3000
      to_port   = 3000
    },
    jenkins = {
      from_port = 8080
      to_port   = 8080
    },
    sonarqube = {
      from_port = 9000
      to_port   = 9000
    }
  }
}

variable "ansible_playbooks" {
  description = "List of Ansible playbooks to run"
  default = [
    "/home/luis/Test-DevSecOps-Config/ansible/docker.yml",
    "/home/luis/Test-DevSecOps-Config/ansible/jenkins.yml",
    "/home/luis/Test-DevSecOps-Config/ansible/trivy.yml"
  ]
}