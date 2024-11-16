#!/bin/sh

# Deploy keys to allow all nodes to connect each others as root
#mv /tmp/id_rsa*  /root/.ssh/
#
#chmod 400 /root/.ssh/id_rsa*
#chown root:root  /root/.ssh/id_rsa*
#
#cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
#chmod 400 /root/.ssh/authorized_keys
#chown root:root /root/.ssh/authorized_keys

# Add current node in  /etc/hosts
echo "127.0.1.1 $(hostname)" >> /etc/hosts

# Get current IP adress
export currentip=$(/sbin/ip -o -4 addr list enp0s8 | awk '{print $4}' | cut -d/ -f1)

# Add Hashicorp repository

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install vault & prereq

sudo apt update
sudo apt install vault net-tools apt-transport-https gnupg curl wget bat -y

# Set up UFW

sudo ufw allow OpenSSH
sudo ufw allow https

for i in 8200/tcp 8201/tcp 8250/tcp 443/tcp
do sudo ufw allow $i
done

#sudo ufw enable -y

# prepare vault configuration

sed -i 's/serverip/'$currentip'/g' /tmp/config.hcl
mv /tmp/config.hcl /etc/vault.d/config.hcl

# Create user without login for vault service
sudo adduser vault --shell=/bin/false --no-create-home --disabled-password --gecos GECOS

# granting access to vault user
chmod 700 -R /opt/vault
chown vault -R /opt/vault


sudo tee -a /etc/systemd/system/vault.service > /dev/null <<EOT
[Unit]
Description="Hashicorp Vault"
Documentation="https://developer.hashicorp.com/vault/docs"
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/config.hcl
[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/bin/vault server -config=/etc/vault.d/config.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitInterval=60
StartLimitBurst=3
LimitNOFILE=65536
LimitMEMLOCK=infinity

[Install]
WantedBy=multi-user.target
EOT
# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl start vault.service
sudo systemctl enable vault.service