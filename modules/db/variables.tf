variable "subnet_ids" {
  type = list(string)
}

variable "engine_version" {
  type = string
  default = "15.5"
}

variable "instance_class" {
  type = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type = number
  default = 20
}

variable "db_name" {
  type = string
  default = "goaldb"
}

variable "db_username" {
  type = string
  default = "postgres"
}

variable "db_password" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "multi_az" {
  type = bool
  default = false
}

variable "availability_zone" {
  type = string
  default = null
}

variable "backup_retention_period" {
  type = number
  default = 7
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
}

variable "deletion_protection" {
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  type        = number
  default     = 0
}