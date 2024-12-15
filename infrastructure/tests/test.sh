#!/bin/bash

# Répertoire du test
TEST_DIR="$GITHUB_WORKSPACE\infrastructure\tests"

# Aller dans le répertoire du test
cd "$TEST_DIR" || exit 1

# Initialiser Terraform
echo "Initialisation de Terraform..."
terraform init -input=false

# Planifier l'application Terraform
echo "Création du plan Terraform..."
terraform plan -out=tfplan -input=false

# Appliquer Terraform et capturer les sorties
echo "Application du plan Terraform..."
terraform apply -input=false tfplan

# Récupérer les sorties de Terraform
echo "Récupération des sorties Terraform..."
RESOURCE_GROUP_NAME=$(terraform output -raw resource_group_name)
VNET_ID=$(terraform output -raw vnet_id)
SUBNET_ID=$(terraform output -raw subnet_id)
PUBLIC_IP_ID=$(terraform output -raw public_ip_id)
NAT_GATEWAY_ID=$(terraform output -raw nat_gateway_id)

# Vérifications simples
echo "Vérifications des résultats..."
if [[ "$RESOURCE_GROUP_NAME" == "ARTOLEPISA_ressourcegroups" ]]; then
  echo "✅ Resource group name OK"
else
  echo "❌ Resource group name incorrect: $RESOURCE_GROUP_NAME"
  exit 1
fi

if [[ "$VNET_ID" == *"ARTOLEPISA_vnet-secure"* ]]; then
  echo "✅ VNet ID OK"
else
  echo "❌ VNet ID incorrect: $VNET_ID"
  exit 1
fi

if [[ "$SUBNET_ID" == *"ARTOLEPISA-subnet_ip_gateway"* ]]; then
  echo "✅ Subnet ID OK"
else
  echo "❌ Subnet ID incorrect: $SUBNET_ID"
  exit 1
fi

if [[ "$PUBLIC_IP_ID" == *"ARTOLEPISA-public-ip"* ]]; then
  echo "✅ Public IP ID OK"
else
  echo "❌ Public IP ID incorrect: $PUBLIC_IP_ID"
  exit 1
fi

if [[ "$NAT_GATEWAY_ID" == *"ARTOLEPISA-nat-gateway"* ]]; then
  echo "✅ NAT Gateway ID OK"
else
  echo "❌ NAT Gateway ID incorrect: $NAT_GATEWAY_ID"
  exit 1
fi

# Nettoyage après test
echo "Nettoyage des ressources Terraform..."
terraform destroy -auto-approve

echo "✅ Test terminé avec succès !"
