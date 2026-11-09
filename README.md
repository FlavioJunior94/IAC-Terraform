# Infrastructure as Code (IaC) Escalável com Terraform

## Visão Geral

Este projeto provisiona uma infraestrutura AWS completa utilizando Terraform com arquitetura modularizada. O objetivo é demonstrar boas práticas de IaC em um cenário próximo ao de produção, cobrindo rede, banco de dados, gerenciamento de estado remoto e pipeline de entrega contínua.

## O que é provisionado

- VPC com subnets públicas e privadas em múltiplas zonas de disponibilidade
- Internet Gateway para acesso público
- NAT Gateway para que recursos privados acessem a internet sem ficarem expostos
- Banco de dados RDS em subnet privada
- Backend remoto com S3 (armazenamento do state) e DynamoDB (lock de estado)

## Estrutura do Projeto

```
.
├── modules/
│   ├── vpc/          # Rede: VPC, subnets, route tables, IGW
│   ├── nat/          # NAT Gateway e Elastic IP
│   └── rds/          # Banco de dados RDS
├── environments/
│   ├── staging/      # Configuração para ambiente de homologação (LocalStack)
│   └── production/   # Configuração para ambiente de produção (AWS real)
├── .github/
│   └── workflows/    # Pipelines de CI/CD com GitHub Actions
├── diagrams/         # Diagrama da infraestrutura
└── notes/            # Anotações locais (ignoradas pelo Git)
```

## Pré-requisitos

- Terraform >= 1.6
- Terragrunt >= 0.55
- Docker (para rodar o LocalStack em ambiente de testes)
- AWS CLI configurado (para produção)

## Ambientes

### Homologação (LocalStack)

O ambiente de testes simula a AWS localmente via LocalStack em container Docker. Nenhuma conta AWS é necessária e nenhum custo é gerado. As instruções completas estão em `environments/staging/`.

### Produção

Para usar em produção, é necessário configurar as credenciais AWS e ajustar as variáveis no arquivo `environments/production/`. As instruções estão detalhadas nesse diretório.

## Backend Remoto

O estado do Terraform é armazenado remotamente em um bucket S3 com versionamento habilitado. O DynamoDB é usado para garantir que apenas uma pessoa ou pipeline execute mudanças ao mesmo tempo (state lock). Isso é essencial para trabalho em equipe.

## Drift Detection

Drift ocorre quando alguém altera um recurso manualmente no console da AWS sem passar pelo Terraform. Para detectar e lidar com isso, utilizamos `terraform plan` no pipeline de CI/CD, que compara o estado atual da infraestrutura com o estado registrado. Qualquer diferença é reportada antes de qualquer aplicação.

## CI/CD

O pipeline com GitHub Actions executa automaticamente:

1. `terraform fmt` — verifica formatação do código
2. `terraform validate` — valida a sintaxe
3. `terraform plan` — mostra o que será alterado
4. `terraform apply` — aplica as mudanças (somente na branch main)

## Diagrama

O diagrama da infraestrutura está disponível em `diagrams/` nos formatos `.drawio` e `.png`.
