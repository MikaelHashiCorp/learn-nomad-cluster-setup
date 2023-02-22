# Packer variables (all are required)
location = "LOCATION"
subscription_id = "${env(ARM_SUBSCRIPTION_ID)}"
tenant_id = "${env(ARM_ARM_TENANT_ID)}"
client_id = "${env(ARM_CLIENT_ID)}"
client_secret = "${env(ARM_CLIENT_SECRET)}"

resource_group_name = "nomad-cluster-rg"
storage_account = "nomadvms"

# Terraform variables (all are required)
# https://developer.hashicorp.com/consul/docs/install/cloud-auto-join#microsoft-azure
retry_join = "provider=azure tag_name=ConsulAutoJoin tag_value=auto-join subscription_id=ARM_SUBSCRIPTION_ID tenant_id=ARM_TENANT_ID client_id=ARM_CLIENT_ID secret_access_key='ARM_CLIENT_SECRET'"

# Alphanumeric and periods only
image_name = "IMAGE_FROM_PACKER"

nomad_consul_token_id = "123e4567-e89b-12d3-a456-426614174000"
nomad_consul_token_secret = "123e4567-e89b-12d3-a456-426614174000"

# Range to allow SSH and Consul/Nomad UI access
# Ports 22, 8500, 4646
allowlist_ip = "0.0.0.0/0"
# Default password for instances
admin_password = "password"

# These variables will default to the values shown
# and do not need to be updated unless you want to
# change them
# name                            = "nomad"
# server_instance_type            = "t2.micro"
# server_count                    = "3"
# client_instance_type            = "t2.micro"
# client_count                    = "3"


