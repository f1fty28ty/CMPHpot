#!/bin/bash

echo "[*] Installing dependencies..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y docker.io docker-compose

# Start and enable Docker service
sudo systemctl enable --now docker

echo "[+] Installation complete. You can now run ./deploy.sh"