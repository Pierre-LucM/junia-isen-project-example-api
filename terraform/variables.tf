variable "resource_group_name" {
  default = "ARTOLEPISA_ressourcegroups"
}
variable "location" {
  default = "francecentral"
}
variable "Vnet_name" {
  default = "ARTOLEPISA_vnet-secure"
}
variable "ip_public_name" {
  default = "ARTOLEPISA-public-ip"
}
variable "nat_gateway_name" {
  default = "ARTOLEPISA-nat-gateway"
}
variable "subnet_name_1" {
  default = "ARTOLEPISA-subnet_ip_gateway"
}