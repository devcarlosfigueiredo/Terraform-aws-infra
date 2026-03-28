################################################################################
# modules/ec2/outputs.tf
################################################################################

output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "IP público fixo (Elastic IP)"
  value       = aws_eip.main.public_ip
}

output "public_dns" {
  description = "DNS público da instância EC2"
  value       = aws_instance.main.public_dns
}

output "private_ip" {
  description = "IP privado da instância EC2"
  value       = aws_instance.main.private_ip
}

output "ami_used" {
  description = "ID da AMI utilizada na criação da instância"
  value       = aws_instance.main.ami
}
