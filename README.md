
## Prérequis

- VPS Linux (Ubuntu recommandé)  
- Accès root ou sudo  
- Compte ngrok et token

## Installation

### 1. Cloner le dépôt :

```bash
git clone https://github.com/Dropxtor/n8n-vps-setup.git
cd n8n-vps-setup
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

