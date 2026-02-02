variable "do_fra1" {
  description = "Digital Ocean Frankfurt Data Center 1"
  default     = "fra1"
}

# Default Os

variable "ubuntu" {
  description = "Default LTS"
  default     = "ubuntu-20-04-x64"
}

variable "ssh_key_path" {
  type        = string
  description = "The file path to an ssh public key"
  default     = "~/.ssh/do-tf.pub"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key content for terraform user"
  sensitive   = true
}

variable "newrelic_license_key" {
  type        = string
  description = "New Relic license key for infrastructure monitoring"
  sensitive   = true
  default     = ""
}