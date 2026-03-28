################################################################################
# modules/networking/variables.tf
################################################################################

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Bloco CIDR da subnet pública"
  type        = string
}

variable "aws_region" {
  description = "Região AWS"
  type        = string
}
