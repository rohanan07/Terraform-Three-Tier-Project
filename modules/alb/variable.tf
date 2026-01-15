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

variable "target_group_port" {
  type = number
  default = 3000
}

variable "vpc_id" {
  type = string
}