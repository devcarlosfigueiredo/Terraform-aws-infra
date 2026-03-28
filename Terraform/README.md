# 🏗️ Terraform AWS Infrastructure — IaC Portfolio Project

![Terraform](https://img.shields.io/badge/Terraform-≥1.6-7B42BC?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws)
![Docker](https://img.shields.io/badge/Docker-Provisioned-2496ED?logo=docker)
![License](https://img.shields.io/badge/License-MIT-green)

> Projeto de **Infraestrutura como Código (IaC)** completo, estruturado em módulos Terraform, provisionando uma infraestrutura básica na AWS com boas práticas de DevOps, segurança e reutilização de código.

---

## 📐 Arquitetura da Infraestrutura

```
Internet
    │
    ▼
┌─────────────────────────────────────────────┐
│              AWS Region (us-east-1)         │
│                                             │
│  ┌──────────────────────────────────────┐   │
│  │           VPC (10.0.0.0/16)         │   │
│  │                                      │   │
│  │  ┌────────────────────────────────┐  │   │
│  │  │  Public Subnet (10.0.1.0/24)  │  │   │
│  │  │                                │  │   │
│  │  │  ┌──────────────────────────┐  │  │   │
│  │  │  │       EC2 Instance       │  │  │   │
│  │  │  │  Amazon Linux 2023       │  │  │   │
│  │  │  │  ┌────────────────────┐  │  │  │   │
│  │  │  │  │  Docker Container  │  │  │  │   │
│  │  │  │  │  Nginx :80         │  │  │  │   │
│  │  │  │  └────────────────────┘  │  │  │   │
│  │  │  │  Security Group          │  │  │   │
│  │  │  │  ✅ :22 (SSH)           │  │  │   │
│  │  │  │  ✅ :80 (HTTP)          │  │  │   │
│  │  │  │  ✅ :443 (HTTPS)        │  │  │   │
│  │  │  └──────────────────────────┘  │  │   │
│  │  │          Elastic IP            │  │   │
│  │  └────────────────────────────────┘  │   │
│  │                                      │   │
│  │         Internet Gateway             │   │
│  │         Route Table (0.0.0.0/0 → IGW)│   │
│  └──────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

---

## 📁 Estrutura do Projeto

```
terraform-aws-infra/
├── main.tf                   # Entry point — chama os módulos
├── variables.tf              # Declaração de variáveis globais
├── outputs.tf                # Outputs pós-apply (IPs, URLs, etc.)
├── terraform.tfvars          # Valores padrão (dev)
├── prod.tfvars               # Valores para produção
├── .gitignore                # Arquivos ignorados pelo Git
├── README.md                 # Esta documentação
│
└── modules/
    ├── networking/           # 🌐 VPC, Subnet, IGW, Route Table
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── security/             # 🔒 Security Group
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── ec2/                  # 💻 Instância EC2 + Elastic IP
        ├── main.tf           # Inclui user_data (Docker + Nginx)
        ├── variables.tf
        └── outputs.tf
```

---

## ✅ Recursos Provisionados

| Recurso           | Tipo AWS               | Descrição                                    |
|-------------------|------------------------|----------------------------------------------|
| VPC               | `aws_vpc`              | Rede isolada `10.0.0.0/16`                   |
| Subnet Pública    | `aws_subnet`           | Sub-rede `10.0.1.0/24` com IP público auto   |
| Internet Gateway  | `aws_internet_gateway` | Saída para a internet                        |
| Route Table       | `aws_route_table`      | Rota padrão para o IGW                       |
| Security Group    | `aws_security_group`   | Regras: SSH (22), HTTP (80), HTTPS (443)     |
| EC2 Instance      | `aws_instance`         | Amazon Linux 2023, com Docker pré-instalado  |
| Elastic IP        | `aws_eip`              | IP público fixo para a instância             |

---

## ⚙️ Pré-requisitos

| Ferramenta   | Versão Mínima | Instalação                                      |
|--------------|---------------|-------------------------------------------------|
| Terraform    | `>= 1.6.0`    | [terraform.io/downloads](https://terraform.io/downloads) |
| AWS CLI      | `>= 2.x`      | [aws.amazon.com/cli](https://aws.amazon.com/cli) |
| Conta AWS    | —             | Com permissões para EC2, VPC, EIP               |

---

## 🔑 Configuração das Credenciais AWS

### Opção 1 — AWS CLI (recomendada para desenvolvimento)

```bash
aws configure
# AWS Access Key ID:     <sua-access-key>
# AWS Secret Access Key: <sua-secret-key>
# Default region name:   us-east-1
# Default output format: json
```

### Opção 2 — Variáveis de Ambiente

```bash
export AWS_ACCESS_KEY_ID="sua-access-key"
export AWS_SECRET_ACCESS_KEY="sua-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Opção 3 — IAM Role (recomendada para CI/CD e produção)

Configure uma IAM Role na sua pipeline (GitHub Actions, GitLab CI, etc.) com as permissões necessárias. Evita uso de credenciais estáticas.

---

## 🔐 Criando o Key Pair para SSH

Antes de executar o Terraform, crie um Key Pair na AWS:

```bash
# Criar o key pair e salvar a chave privada
aws ec2 create-key-pair \
  --key-name my-key-pair \
  --query 'KeyMaterial' \
  --output text > ~/.ssh/my-key-pair.pem

# Ajustar permissões (obrigatório para SSH funcionar)
chmod 400 ~/.ssh/my-key-pair.pem
```

---

## 🚀 Como Executar

### 1. Clone o Repositório

```bash
git clone https://github.com/devcarlosfigueiredo/terraform-aws-infra.git
cd terraform-aws-infra
```

### 2. Configure as Variáveis

Edite o arquivo `terraform.tfvars` com seus valores:

```hcl
project_name     = "devops-lab"
environment      = "dev"
key_name         = "my-key-pair"       # Nome do seu Key Pair na AWS
allowed_ssh_cidr = ["SEU_IP/32"]       # Seu IP para acesso SSH
```

### 3. Inicialize o Terraform

```bash
terraform init
```

> Baixa os providers necessários e inicializa os módulos.

### 4. Valide a Configuração

```bash
terraform validate
```

### 5. Visualize o Plano de Execução

```bash
terraform plan
# Para um ambiente específico:
terraform plan -var-file="prod.tfvars"
```

### 6. Aplique a Infraestrutura

```bash
terraform apply
# Confirme digitando "yes" quando solicitado

# Para produção:
terraform apply -var-file="prod.tfvars"
```

### 7. Verifique os Outputs

Após o apply, o Terraform exibirá os dados da infraestrutura criada:

```
Outputs:

http_url             = "http://54.123.45.67"
instance_id          = "i-0abc123def456gh78"
instance_public_dns  = "ec2-54-123-45-67.compute-1.amazonaws.com"
instance_public_ip   = "54.123.45.67"
security_group_id    = "sg-0abc123def456gh78"
ssh_command          = "ssh -i ~/.ssh/my-key-pair.pem ec2-user@54.123.45.67"
vpc_id               = "vpc-0abc123def456gh78"
```

---

## 🖥️ Acessando a VM Após a Criação

### Acesso SSH

```bash
# Use o comando exibido no output "ssh_command"
ssh -i ~/.ssh/my-key-pair.pem ec2-user@<IP_PUBLICO>

# Aguarde ~2-3 minutos para o user_data terminar de instalar o Docker
```

### Verificar o Docker e o Nginx

```bash
# Dentro da instância:
docker ps                    # Verifica os containers em execução
docker logs webserver        # Logs do Nginx
sudo systemctl status docker # Status do serviço Docker
```

### Acesso HTTP

Abra no navegador:

```
http://<IP_PUBLICO>
```

Você verá a página de demonstração confirmando que a infraestrutura está funcionando.

---

## 🗑️ Destruindo a Infraestrutura

```bash
# Visualize o que será destruído
terraform plan -destroy

# Destrua todos os recursos
terraform destroy

# Para produção (necessário passar o tfvars)
terraform destroy -var-file="prod.tfvars"
```

> ⚠️ **Atenção**: Em ambiente de produção, o recurso EC2 tem proteção contra destruição acidental (`disable_api_termination = true`). Desative-a manualmente no console AWS antes de executar o `destroy`.

---

## 🛠️ Comandos Úteis

```bash
# Ver todos os recursos no state
terraform state list

# Ver detalhes de um recurso específico
terraform state show module.ec2.aws_instance.main

# Forçar a re-execução do user_data (recria a instância)
terraform taint module.ec2.aws_instance.main
terraform apply

# Formatar o código
terraform fmt -recursive

# Ver outputs sem fazer apply
terraform output
```

---

## 🔒 Boas Práticas de Segurança

- **SSH restrito**: Em produção, use `allowed_ssh_cidr = ["SEU_IP/32"]` no lugar de `0.0.0.0/0`
- **Chaves SSH**: Nunca comite arquivos `.pem` no repositório
- **State remoto**: Use S3 + DynamoDB para times (configuração no `main.tf`, comentada)
- **Credenciais**: Prefira IAM Roles a credenciais estáticas em pipelines CI/CD
- **Criptografia**: Volume raiz criptografado por padrão (`encrypted = true`)

---

## 📊 Estimativa de Custo (us-east-1)

| Recurso       | Tipo       | Custo Estimado/mês |
|---------------|------------|-------------------|
| EC2 Instance  | t3.micro   | ~$8,47            |
| Elastic IP    | Em uso     | Gratuito          |
| EBS Volume    | gp3 20GB   | ~$1,60            |
| **Total**     |            | **~$10,07**       |

> Valores aproximados. Verifique a [Calculadora AWS](https://calculator.aws) para estimativas precisas.

---

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Commit suas mudanças: `git commit -m 'feat: adiciona nova funcionalidade'`
4. Push: `git push origin feature/nova-funcionalidade`
5. Abra um Pull Request

---

## 📄 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

---

<p align="center">
  Feito com ☁️ e 🏗️ por <strong>Seu Nome</strong>
</p>
