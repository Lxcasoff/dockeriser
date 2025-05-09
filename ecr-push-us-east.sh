#!/bin/bash

### CONFIGURATION ###
REPO_NAME="tp1"
REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REMOTE_REPO="$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME"
IMAGES=("tp1-frontend" "tp1-backend" "tp1-websocket" "tp1-db")

### AUTH ECR ###
echo "[*] Connexion à ECR ($REGION)..."
aws ecr get-login-password --region "$REGION" | docker login \
  --username AWS \
  --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

if [ $? -ne 0 ]; then
    echo "[!] Connexion à ECR échouée. Vérifie tes droits IAM."
    exit 1
fi
echo "[+] Connexion ECR OK."

### CRÉER LE DÉPÔT SI BESOIN ###
echo "[*] Vérification du dépôt ECR '$REPO_NAME'..."
aws ecr describe-repositories --repository-names "$REPO_NAME" --region "$REGION" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    aws ecr create-repository --repository-name "$REPO_NAME" --region "$REGION"
    echo "[+] Dépôt '$REPO_NAME' créé."
else
    echo "[=] Dépôt '$REPO_NAME' déjà existant."
fi

### CONSTRUCTION IMAGES FRONTEND, BACKEND, WEBSOCKET ###
echo ""
echo "[*] Construction de l'image Docker du frontend..."
docker build -t tp1-frontend ./frontend || { echo "[!] Échec de la construction de l'image tp1-frontend"; exit 1; }
echo ""
echo "[*] Construction de l'image Docker du backend..."
docker build -t tp1-backend ./backend || { echo "[!] Échec de la construction de l'image tp1-backend"; exit 1; }
echo ""
echo "[*] Construction de l'image Docker du websocket..."
docker build -t tp1-websocket ./websocket || { echo "[!] Échec de la construction de l'image tp1-websocket"; exit 1; }

### CONSTRUCTION IMAGE DB ###
echo ""
echo "[*] Construction de l'image Docker personnalisée pour PostgreSQL..."
docker build -t tp1-db ./db || { echo "[!] Échec de la construction de l'image tp1-db"; exit 1; }

### TAG & PUSH DES IMAGES ###
for image in "${IMAGES[@]}"; do
  tag="${image#tp1-}"  # extrait "frontend", "backend", etc.
  echo ""
  echo "[*] Traitement de l'image locale '$image' → tag distant : '$tag'"
  docker tag "$image:latest" "$REMOTE_REPO:$tag"
  docker push "$REMOTE_REPO:$tag"
  echo "[+] Push réussi → $REMOTE_REPO:$tag"
done

echo ""
echo "[✔] Toutes les images ont été poussées dans le dépôt ECR '$REPO_NAME'."
