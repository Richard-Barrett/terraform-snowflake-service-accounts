terraform {
  required_version = ">= 1.3.6"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">= 1.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.6.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.5"
    }
  }
}

resource "random_password" "password" {
  length           = var.password_length
  special          = true
  override_special = "_%@"
}

// Conditionally create RSA private keys
resource "tls_private_key" "rsa_key_1" {
  count     = var.manage_private_keys ? 1 : 0
  algorithm = "RSA"
}

resource "tls_private_key" "rsa_key_2" {
  count     = var.manage_private_keys ? 1 : 0
  algorithm = "RSA"
}

// Manage Snowflake User
resource "snowflake_user" "this" {
  depends_on           = [random_password.password]
  name                 = "${upper(var.name)}_SVC_ACCOUNT"
  password             = random_password.password.result
  default_role         = var.default_role
  default_warehouse    = var.default_warehouse
  disabled             = var.disabled
  default_namespace    = var.default_namespace
  login_name           = var.login_name
  display_name         = var.display_name
  first_name           = var.first_name
  last_name            = var.last_name
  email                = var.email
  must_change_password = var.must_change_password

  # Conditionally add RSA public keys if manage_public_keys = true
  rsa_public_key   = var.manage_public_keys && var.manage_private_keys ? tls_private_key.rsa_key_1[0].public_key_pem : null
  rsa_public_key_2 = var.manage_public_keys && var.manage_private_keys ? tls_private_key.rsa_key_2[0].public_key_pem : null
}

// Conditionally manage public keys in Snowflake
resource "snowflake_user_public_keys" "rsa_public_key" {
  count = var.manage_public_keys ? 1 : 0

  depends_on       = [snowflake_user.this]
  name             = snowflake_user.this.name
  rsa_public_key   = var.manage_private_keys ? tls_private_key.rsa_key_1[0].public_key_pem : null
  rsa_public_key_2 = var.manage_private_keys ? tls_private_key.rsa_key_2[0].public_key_pem : null
}

// Conditionally create network policy
resource "snowflake_network_policy" "this" {
  count = var.has_network_policy ? 1 : 0

  name            = "${upper(snowflake_user.this.name)}_NETWORK_POLICY"
  allowed_ip_list = var.allowed_ip_list
  blocked_ip_list = var.blocked_ip_list
  comment         = "Network Policy for ${snowflake_user.this.name}"
}

resource "snowflake_network_policy_attachment" "this" {
  count = var.has_network_policy ? 1 : 0

  network_policy_name = snowflake_network_policy.this[0].name
  set_for_account     = var.set_for_account
  users               = [snowflake_user.this.name]
}
