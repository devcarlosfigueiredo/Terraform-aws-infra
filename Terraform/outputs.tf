################################################################################
# outputs.tf - Saídas úteis após o apply
################################################################################

output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "ID da subnet pública"
  value       = module.networking.public_subnet_id
}

output "security_group_id" {
  description = "ID do Security Group da instância EC2"
  value       = module.security.security_group_id
}

output "instance_id" {
  description = "ID da instância EC2"
  value       = module.ec2.instance_id
}

output "instance_public_ip" {
  description = "IP público da instância EC2"
  value       = module.ec2.public_ip
}

output "instance_public_dns" {
  description = "DNS público da instância EC2"
  value       = module.ec2.public_dns
}

output "ssh_command" {
  description = "Comando SSH pronto para uso"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.ec2.public_ip}"
}

output "http_url" {
  description = "URL HTTP para acessar o servidor web"
  value       = "http://${module.ec2.public_ip}"
}
