output "instance_id-master" {
  description = "ID of the EC2 instance"
  value       = aws_instance.k8s-master-instance.id
}

output "instance_public_ip-master" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.k8s-master-instance.public_ip
}

output "instance_id-worker" {
  description = "ID of the EC2 instance"
  value       = aws_instance.k8s-worker-instance.id
}

output "instance_public_ip-worker" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.k8s-worker-instance.public_ip
}

output "instance_public_dns-master" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.k8s-master-instance.public_dns
}

output "instance_public_dns-worker" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.k8s-worker-instance.public_dns
}