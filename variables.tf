variable "vpc_cidr_block" {
  type = string
  default = "172.20.0.0/16"
}

variable "public_subnets_cidr" {
  type = list(string)
  default = [ "172.20.0.0/19", "172.20.32.0/19" ]
}

variable "frontend_subnets_cidr" {
  type = list(string)
  default = [ "172.20.64.0/19", "172.20.96.0/19" ]
}

variable "backend_subnets_cidr" {
  type = list(string)
  default = [ "172.20.128.0/19", "172.20.160.0/19" ]
}

variable "db_subnets_cidr" {
  type = list(string)
  default = [ "172.20.192.0/19", "172.20.224.0/19" ]
}

variable "availability_zones" {
  type = list(string)
  default = [ "ap-south-1a", "ap-south-1b" ]
}

variable "ami_id" {
  type = string
  default = "ami-02b8269d5e85954ef"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "key_name" {
  type = string
  default = "login-key"
}

variable "db_name" {
  type = string
  default = "three-tier-project-db"
}

variable "db_password" {
  type = string
  default = "#Wprhr20"
}