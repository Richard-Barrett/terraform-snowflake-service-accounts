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
  description = "The RSA private key"
  value       = tls_private_key.rsa_key.private_key_pem
  sensitive   = true
}

output "rsa_public_key" {
  description = "The first RSA public key"
  value       = tls_private_key.rsa_key.public_key_pem
}

output "rsa_public_key_2" {
  description = "The second RSA public key"
  value       = tls_private_key.rsa_key_2.public_key_pem
}
