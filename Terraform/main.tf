################################################################################
# main.tf - Ponto de entrada da infraestrutura
# Projeto: AWS Infrastructure as Code com Terraform
# Autor:   Seu Nome
# Data:    2025
################################################################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Descomente e configure para usar backend remoto (recomendado para times)
  # backend "s3" {
  #   bucket         = "meu-terraform-state-bucket"
  #   key            = "infra/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-lock"
  #   encrypt        = true
  # }
}

# ─── Provider ───────────────────────────────────────────────────────────────
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
    }
  }
}

# ─── Módulo: Networking ──────────────────────────────────────────────────────
module "networking" {
  source = "./modules/networking"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  aws_region         = var.aws_region
}

# ─── Módulo: Security ────────────────────────────────────────────────────────
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# ─── Módulo: EC2 ─────────────────────────────────────────────────────────────
module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  environment       = var.environment
  instance_type     = var.instance_type
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.security.security_group_id
  key_name          = var.key_name
  ami_id            = var.ami_id
}
