module "network_test" {
  source = "../modules/network"

  resource_group_name = "ARTOLEPISA_ressourcegroups"
  location            = "francecentral"
  vnet_name           = "ARTOLEPISA_vnet-secure"
  subnet_name_1       = "ARTOLEPISA-subnet_ip_gateway"
  ip_public_name      = "ARTOLEPISA-public-ip"
  nat_gateway_name    = "ARTOLEPISA-nat-gateway"
}

output "resource_group_name" {
  value = module.network_test.resource_group_name
}

output "vnet_id" {
  value = module.network_test.vnet_id
}

output "subnet_id" {
  value = module.network_test.subnet_id
}

output "public_ip_id" {
  value = module.network_test.public_ip_id
}

output "nat_gateway_id" {
  value = module.network_test.nat_gateway_id
}
