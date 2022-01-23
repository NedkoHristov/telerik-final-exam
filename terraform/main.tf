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
  image     = "ubuntu-18-04-x64"
  name      = "telerik-ruby"
  region    = "fra1"
  size      = "s-1vcpu-1gb"
  user_data = file("cloud-init.yaml")
}
