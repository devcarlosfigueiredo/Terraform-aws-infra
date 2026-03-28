################################################################################
# variables.tf - Declaração de todas as variáveis do projeto
################################################################################

# ─── Geral ───────────────────────────────────────────────────────────────────
variable "project_name" {
  description = "Nome do projeto — usado como prefixo em todos os recursos"
  type        = string
  default     = "devops-lab"

  validation {
    condition     = length(var.project_name) <= 20
    error_message = "O nome do projeto deve ter no máximo 20 caracteres."
  }
}

variable "environment" {
  description = "Ambiente de implantação (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "O ambiente deve ser 'dev', 'staging' ou 'prod'."
  }
}

variable "owner" {
  description = "Responsável pela infraestrutura (usado em tags)"
  type        = string
  default     = "DevOps Team"
}

# ─── AWS ──────────────────────────────────────────────────────────────────────
variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

# ─── Networking ──────────────────────────────────────────────────────────────
variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "O VPC CIDR deve ser um bloco CIDR válido."
  }
}

variable "public_subnet_cidr" {
  description = "Bloco CIDR da subnet pública"
  type        = string
  default     = "10.0.1.0/24"
}

# ─── Segurança ────────────────────────────────────────────────────────────────
variable "allowed_ssh_cidr" {
  description = "CIDR autorizado para acesso SSH (use seu IP + /32 em produção)"
  type        = list(string)
  default     = ["0.0.0.0/0"] # ⚠️ Restrinja em produção!
}

# ─── EC2 ─────────────────────────────────────────────────────────────────────
variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "ID da AMI (Amazon Linux 2023). Deixe vazio para usar o data source automático"
  type        = string
  default     = "" # Se vazio, o módulo EC2 busca a AMI mais recente automaticamente
}

variable "key_name" {
  description = "Nome do Key Pair criado na AWS para acesso SSH"
  type        = string
  default     = "my-key-pair" # Deve existir previamente na sua conta AWS
}
