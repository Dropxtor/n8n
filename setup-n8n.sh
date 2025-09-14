#!/bin/bash

# Créé par 

set -e

echo "=================================="
echo " _______                                        __                       
|       \                                      |  \                      
| ▓▓▓▓▓▓▓\ ______   ______   ______  __    __ _| ▓▓_    ______   ______  
| ▓▓  | ▓▓/      \ /      \ /      \|  \  /  \   ▓▓ \  /      \ /      \ 
| ▓▓  | ▓▓  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓\/  ▓▓\▓▓▓▓▓▓ |  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\
| ▓▓  | ▓▓ ▓▓   \▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓ >▓▓ ▓▓  | ▓▓ __| ▓▓  |  ▓▓  ▓▓   \▓▓_   
| ▓▓    ▓▓ ▓▓      \▓▓    ▓▓ ▓▓    ▓▓  ▓▓ ▓▓\  \▓▓  ▓▓\▓▓     ▓▓  ▓▓      
 \▓▓▓▓▓▓▓ \▓▓       \▓▓▓▓▓▓| ▓▓▓▓▓▓▓ \▓▓   \▓▓   \▓▓▓▓  \▓▓▓▓▓▓   ▓▓      
                           | ▓▓                                          
                           | ▓▓                                          
      "
echo "=================================="

echo "🔹 Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

echo "🔹 Installation de Docker..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER

echo "🔹 Vérification de Docker..."
docker --version

echo "🔹 Téléchargement de l'image n8n..."
docker pull n8nio/n8n

echo "🔹 Lancement de n8n en background..."
docker run -d --name n8n -p 5678:5678 -v ~/.n8n:/home/node/.n8n n8nio/n8n

echo "🔹 Installation de ngrok..."
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar xvzf ngrok-v3-stable-linux-amd64.tgz
sudo mv ngrok /usr/local/bin

# Interaction sécurisée pour le token ngrok
while true; do
    read -p "🔑 Entrez votre token ngrok : " NGROK_TOKEN
    if [ -n "$NGROK_TOKEN" ]; then
        ngrok config add-authtoken "$NGROK_TOKEN"
        break
    else
        echo "⚠️  Token vide, veuillez réessayer."
    fi
done

echo "🔹 Tunnel HTTPS prêt ! Pour démarrer le tunnel, exécutez :"
echo "ngrok http 5678"

echo "✅ Installation terminée ! n8n est en cours d'exécution sur le port 5678."
echo "Accédez à n8n via : http://VOTRE_IP:5678 ou via l'URL HTTPS ngrok."
