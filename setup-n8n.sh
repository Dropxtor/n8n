#!/bin/bash

# Créé par [Votre Nom] - Version fixée

set -e  # Arrête sur erreur

echo "=================================="
echo " _______                                        __                       
|       \                                      |  \                      
| ▓▓▓▓▓▓▓\ ______   ______   ______  __    __ _| ▓▓_    ______   ______  
| ▓▓  | ▓▓/      \ /      \ /      \|  \  /  \   ▓▓ \  /      \ /      \ 
| ▓▓  | ▓▓  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓\/  ▓▓\▓▓▓▓▓▓ |  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\
| ▓▓  | ▓▓ ▓▓   \▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓ >▓▓  ▓▓ | ▓▓ __| ▓▓  |  ▓▓  ▓▓   \▓▓_   
| ▓▓    ▓▓ ▓▓      \▓▓    ▓▓ ▓▓    ▓▓  ▓▓ ▓▓\  \▓▓  ▓▓\▓▓     ▓▓  ▓▓      
 \▓▓▓▓▓▓▓ \▓▓       \▓▓▓▓▓▓| ▓▓▓▓▓▓▓ \▓▓   \▓▓   \▓▓▓▓  \▓▓▓▓▓▓   ▓▓      
                           | ▓▓                                          
                           | ▓▓                                          
      "
echo "=================================="

echo "🔹 Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

echo "🔹 Installation de Docker..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common jq  # Ajout de jq pour parser ngrok API
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh  # Utilise sudo pour sh
rm get-docker.sh  # Nettoyage
sudo systemctl enable --now docker  # Active et démarre Docker
sudo usermod -aG docker "$USER"  # Pour futures sessions sans sudo

echo "🔹 Vérification de Docker..."
sudo docker --version

echo "🔹 Création du volume persistant pour n8n..."
sudo docker volume create n8n_data

echo "🔹 Téléchargement de l'image n8n..."
sudo docker pull n8nio/n8n

echo "🔹 Génération d'un mot de passe aléatoire pour n8n..."
N8N_PASSWORD=$(openssl rand -base64 12)  # Mot de passe sécurisé
echo "🔒 Mot de passe n8n généré : $N8N_PASSWORD (notez-le !)"

echo "🔹 Lancement de n8n en background..."
sudo docker run -d --name n8n --restart always -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD="$N8N_PASSWORD" \
  n8nio/n8n

echo "🔹 Installation de ngrok..."
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar xvzf ngrok-v3-stable-linux-amd64.tgz
sudo mv ngrok /usr/local/bin/
rm ngrok-v3-stable-linux-amd64.tgz  # Nettoyage

# Interaction sécurisée pour le token ngrok
while true; do
    read -p "🔑 Entrez votre token ngrok : " NGROK_TOKEN
    if [ -n "$NGROK_TOKEN" ]; then
        ngrok config add-authtoken "$NGROK_TOKEN"
        break
    else
        echo "⚠️ Token vide, veuillez réessayer."
    fi
done

echo "🔹 Lancement du tunnel ngrok en background..."
ngrok http 5678 > ngrok.log 2>&1 &
NGROK_PID=$!
sleep 5  # Attente pour que ngrok démarre

# Extraction de l'URL HTTPS via API ngrok
PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.proto == "https") | .public_url')
if [ -z "$PUBLIC_URL" ]; then
    echo "⚠️ Erreur : Impossible d'obtenir l'URL ngrok. Vérifiez ngrok.log et relancez 'ngrok http 5678' manuellement."
    kill $NGROK_PID
    exit 1
fi

echo "✅ Installation terminée ! n8n est en cours d'exécution sur le port 5678."
echo "Accédez à n8n via l'URL sécurisée : $PUBLIC_URL"
echo "Login : admin / Mot de passe : $N8N_PASSWORD"
echo "Pour arrêter n8n : sudo docker stop n8n"
echo "Pour arrêter ngrok : kill $NGROK_PID"
echo "Logs n8n : sudo docker logs n8n"
echo "Logs ngrok : cat ngrok.log"
