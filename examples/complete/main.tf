terraform {
  required_version = ">= 1.5.6"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.90.0"
    }
  }
}

provider "snowflake" {}

module "snowflake_service_account" {
  source = "../.." # Path to the root of the module

  name                 = "example_user"
  password_length      = 20
  default_role         = "PUBLIC"
  default_warehouse    = "my_warehouse"
  disabled             = false
  default_namespace    = "my_namespace"
  login_name           = "example_login"
  display_name         = "Example User"
  first_name           = "Example"
  last_name            = "User"
  email                = "example@example.com"
  must_change_password = true

  has_network_policy = true
  allowed_ip_list    = ["192.0.2.0", "203.0.113.0"]
  blocked_ip_list    = ["192.0.2.1", "203.0.113.1"]
}
