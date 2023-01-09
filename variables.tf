variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-southeast-2"
}

variable "atlantis_url" {
  description = "Atlantis URL endpoint"
  type        = string
}

variable "atlantis_write_git_creds" {
  description = "Flag to indicate if git creds will be written in atlantis"
  type        = bool
}

variable "atlantis_repo_allowlist" {
  description = "Comma delimited string containing repos to use atlantis"
  type        = string
}
