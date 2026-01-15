variable "secrets_arns" {
  description = "List of Secrets Manager ARNs that EC2 instances can access"
  type        = list(string)
  default     = ["*"]
}