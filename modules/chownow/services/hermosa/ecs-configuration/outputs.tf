output "configuration_secret_arn" {
  value = module.configuration.secret_arn
}

output "ssl_key_secret_arn" {
  value = module.ssl_key.secret_arn
}

output "ssl_cert_secret_arn" {
  value = module.ssl_cert.secret_arn
}
