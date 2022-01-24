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