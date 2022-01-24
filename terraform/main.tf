terraform {
  required_version = ">= 1.0.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.17"
    }
  }
}

provider "digitalocean" {}

resource "digitalocean_droplet" "telerik-ruby" {
  # Obtain your ssh_key id number via your account. See Document https://developers.digitalocean.com/documentation/v2/#list-all-keys
  ssh_keys           = [digitalocean_ssh_key.ssh-key.fingerprint]
  image              = var.ubuntu
  region             = var.do_fra1
  size               = "s-1vcpu-1gb"
  backups            = false
  ipv6               = true
  name               = "telerik-ruby"
  user_data          = file("cloud-init.yaml")

  connection {
      host     = self.ipv4_address
      type     = "ssh"
      private_key = file("~/.ssh/do-tf")
      user     = "root"
      timeout  = "2m"
    }
}

resource "digitalocean_ssh_key" "ssh-key" {
  name       = "ssh-key"
  public_key = file(var.ssh_key_path)
}
