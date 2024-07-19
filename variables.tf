variable "name" {
  description = "Name of the user"
  type        = string
}

variable "password_length" {
  description = "Length of the random password"
  type        = number
  default     = 19
}

variable "default_role" {
  description = "Default role for the user"
  type        = string
  default     = "PUBLIC"
}

variable "default_warehouse" {
  description = "Default warehouse for the user"
  type        = string
  default     = null
}

variable "disabled" {
  description = "Whether the user is disabled"
  type        = bool
  default     = false
}

variable "default_namespace" {
  description = "Default namespace for the user"
  type        = string
  default     = null
}

variable "login_name" {
  description = "Login name for the user"
  type        = string
  default     = null
}

variable "display_name" {
  description = "Display name for the user"
  type        = string
  default     = null
}

variable "first_name" {
  description = "First name of the user"
  type        = string
  default     = null
}

variable "last_name" {
  description = "Last name of the user"
  type        = string
  default     = null
}

variable "email" {
  description = "Email of the user"
  type        = string
  default     = null
}

variable "must_change_password" {
  description = "Whether the user must change their password upon their next login"
  type        = bool
  default     = false
}

variable "has_network_policy" {
  description = "Whether to create a network policy for the user"
  type        = bool
  default     = false
}

variable "set_for_account" {
  type    = bool
  default = false
}

variable "blocked_ip_list" {
  type    = list(string)
  default = []
}

variable "allowed_ip_list" {
  type    = list(string)
  default = []
}
