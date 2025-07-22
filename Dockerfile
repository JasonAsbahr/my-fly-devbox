FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y openssh-server mosh sudo vim git curl wget build-essential && \
    useradd -m dev && echo "dev:password" | chpasswd && adduser dev sudo

RUN mkdir /var/run/sshd && \
    mkdir -p /home/dev/.ssh && \
    chown -R dev:dev /home/dev/.ssh && \
    chmod 700 /home/dev/.ssh

# Enable password authentication for SSH (temporarily for testing)
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Create directory for persistent data
RUN mkdir -p /data && chown dev:dev /data

EXPOSE 22 60000-61000/udp

CMD /usr/sbin/sshd -D