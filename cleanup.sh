#!/bin/bash

echo "[*] Stopping and removing containers..."

# Stop and remove honeypot
docker stop honeypot && docker rm honeypot

# Stop and remove Splunk Forwarder
docker-compose -f splunk.yml down

echo "[+] Cleanup complete."