#!/bin/bash

echo "[*] Building and Deploying Honeypot..."

# Build the vulnerable honeypot image
docker build -t honeypot:v1 .

# Run the honeypot container
docker run -d --name honeypot --privileged --network=host honeypot:v1

echo "[*] Deploying Splunk Universal Forwarder..."
docker-compose -f splunk.yml up -d

echo "[*] Deployment Completed. Running Containers:"
docker ps