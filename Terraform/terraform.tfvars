################################################################################
# terraform.tfvars - Valores padrão para ambiente de desenvolvimento
# ⚠️  NÃO commite este arquivo se contiver dados sensíveis!
#     Adicione terraform.tfvars ao .gitignore
################################################################################

# ─── Geral ───────────────────────────────────────────────────────────────────
project_name = "devops-lab"
environment  = "dev"
owner        = "DevOps Team"

# ─── AWS ─────────────────────────────────────────────────────────────────────
aws_region = "us-east-1"

# ─── Rede ────────────────────────────────────────────────────────────────────
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"

# ─── Segurança ────────────────────────────────────────────────────────────────
# ⚠️  Em produção, substitua pelo seu IP: ["SEU_IP/32"]
allowed_ssh_cidr = ["0.0.0.0/0"]

# ─── EC2 ─────────────────────────────────────────────────────────────────────
instance_type = "t3.micro"
key_name      = "my-key-pair"
ami_id        = "" # Deixe vazio para usar AMI mais recente do Amazon Linux 2023
