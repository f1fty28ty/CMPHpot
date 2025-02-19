## **🛡️ Metasploitable Honeypot with Splunk Universal Forwarder**

A **deliberately vulnerable Linux honeypot** that mimics an **admin-like** server while capturing attacker activity.  
It features **fake users, weak credentials, misleading logs, honey tokens, and monitored traps**—with all logs sent to **Splunk Universal Forwarder**.

---

## **📌 Features**
### **🔹 Fake Admin Activity**
- **Fake sudo logs** to simulate an active administrator.
- **Fake cron jobs** running system commands every 30 minutes.
- **Fake `/etc/passwd` & `/etc/shadow`** with weak password hashes.
- **Deceptive `.bash_history`** to lead attackers to fake credentials.

### **🔹 Exploitable Services**
| Service  | Port  | Notes |
|----------|------:|--------------------------------|
| SSH      |   22  | Weak credentials (`admin:SuperSecure123!`) |
| Apache   |   80  | Open web server with fake logs |
| MySQL    |  3306 | Default setup, weak creds possible |
| FTP      |   21  | Anonymous access enabled |
| Telnet   |   23  | Plaintext login, weak creds |

### **🔹 Honey Tokens (Traps for Attackers)**
- **Fake API keys** stored in `/opt/honeytokens/api_keys.txt`
- **Fake login credentials** in `/opt/honeytokens/credentials.json`
- **Fake SSH private key** in `/opt/honeytokens/ssh_private_key.pem`
- **Auditd detects access attempts** and triggers Splunk alerts.

### **🔹 Logging & Monitoring**
- **Auditd** monitors access to honey tokens.
- **Splunk Universal Forwarder** ships logs to an external Splunk server.
- **All log activity is captured** and can be analyzed in Splunk.

---

## **🚀 Installation & Deployment**
### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/YOUR_USERNAME/honeypot.git
cd honeypot
```

### **2️⃣ Install Dependencies**
```bash
./install.sh
```
This installs **Docker, Docker Compose, and Splunk Universal Forwarder**.

### **3️⃣ Deploy the Honeypot**
```bash
./deploy.sh
```
- **Builds & runs the honeypot container**  
- **Starts Splunk Universal Forwarder to send logs**  

### **4️⃣ Monitor Logs (Inside Splunk)**
```bash
docker exec -it splunk-forwarder bash
ls /var/log/audit/
tail -f /var/log/audit/audit.log
```

---

## **🔍 Testing the Honeypot**
Try accessing the honey tokens:
```bash
cat /opt/honeytokens/api_keys.txt
nano /opt/honeytokens/ssh_private_key.pem
```
📌 **Alerts will be sent to Splunk!**  


