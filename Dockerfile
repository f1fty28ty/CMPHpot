# Base Image (Use Debian-based image for compatibility)
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install vulnerable services
RUN apt update && apt install -y \
    openssh-server \
    netcat \
    apache2 \
    mysql-server \
    python3 \
    ftp \
    telnet \
    && apt clean

# Setup SSH with weak credentials
RUN mkdir /var/run/sshd && \
    echo 'root:toor' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose vulnerable services
EXPOSE 22 80 3306 21 23

# Start all services
CMD service ssh start && \
    service apache2 start && \
    service mysql start && \
    tail -f /dev/null