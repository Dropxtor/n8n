
## Prérequis

- VPS Linux (Ubuntu recommandé)  
- Accès root ou sudo  
- Compte ngrok et token

## Installation

### 1. Cloner le dépôt :

```bash
git clone https://github.com/Dropxtor/n8n.git
cd n8n
```
créer une session screen
```bash
screen -S n8n
```
### 2. Executer
```bash
chmod +x setup-n8n.sh
```
### 3. Lancer
```bash
./setup-n8n.sh
```
### 4.Entrer votre token ngrok quand le script le demande.

### 5.n8n sera lancé sur le port 5678. Pour créer un tunnel HTTPS :
```bash
ngrok http 5678
```

Vous obtiendrez une URL sécurisée du type https://abc123.ngrok.io.

### 6. Utilisation

Accéder à n8n depuis votre navigateur : http://VOTRE_IP:5678 ou l’URL ngrok.

Vos workflows et credentials sont persistés dans ~/.n8n.
 
### 7.Supprimer
  
```bash
chmod +x clean-n8n.sh
```

```bash
./clean-n8n.sh
```
### 8. Supplementaires

##### Détacher la session (laisser tourner en arrière-plan)

CTRL + A puis D
##### Revenir dans la session

```bash
screen -r n8n
```

Vérifiez les conteneurs existants :
```bash
sudo docker ps -a  # Liste tous les conteneurs (en cours ou arrêtés)
```
Cherchez le conteneur avec l'ID dc2e243255b3... ou nommé "n8n".

Arrêtez le conteneur existant (si en cours) :
```bash
sudo docker stop n8n  # Ou remplacez "n8n" par l'ID si nécessaire
```
Supprimez le conteneur existant :bash
```bash
sudo docker rm n8n  # Cela libère le nom
```

