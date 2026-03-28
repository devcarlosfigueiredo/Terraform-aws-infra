################################################################################
# prod.tfvars - Valores para ambiente de produção
# Uso: terraform apply -var-file="prod.tfvars"
################################################################################

project_name = "devops-lab"
environment  = "prod"
owner        = "DevOps Team"

aws_region = "us-east-1"

vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"

# ✅ Em produção, restrinja ao seu IP corporativo
allowed_ssh_cidr = ["177.100.200.50/32"]

instance_type = "t3.small"
key_name      = "prod-key-pair"
ami_id        = ""
