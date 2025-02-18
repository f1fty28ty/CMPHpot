#!/bin/bash

echo "[*] Setting up fake admin activity and honey tokens..."

# ───────────────────────────────────────────────────
# FAKE ADMIN ACTIVITY (Retaining Previous Functionality)
# ───────────────────────────────────────────────────

# Fake last login
echo "admin  pts/0        192.168.1.5   Wed Feb 14 15:30   still logged in" > /var/log/lastlog

# Fake sudo usage logs
echo "Feb 17 10:10:22 server01 sudo: admin : TTY=pts/1 ; PWD=/home/admin ; USER=root ; COMMAND=/bin/bash" >> /var/log/auth.log

# Fake file edits (modifying a "sensitive" file)
echo "# Root Password (encrypted)" > /etc/fake_secrets.txt
echo "root:098f6bcd4621d373cade4e832627b4f6" >> /etc/fake_secrets.txt
chmod 600 /etc/fake_secrets.txt

# Fake cron job to run every 30 minutes
echo "*/30 * * * * root /bin/bash -c 'echo Fake cron job running at $(date)' >> /var/log/cron.log" > /etc/cron.d/fake_cron

# ───────────────────────────────────────────────────
# HONEY TOKEN SETUP (New Functionality)
# ───────────────────────────────────────────────────

# Create honey token directory if not exists
mkdir -p /opt/honeytokens

# Create honey token files
echo "AWS_ACCESS_KEY_ID=AKIAFAKEKEYEXAMPLE" > /opt/honeytokens/api_keys.txt
echo "AWS_SECRET_ACCESS_KEY=fakeSecretKey123456789" >> /opt/honeytokens/api_keys.txt

echo '{
  "username": "admin",
  "password": "SuperSecure123!"
}' > /opt/honeytokens/credentials.json

echo "-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA7z...
-----END RSA PRIVATE KEY-----" > /opt/honeytokens/ssh_private_key.pem

# Set permissions for realism
chmod 600 /opt/honeytokens/*

# Configure auditd rules to monitor honey token access
echo "Setting up audit rules for honey tokens..."
echo "-w /opt/honeytokens/api_keys.txt -p rwxa -k honeytoken_alert" > /etc/audit/rules.d/honeytokens.rules
echo "-w /opt/honeytokens/credentials.json -p rwxa -k honeytoken_alert" >> /etc/audit/rules.d/honeytokens.rules
echo "-w /opt/honeytokens/ssh_private_key.pem -p rwxa -k honeytoken_alert" >> /etc/audit/rules.d/honeytokens.rules

# Apply the audit rules
auditctl -R /etc/audit/rules.d/honeytokens.rules

# Restart auditd to apply changes
service auditd restart

echo "[+] Fake admin activity and honey tokens setup complete!"