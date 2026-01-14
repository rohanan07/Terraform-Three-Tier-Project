variable "vpc_cidr_block" {
  type = string
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "frontend_subnets_cidr" {
  type = list(string)
}

variable "backend_subnets_cidr" {
  type = list(string)
}

variable "db_subnets_cidr" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}