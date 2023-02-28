output "lb_address_consul_nomad" {
  value = "http://${azurerm_linux_virtual_machine.server[0].public_ip_address}"
}

output "consul_bootstrap_token_secret" {
  value = var.nomad_consul_token_secret
}

output "IP_Addresses" {
  value = <<CONFIGURATION

Client public IPs: ${join(", ", azurerm_linux_virtual_machine.client[*].public_ip_address)}
Client private IPs: ${join(", ", azurerm_linux_virtual_machine.client[*].private_ip_address)}

Server public IPs: ${join(", ", azurerm_linux_virtual_machine.server[*].public_ip_address)}
Server private IPs: ${join(", ", azurerm_linux_virtual_machine.server[*].private_ip_address)}

The Consul UI can be accessed at http://${azurerm_linux_virtual_machine.server[0].public_ip_address}:8500/ui
with the bootstrap token: ${var.nomad_consul_token_secret}
CONFIGURATION
}
