# terraform-snowflake-service-accounts
Terraform Module for Making Service Accounts in Snowflake Securely

This Terraform module is designed to create a Snowflake user with a set of configurable attributes. Here's a summary of what it does:

1. It generates a random password and a pair of RSA keys for the user.

2. It creates a Snowflake user with the following attributes:
   - Name
   - Password
   - Default role
   - Default warehouse
   - Disabled status
   - Default namespace
   - Login name
   - Display name
   - First name
   - Last name
   - Email
   - Must change password status

3. If the `has_network_policy` variable is set to `true`, it creates a Snowflake network policy with the following attributes:
   - Name
   - Allowed IP list
   - Blocked IP list
   - Allowed network rule list
   - Blocked network rule list

4. If the `has_network_policy` variable is set to `true`, it attaches the created network policy to the user.

5. It outputs the following:
   - The name of the created user
   - The password of the created user (marked as sensitive)
   - The RSA private key (marked as sensitive)
   - The RSA public key

The module allows for a high degree of customization by making all of these attributes configurable through variables. This makes it easy to create Snowflake users with different configurations by simply changing the variables when calling the module.

Example CICD with `BitBucket` and `Codefresh`:

![Image](./images/diagram.png)

# Usage

A bare mimimum usage:

```hcl
module "snowflake_user" {
  source = "git::https://github.com/Richard-Barrett/terraform-snowflake-warehouses.git?ref=0.0.1"
  name   = "TABLEAU"
}
```
To use this module, you would call it from your Terraform configuration file and provide the necessary variables. Here's an example of how you might do this:

```hcl
module "snowflake_user" {
  source = "git::https://github.com/Richard-Barrett/terraform-snowflake-warehouses.git?ref=0.0.1"

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
}
```

Maybe you want to specify a network policy and lock down the user account to a specific IP Address.
Here is how you can achieve this:

```hcl
module "snowflake_user" {
  source = "git::https://github.com/Richard-Barrett/terraform-snowflake-warehouses.git?ref=0.0.1"

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

  has_network_policy         = true
  network_policy             = "my_network_policy"
  allowed_ip_list            = ["192.0.2.0", "203.0.113.0"]
  blocked_ip_list            = ["192.0.2.1", "203.0.113.1"]
}

```

# Overview

This Terraform module is designed to manage Snowflake users and their network policies. Here's a brief overview:

1. User Creation: The module creates a Snowflake user with configurable attributes such as name, default role, default warehouse, login name, display name, first name, last name, email, and a few others. It also generates a random password and RSA keys for the user.
2. Network Policy Management: If specified, the module can also create a Snowflake network policy with configurable attributes such as allowed and blocked IP lists, and allowed and blocked network rule lists. This policy is then attached to the user.
3. Outputs: The module outputs the user's name, password, and RSA keys. The password and private key are marked as sensitive.

In summary, this module provides a flexible way to manage Snowflake users and their network policies, with a high degree of customization available through the use of variables.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.90.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | 0.90.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) | resource |
| [snowflake_network_policy.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/network_policy) | resource |
| [snowflake_network_policy_attachment.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/network_policy_attachment) | resource |
| [snowflake_user.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/user) | resource |
| [snowflake_user_public_keys.rsa_public_key](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/user_public_keys) | resource |
| [tls_private_key.rsa_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.rsa_key_2](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ip_list"></a> [allowed\_ip\_list](#input\_allowed\_ip\_list) | n/a | `list(string)` | `[]` | no |
| <a name="input_blocked_ip_list"></a> [blocked\_ip\_list](#input\_blocked\_ip\_list) | n/a | `list(string)` | `[]` | no |
| <a name="input_default_namespace"></a> [default\_namespace](#input\_default\_namespace) | Default namespace for the user | `string` | `null` | no |
| <a name="input_default_role"></a> [default\_role](#input\_default\_role) | Default role for the user | `string` | `"PUBLIC"` | no |
| <a name="input_default_warehouse"></a> [default\_warehouse](#input\_default\_warehouse) | Default warehouse for the user | `string` | `null` | no |
| <a name="input_disabled"></a> [disabled](#input\_disabled) | Whether the user is disabled | `bool` | `false` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the user | `string` | `null` | no |
| <a name="input_email"></a> [email](#input\_email) | Email of the user | `string` | `null` | no |
| <a name="input_first_name"></a> [first\_name](#input\_first\_name) | First name of the user | `string` | `null` | no |
| <a name="input_has_network_policy"></a> [has\_network\_policy](#input\_has\_network\_policy) | Whether to create a network policy for the user | `bool` | `false` | no |
| <a name="input_last_name"></a> [last\_name](#input\_last\_name) | Last name of the user | `string` | `null` | no |
| <a name="input_login_name"></a> [login\_name](#input\_login\_name) | Login name for the user | `string` | `null` | no |
| <a name="input_must_change_password"></a> [must\_change\_password](#input\_must\_change\_password) | Whether the user must change their password upon their next login | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the user | `string` | n/a | yes |
| <a name="input_password_length"></a> [password\_length](#input\_password\_length) | Length of the random password | `number` | `19` | no |
| <a name="input_set_for_account"></a> [set\_for\_account](#input\_set\_for\_account) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rsa_private_key"></a> [rsa\_private\_key](#output\_rsa\_private\_key) | The RSA private key |
| <a name="output_rsa_public_key"></a> [rsa\_public\_key](#output\_rsa\_public\_key) | The first RSA public key |
| <a name="output_rsa_public_key_2"></a> [rsa\_public\_key\_2](#output\_rsa\_public\_key\_2) | The second RSA public key |
| <a name="output_user_name"></a> [user\_name](#output\_user\_name) | The name of the created user |
| <a name="output_user_password"></a> [user\_password](#output\_user\_password) | The password of the created user |
<!-- END_TF_DOCS -->
