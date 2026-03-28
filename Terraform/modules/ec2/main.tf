################################################################################
# modules/ec2/main.tf
# Responsável por: AMI data source, Key Pair e Instância EC2
################################################################################

# ─── Data Source: AMI mais recente ───────────────────────────────────────────
# Busca automaticamente a AMI mais recente do Amazon Linux 2023
# Só é usado se var.ami_id estiver vazio
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# ─── Local: Seleciona AMI ────────────────────────────────────────────────────
locals {
  # Usa a AMI fornecida pelo usuário; se vazia, usa a do data source
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2023.id

  # Script de inicialização: instala Docker, Docker Compose e um servidor Nginx
  user_data = <<-EOF
    #!/bin/bash
    set -e

    # ── Atualiza o sistema ──────────────────────────────────────────────────
    echo ">>> Atualizando pacotes..."
    dnf update -y

    # ── Instala utilitários essenciais ─────────────────────────────────────
    echo ">>> Instalando utilitários..."
    dnf install -y git curl wget htop unzip

    # ── Instala Docker ─────────────────────────────────────────────────────
    echo ">>> Instalando Docker..."
    dnf install -y docker
    systemctl enable docker
    systemctl start docker

    # Adiciona o usuário ec2-user ao grupo docker (sem necessidade de sudo)
    usermod -aG docker ec2-user

    # ── Instala Docker Compose v2 ──────────────────────────────────────────
    echo ">>> Instalando Docker Compose..."
    DOCKER_CONFIG=/usr/local/lib/docker
    mkdir -p $DOCKER_CONFIG/cli-plugins
    curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
      -o $DOCKER_CONFIG/cli-plugins/docker-compose
    chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

    # ── Sobe um container Nginx como servidor web de demonstração ──────────
    echo ">>> Iniciando container Nginx..."
    docker run -d \
      --name webserver \
      --restart always \
      -p 80:80 \
      -v /var/www/html:/usr/share/nginx/html:ro \
      nginx:alpine

    # ── Cria página HTML de demonstração ──────────────────────────────────
    mkdir -p /var/www/html
    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
      <meta charset="UTF-8">
      <title>🚀 Terraform IaC - DevOps Lab</title>
      <style>
        body { font-family: sans-serif; background: #0f172a; color: #e2e8f0; text-align: center; padding: 80px 20px; }
        h1   { font-size: 2.5rem; color: #38bdf8; }
        p    { font-size: 1.1rem; color: #94a3b8; }
        .badge { display: inline-block; background: #1e40af; color: #bfdbfe; padding: 6px 16px; border-radius: 9999px; font-size: 0.85rem; margin: 4px; }
      </style>
    </head>
    <body>
      <h1>🚀 Infraestrutura Provisionada com Sucesso!</h1>
      <p>Esta instância foi criada automaticamente via <strong>Terraform</strong>.</p>
      <p>O servidor web está rodando dentro de um container <strong>Docker</strong>.</p>
      <br>
      <span class="badge">☁️ AWS EC2</span>
      <span class="badge">🏗️ Terraform</span>
      <span class="badge">🐳 Docker</span>
      <span class="badge">🌐 Nginx</span>
    </body>
    </html>
    HTML

    # Reinicia o Nginx para carregar o novo HTML
    docker restart webserver

    echo ">>> Setup concluído com sucesso!"
  EOF
}

# ─── Instância EC2 ───────────────────────────────────────────────────────────
resource "aws_instance" "main" {
  ami                    = local.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  # Script executado no primeiro boot da instância
  user_data                   = local.user_data
  user_data_replace_on_change = true # Recria a instância se o user_data mudar

  # Volume raiz com 20 GB e criptografia habilitada
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${var.project_name}-${var.environment}-root-vol"
    }
  }

  # Monitoramento detalhado (gera custo adicional — desative em dev se quiser)
  monitoring = var.environment == "prod" ? true : false

  # Proteção contra destruição acidental em produção
  disable_api_termination = var.environment == "prod" ? true : false

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2"
  }

  lifecycle {
    # Ignora mudanças na AMI após criação (evita recriação desnecessária)
    ignore_changes = [ami]
  }
}

# ─── Elastic IP ──────────────────────────────────────────────────────────────
# IP público fixo — não muda mesmo após stop/start da instância
resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-eip"
  }

  depends_on = [aws_instance.main]
}
