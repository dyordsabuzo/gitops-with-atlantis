variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-southeast-2"
}

variable "atlantis_repo_allowlist" {
  description = "Comma delimited string containing repos to use atlantis"
  type        = string
  default     = "*"
}
