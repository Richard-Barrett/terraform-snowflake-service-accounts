output "user_name" {
  description = "The name of the created user"
  value       = snowflake_user.this.name
}

output "user_password" {
  description = "The password of the created user"
  value       = random_password.password.result
  sensitive   = true
}

output "rsa_private_key" {
  description = "The RSA private key (first key)"
  value       = var.manage_private_keys ? tls_private_key.rsa_key_1[0].private_key_pem : null
  sensitive   = true
}

output "rsa_public_key" {
  description = "The first RSA public key"
  value       = var.manage_private_keys ? tls_private_key.rsa_key_1[0].public_key_pem : null
}

output "rsa_private_key_2" {
  description = "The RSA private key (second key)"
  value       = var.manage_private_keys ? tls_private_key.rsa_key_2[0].private_key_pem : null
  sensitive   = true
}

output "rsa_public_key_2" {
  description = "The second RSA public key"
  value       = var.manage_private_keys ? tls_private_key.rsa_key_2[0].public_key_pem : null
}
