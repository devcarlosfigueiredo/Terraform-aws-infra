################################################################################
# modules/security/main.tf
# Responsável por: Security Group com regras de ingress/egress
################################################################################

resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security Group para a instancia EC2 - ${var.project_name} (${var.environment})"
  vpc_id      = var.vpc_id

  # ─── Ingress: SSH ───────────────────────────────────────────────────────────
  ingress {
    description = "SSH - Acesso remoto seguro"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # ─── Ingress: HTTP ──────────────────────────────────────────────────────────
  ingress {
    description = "HTTP - Servidor web publico"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ─── Ingress: HTTPS ─────────────────────────────────────────────────────────
  ingress {
    description = "HTTPS - Servidor web seguro"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ─── Egress: Todo tráfego de saída ──────────────────────────────────────────
  # Permite que a instância acesse a internet (para instalar pacotes, etc.)
  egress {
    description = "Saida irrestrita para a internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Todos os protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg"
  }

  # Força a criação de um novo SG antes de destruir o antigo
  # Evita downtime durante atualizações
  lifecycle {
    create_before_destroy = true
  }
}
