#!/bin/bash

echo "[*] Installing and Deploying Honeypot..."

# Build the honeypot image
docker build -t honeypot:v3 .

# Run the honeypot container
docker run -d --name honeypot --privileged --network=host honeypot:v3

echo "[*] Installing and Deploying Splunk Universal Forwarder..."
docker-compose -f splunk.yml up -d

echo "[*] Deployment Completed. Running Containers:"
docker ps