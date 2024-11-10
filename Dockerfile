# Use a base image with Ubuntu
FROM ubuntu:latest

# Update packages, install OpenSSH server, and install Nginx for serving HTML
RUN apt-get update && \
    apt-get install -y openssh-server nginx && \
    mkdir /var/run/sshd

# Create a new user
RUN useradd -m -s /bin/bash user && \
    echo "user:password" | chpasswd

# Set up SSH to use port 2222
RUN sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Copy the index.html from the parent directory to Nginx's default web directory
COPY index.html /var/www/html/index.html

# Expose port 8080 for HTTP and 2222 for SSH access
EXPOSE 8080 2222

# Start both SSH and Nginx services
CMD service ssh start && nginx -g 'daemon off;'
