output "public_svpn_nameservers" {
  value = var.enable_zone_svpn_public == 1 ? flatten(module.chownow_public_svpn_zone.0.name_servers) : []
}

output "chownowcdn_nameservers" {
  value = var.enable_zone_chownowcdn == 1 ? flatten(module.chownowcdn_zone.0.name_servers) : []
}
