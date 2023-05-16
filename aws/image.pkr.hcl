data "http" "consul_version" {
  url = "https://api.releases.hashicorp.com/v1/releases/consul/latest"
}

data "http" "nomad_version" {
  url = "https://api.releases.hashicorp.com/v1/releases/nomad/latest"
}

data "http" "vault_version" {
  url = "https://api.releases.hashicorp.com/v1/releases/vault/latest"
}

locals {
  consul_version = jsondecode(data.http.consul_version.body).version
  nomad_version  = jsondecode(data.http.nomad_version.body).version
  vault_version  = jsondecode(data.http.vault_version.body).version
  timestamp      = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "region" {
  type = string
}

source "amazon-ebs" "hashistack" {
  ami_name         = "mws-learn-nomad-${local.timestamp}"
  instance_type    = "t3a.medium"
  region           = var.region
  communicator     = "ssh"
  ssh_username     = "ubuntu"
  force_deregister = true
  force_delete_snapshot = true
  
  source_ami_filter {
    filters = {
      architecture                       = "x86_64"
      "block-device-mapping.volume-type" = "gp2"
      name                               = "ubuntu/images/hvm-ssd/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type                   = "ebs"
      virtualization-type                = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  tags = {
    Name          = "mws-learn-nomad"
    source        = "hashicorp/learn"
    purpose       = "demo"
    OS_Version    = "Ubuntu"
    Release       = "22.04"
    Base_AMI_ID   = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Consul_Version = local.consul_version
    Nomad_Version = local.nomad_version
    Vault_Version = local.vault_version
  }
  
  snapshot_tags = {
    Name    = "mws-learn-nomad"
    source  = "hashicorp/learn"
    purpose = "demo"
  }
}

build {
  sources = ["source.amazon-ebs.hashistack"]

  provisioner "shell" {
    inline = ["sudo mkdir -p /ops/shared", "sudo chmod 777 -R /ops"]
  }

  provisioner "file" {
    destination = "/ops"
    source      = "../shared"
  }

  provisioner "shell" {
    environment_vars = ["INSTALL_NVIDIA_DOCKER=false", "CLOUD_ENV=aws"]
    script           = "../shared/scripts/setup.sh"
  }

}
