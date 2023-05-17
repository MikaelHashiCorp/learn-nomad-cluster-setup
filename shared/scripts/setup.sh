#!/bin/bash

set -e

# Disable interactive apt-get prompts
export DEBIAN_FRONTEND=noninteractive

echo "== add-apt-repository universe =="
sudo add-apt-repository universe
echo "== apt-get update ==" 
sudo apt-get update 
echo "== apt-get upgrade ==" 
sudo apt-get upgrade -y
echo "== apt-get install =="
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common unzip tree redis-tools jq curl tmux ec2-instance-connect ca-certificates gnupg2
echo "== apt-get clean =="
sudo apt-get clean
echo "== end of apt-get =="

cd /ops

echo "pwd = $(pwd)"

CONFIGDIR=/ops/shared/config

CONSULVERSION=$(curl -s https://api.releases.hashicorp.com/v1/releases/consul/latest | jq -r '.version')
echo "== Latest Consul version v${CONSULVERSION} =="
CONSULDOWNLOAD=https://releases.hashicorp.com/consul/${CONSULVERSION}/consul_${CONSULVERSION}_linux_amd64.zip
CONSULCONFIGDIR=/etc/consul.d
CONSULDIR=/opt/consul

NOMADVERSION=$(curl -s https://api.releases.hashicorp.com/v1/releases/nomad/latest | jq -r '.version')
echo "== Latest Nomad version v${NOMADVERSION} =="
NOMADDOWNLOAD=https://releases.hashicorp.com/nomad/${NOMADVERSION}/nomad_${NOMADVERSION}_linux_amd64.zip
NOMADCONFIGDIR=/etc/nomad.d
NOMADDIR=/opt/nomad

VAULTVERSION=$(curl -sS https://api.releases.hashicorp.com/v1/releases/vault/latest | jq -r '.version')
echo "== Latest Vault version v${VAULTVERSION}=="
VAULTDOWNLOAD=https://releases.hashicorp.com/vault/${VAULTVERSION}/vault_${VAULTVERSION}_linux_amd64.zip
VAULTCONFIGDIR=/etc/vault.d
VAULTDIR=/opt/vault

CONSULTEMPLATEVERSION=$(curl -s https://api.releases.hashicorp.com/v1/releases/consul-template/latest | jq -r '.version')
echo "== Latest Consul Template version v${CONSULTEMPLATEVERSION}/=="
CONSULTEMPLATEDOWNLOAD=https://releases.hashicorp.com/consul-template/${CONSULTEMPLATEVERSION}/consul-template_${CONSULTEMPLATEVERSION}_linux_amd64.zip
CONSULTEMPLATECONFIGDIR=/etc/consul-template.d
CONSULTEMPLATEDIR=/opt/consul-template

# Disable the firewall

sudo ufw disable || echo "ufw not installed"

# Consul

curl -L $CONSULDOWNLOAD > consul.zip

## Install
sudo unzip consul.zip -d /usr/local/bin
sudo chmod 0755 /usr/local/bin/consul
sudo chown root:root /usr/local/bin/consul

## Configure
sudo mkdir -p $CONSULCONFIGDIR
sudo chmod 755 $CONSULCONFIGDIR
sudo mkdir -p $CONSULDIR
sudo chmod 755 $CONSULDIR

# Vault

curl -L $VAULTDOWNLOAD > vault.zip

## Install
sudo unzip vault.zip -d /usr/local/bin
sudo chmod 0755 /usr/local/bin/vault
sudo chown root:root /usr/local/bin/vault

## Configure
sudo mkdir -p $VAULTCONFIGDIR
sudo chmod 755 $VAULTCONFIGDIR
sudo mkdir -p $VAULTDIR
sudo chmod 755 $VAULTDIR

# Nomad

curl -L $NOMADDOWNLOAD > nomad.zip

## Install
sudo unzip nomad.zip -d /usr/local/bin
sudo chmod 0755 /usr/local/bin/nomad
sudo chown root:root /usr/local/bin/nomad

## Configure
sudo mkdir -p $NOMADCONFIGDIR
sudo chmod 755 $NOMADCONFIGDIR
sudo mkdir -p $NOMADDIR
sudo chmod 755 $NOMADDIR

# Consul Template 

curl -L $CONSULTEMPLATEDOWNLOAD > consul-template.zip

## Install
sudo unzip consul-template.zip -d /usr/local/bin
sudo chmod 0755 /usr/local/bin/consul-template
sudo chown root:root /usr/local/bin/consul-template

## Configure
sudo mkdir -p $CONSULTEMPLATECONFIGDIR
sudo chmod 755 $CONSULTEMPLATECONFIGDIR
sudo mkdir -p $CONSULTEMPLATEDIR
sudo chmod 755 $CONSULTEMPLATEDIR


# Docker
distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/${distro} $(lsb_release -cs) stable"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce

# Java
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk
JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

# AWSCLI
echo "== Install AWSCLI =="
curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Set Up Environment Prompt
echo 'export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed "s/.$//")' >> ~/.bashrc
echo 'export INSTANCE_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" "Name=key,Values=PromptID" --query "Tags[0].Value" --output text --region us-east-1)' >> ~/.bashrc
echo "alias env=\"env -0 | sort -z | tr '\0' '\n'\"" >> ~/.bashrc
echo 'PS1="($INSTANCE_NAME)$PS1"' >> ~/.bashrc
cat ~/.bashrc
