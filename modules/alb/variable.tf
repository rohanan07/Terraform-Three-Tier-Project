variable "internal" {
  type = bool
  default = false
}

variable "security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "name_prefix" {
  type = string
  default = ""
}