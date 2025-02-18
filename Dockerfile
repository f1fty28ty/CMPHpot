# Base Image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install vulnerable services and tools
RUN apt update && apt install -y \
    openssh-server \
    auditd \
    audispd-plugins \
    apache2 \
    mysql-server \
    ftp \
    telnet \
    sudo \
    netcat \
    nano \
    cron \
    rsyslog \
    splunkforwarder \
    && apt clean

# Create fake users and weak passwords
RUN useradd -m -s /bin/bash admin && echo 'admin:SuperSecure123!' | chpasswd
RUN useradd -m -s /bin/bash user1 && echo 'user1:password123' | chpasswd
RUN useradd -m -s /bin/bash user2 && echo 'user2:qwerty' | chpasswd
RUN useradd -m -s /bin/bash tempuser && echo 'tempuser:123456' | chpasswd

# Give admin sudo privileges (fake sudoers)
RUN echo "admin ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/admin

# Copy fake sensitive files
COPY fake_files/passwd /etc/passwd
COPY fake_files/shadow /etc/shadow
COPY fake_files/bash_history /home/admin/.bash_history
COPY fake_files/ssh_config /home/admin/.ssh/config
COPY fake_files/fake_private.pem /home/admin/.ssh/id_rsa
COPY fake_files/hashes.txt /opt/hashes.txt

# Set permissions
RUN chmod 600 /home/admin/.ssh/id_rsa && chown admin:admin /home/admin/.ssh/id_rsa

# Copy fake admin activity script
COPY fake_admin.sh /opt/fake_admin.sh
RUN chmod +x /opt/fake_admin.sh

# Copy Splunk Universal Forwarder config
COPY splunk.yml /opt/splunk.yml

# Setup cron jobs
COPY fake_admin.sh /etc/cron.hourly/fake_admin
RUN chmod +x /etc/cron.hourly/fake_admin

# Expose services
EXPOSE 22 80 3306 21 23

# Start everything
CMD /opt/fake_admin.sh && service ssh start && service apache2 start && service mysql start && service cron start && tail -f /dev/null