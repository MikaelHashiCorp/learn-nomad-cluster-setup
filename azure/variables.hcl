# Packer variables (all are required)
location = "eastus"
subscription_id = "6e3c9dc4-6f76-4d10-904c-0f016dcad60d"
tenant_id = "0e3e2e88-8caf-41ca-b4da-e3b33b6c52ec"
client_id = "879a7a7b-4a33-4054-8648-2e75fbac4329"
client_secret = "h2c8Q~kT7ZTaPupEv6DZxhY3eWWhb3LcKjkJeavK"

resource_group_name = "nomad-cluster-rg-mws"
storage_account = "nomadvms1mws"

# Terraform variables (all are required)
# https://developer.hashicorp.com/consul/docs/install/cloud-auto-join#microsoft-azure
// retry_join = "provider=azure tag_name=ConsulAutoJoin tag_value=auto-join subscription_id=${var.subscription_id} tenant_id=${var.tenant_id} client_id=${var.client_id} secret_access_key='${var.client_secret}'"
retry_join = "provider=azure tag_name=ConsulAutoJoin tag_value=auto-join subscription_id=6e3c9dc4-6f76-4d10-904c-0f016dcad60d tenant_id=0e3e2e88-8caf-41ca-b4da-e3b33b6c52ec client_id=879a7a7b-4a33-4054-8648-2e75fbac4329 secret_access_key=h2c8Q~kT7ZTaPupEv6DZxhY3eWWhb3LcKjkJeavK"

# Alphanumeric and periods only
image_name = "hashistack.20230227224340"

nomad_consul_token_id = "763ed9b9-eefc-96d9-1b82-6d55b9c871ef"
nomad_consul_token_secret = "0a345415-501f-5136-2d23-6b7e47fd7a7d"

# Range to allow SSH and Consul/Nomad UI access
# Ports 22, 8500, 4646
allowlist_ip = "0.0.0.0/0"
# Default password for instances
admin_password = "GoodApples01"

# These variables will default to the values shown
# and do not need to be updated unless you want to
# change them
# name                            = "nomad"
# server_instance_type            = "t2.micro"
# server_count                    = "3"
# client_instance_type            = "t2.micro"
# client_count                    = "3"
