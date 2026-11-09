#!/bin/bash

set -e

TERRAFORM_VERSION="1.8.5"
TERRAGRUNT_VERSION="0.55.21"

print_status() {
    echo ""
    echo ">>> $1"
}

already_installed() {
    echo "    [ok] $1 já está instalado — pulando."
}

# --- Dependências base ---

print_status "Atualizando lista de pacotes..."
sudo apt-get update -qq

for pkg in curl unzip gnupg software-properties-common; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        sudo apt-get install -y "$pkg"
    fi
done

# --- Terraform ---

print_status "Verificando Terraform..."
if command -v terraform &>/dev/null; then
    already_installed "Terraform $(terraform version -json | python3 -c 'import sys,json; print(json.load(sys.stdin)["terraform_version"])')"
else
    echo "    Instalando Terraform ${TERRAFORM_VERSION}..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
        | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y terraform
    echo "    [ok] Terraform instalado: $(terraform version | head -1)"
fi

# --- Terragrunt ---

print_status "Verificando Terragrunt..."
if command -v terragrunt &>/dev/null; then
    already_installed "Terragrunt $(terragrunt --version | awk '{print $3}')"
else
    echo "    Instalando Terragrunt ${TERRAGRUNT_VERSION}..."
    curl -fsSL "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" \
        -o /tmp/terragrunt
    sudo install -m 0755 /tmp/terragrunt /usr/local/bin/terragrunt
    rm /tmp/terragrunt
    echo "    [ok] Terragrunt instalado: $(terragrunt --version)"
fi

# --- Docker ---

print_status "Verificando Docker..."
if command -v docker &>/dev/null; then
    already_installed "Docker $(docker --version)"
else
    echo "    Instalando Docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker "$USER"
    echo "    [ok] Docker instalado: $(docker --version)"
    echo "    [aviso] Você foi adicionado ao grupo docker. Feche e reabra o terminal para aplicar."
fi

# --- AWS CLI ---

print_status "Verificando AWS CLI..."
if command -v aws &>/dev/null; then
    already_installed "AWS CLI $(aws --version)"
else
    echo "    Instalando AWS CLI v2..."
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
    unzip -q /tmp/awscliv2.zip -d /tmp/awscliv2
    sudo /tmp/awscliv2/aws/install
    rm -rf /tmp/awscliv2 /tmp/awscliv2.zip
    echo "    [ok] AWS CLI instalado: $(aws --version)"
fi

# --- Resumo final ---

echo ""
echo "============================================"
echo " Instalação concluída. Versões instaladas:"
echo "============================================"
echo " Terraform:  $(terraform version | head -1)"
echo " Terragrunt: $(terragrunt --version)"
echo " Docker:     $(docker --version)"
echo " AWS CLI:    $(aws --version)"
echo "============================================"
echo ""
echo "Próximo passo: rode 'aws configure' para configurar suas credenciais (produção)"
echo "ou siga para o ambiente de staging com LocalStack."
echo ""
