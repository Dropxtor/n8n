#!/bin/bash
# Créé 
set -e

echo "=================================="
echo "  ____  ____  ____  ____  ____  "
echo " |  _ \|  _ \|  _ \|  _ \|  _ \ "
echo " | | | | | | | | | | | | | | | |"
echo " | |_| | |_| | |_| | |_| | |_| |"
echo " |____/|____/|____/|____/|____/ "
echo "         dropxtor                 "
echo "=================================="

echo "🔹 Arrêt et suppression du container n8n..."
docker stop n8n 2>/dev/null || true
docker rm n8n 2>/dev/null || true

echo "🔹 Suppression de l'image Docker n8n..."
docker rmi n8nio/n8n 2>/dev/null || true

echo "🔹 Nettoyage des images et volumes Docker inutilisés..."
docker system prune -a -f

echo "🔹 Suppression des données n8n persistées..."
rm -rf ~/.n8n

echo "🔹 Désinstallation de ngrok..."
sudo rm -f /usr/local/bin/ngrok

echo "🔹 Désinstallation de Docker (optionnel)..."
sudo apt remove --purge docker docker-engine docker.io containerd runc -y
sudo apt autoremove -y

echo "✅ Désinstallation complète terminée !"
echo "Votre VPS est maintenant clean."
