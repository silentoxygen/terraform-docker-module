# terraform-docker-container-network

A reusable Terraform module that creates a **Docker container** and **optionally** creates a **Docker network** for it.

You can:

- Let the module **create a network** for the container, or  
- Attach the container to an **existing network** that you manage elsewhere.

This is ideal for local SRE / platform labs, or as a building block in a bigger Docker-based topology.

---

## Features

- Creates a single `docker_container`
- Optionally creates a `docker_network`
- Attaches the container to the network
- Allows you to pass a list of environment variables
- Exposes container and network details as outputs

---

## Usage

### 1. Create a container **and** a network (default)

```hcl
module "web" {
  source = "github.com/your-org/terraform-docker-container-network" # update for your repo

  name          = "frontend"
  image         = "nginx:latest"
  internal_port = 80
  external_port = 8080

  # Optional env vars:
  env = [
    "BACKEND_URL=http://backend:80",
  ]

  # Network options:
  create_network = true
  network_name   = "app_network"
}
