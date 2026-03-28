################################################################################
# modules/security/variables.tf
################################################################################

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Lista de CIDRs autorizados para SSH"
  type        = list(string)
}
