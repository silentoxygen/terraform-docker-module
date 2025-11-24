terraform {
  required_version = ">= 1.5.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.0"
    }
  }
}

########################################
# Optional network
########################################

resource "docker_network" "this" {
  count = var.create_network ? 1 : 0

  name = var.network_name
}

########################################
# Container image
########################################

resource "docker_image" "this" {
  name         = var.image
  keep_locally = var.keep_image_locally
}

########################################
# Container
########################################

locals {
  effective_network_name = var.create_network ? docker_network.this[0].name : var.network_name
}

resource "docker_container" "this" {
  name  = var.name
  image = docker_image.this.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  env = var.env

  networks_advanced {
    name = local.effective_network_name
  }
}
