################################################################################
# modules/ec2/variables.tf
################################################################################

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet onde a instância será lançada"
  type        = string
}

variable "security_group_id" {
  description = "ID do Security Group associado à instância"
  type        = string
}

variable "key_name" {
  description = "Nome do Key Pair para acesso SSH"
  type        = string
}

variable "ami_id" {
  description = "ID da AMI (vazio = usa o data source automático)"
  type        = string
  default     = ""
}
