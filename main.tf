terraform {
  required_version = ">= 1.3.6"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.94.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
}

resource "random_password" "password" {
  length           = var.password_length
  special          = true
  override_special = "_%@"
}

// Create two RSA keys
// Documentation: https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
}

resource "tls_private_key" "rsa_key_2" {
  algorithm = "RSA"
}

resource "snowflake_user" "this" {
  depends_on           = [random_password.password, tls_private_key.rsa_key, tls_private_key.rsa_key_2]
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
  rsa_public_key       = tls_private_key.rsa_key.public_key_pem
  rsa_public_key_2     = tls_private_key.rsa_key_2.public_key_pem
}

resource "snowflake_user_public_keys" "rsa_public_key" {
  depends_on       = [random_password.password, snowflake_user.this, tls_private_key.rsa_key, tls_private_key.rsa_key_2]
  name             = snowflake_user.this.name
  rsa_public_key   = tls_private_key.rsa_key.public_key_pem
  rsa_public_key_2 = tls_private_key.rsa_key_2.public_key_pem
}


## Complete (with every optional set)
resource "snowflake_network_policy" "this" {
  count = var.has_network_policy ? 1 : 0

  name            = "${upper(snowflake_user.this.name)}_NETWORK_POLICY"
  allowed_ip_list = var.allowed_ip_list // Example: ["192.168.1.0/24"]
  blocked_ip_list = var.blocked_ip_list // Example: ["192.168.1.99"]
  comment         = "Network Policy for ${snowflake_user.this.name}"
}

resource "snowflake_network_policy_attachment" "this" {
  count = var.has_network_policy ? 1 : 0

  network_policy_name = snowflake_network_policy.this[0].name
  set_for_account     = var.set_for_account
  users               = [snowflake_user.this.name]
}
