################################################################################
# modules/networking/main.tf
# Responsável por: VPC, Subnet, Internet Gateway e Route Table
################################################################################

# ─── VPC ─────────────────────────────────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true   # Habilita resolução DNS dentro da VPC
  enable_dns_hostnames = true   # Habilita hostnames DNS para instâncias

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# ─── Subnet Pública ──────────────────────────────────────────────────────────
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true # Instâncias nesta subnet recebem IP público automaticamente

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet"
    Type = "Public"
  }
}

# ─── Internet Gateway ────────────────────────────────────────────────────────
# Permite que recursos na VPC comuniquem com a internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# ─── Route Table Pública ──────────────────────────────────────────────────────
# Define que todo tráfego de saída (0.0.0.0/0) vai pelo Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# ─── Associação: Subnet ↔ Route Table ────────────────────────────────────────
# Associa a subnet pública à route table, tornando-a efetivamente pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
