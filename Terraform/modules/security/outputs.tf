################################################################################
# modules/security/outputs.tf
################################################################################

output "security_group_id" {
  description = "ID do Security Group da instância EC2"
  value       = aws_security_group.ec2.id
}

output "security_group_name" {
  description = "Nome do Security Group"
  value       = aws_security_group.ec2.name
}
