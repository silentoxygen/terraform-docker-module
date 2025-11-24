# 🚀 Terraform Modular Docker Stack (Session 4)

This repository demonstrates how to transform **ad‑hoc Terraform** into **scalable, reusable, production‑grade Terraform systems**.

It builds on the Session 3 multi‑resource Docker stack and introduces:

- 🌱 Root module vs feature modules  
- 🧱 Reusable Docker **network** module  
- 📦 Reusable Docker **container** module  
- 🔌 Clear input/output contracts  
- 🏗️ A scalable structure used by real SRE / Platform Engineering teams  

The stack provisions:

- 🕸️ One Docker **network** (`app_network`)
- ⚙️ One **backend** container  
- 🎨 One **frontend** container  

---

## 🔧 Requirements

| Name      | Version                      |
|-----------|------------------------------|
| terraform | ≥ 1.5.0                      |
| docker    | Local Docker Engine running  |
| provider  | kreuzwerker/docker ≥ 3.0.0   |

---

## 📁 Project Structure

```text
session4-modules/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── provider.tf
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── container/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

# 🌿 Root Module

The **root module** orchestrates the overall environment by combining the network module and two container modules.

---

## 🔢 Root Inputs

All root‑level variables have defaults → **none are required**.

### Optional Inputs

| Name            | Type   | Default                     | Description                          |
|-----------------|--------|-----------------------------|--------------------------------------|
| backend_image   | string | "nginxdemos/hello:latest"   | Image used for backend container     |
| frontend_image  | string | "nginx:latest"              | Image used for frontend container    |

Override via CLI:

```bash
terraform apply -var="backend_image=nginxdemos/hello:plain-text"
```

Or via `terraform.tfvars`:

```hcl
backend_image  = "nginxdemos/hello:plain-text"
frontend_image = "nginx:1.27.0"
```

---

## 📤 Root Outputs

| Name          | Description                            |
|---------------|----------------------------------------|
| frontend_url  | Local URL for the frontend container   |
| backend_url   | Local URL for the backend container    |
| network_name  | Name of the Docker network             |

---

# 🕸️ Module: network

Reusable module that creates a Docker network.

### Example usage

```hcl
module "network" {
  source = "./modules/network"
  name   = "app_network"
}
```

---

## 🔐 Network Inputs

| Name | Type   | Default | Required | Description               |
|------|--------|---------|----------|---------------------------|
| name | string | n/a     | yes      | Name of the Docker network |

---

## 📤 Network Outputs

| Name | Description            |
|------|------------------------|
| id   | ID of the network      |
| name | Name of the network    |

---

# 📦 Module: container

Reusable module responsible for:

- Pulling a Docker image
- Creating a container
- Attaching the container to a network

It is used **twice**: once for backend, once for frontend.

### Example usage

```hcl
module "backend" {
  source        = "./modules/container"
  name          = "backend"
  image         = var.backend_image
  internal_port = 80
  external_port = 9000
  network_name  = module.network.name
}

module "frontend" {
  source        = "./modules/container"
  name          = "frontend"
  image         = var.frontend_image
  internal_port = 80
  external_port = 8080
  network_name  = module.network.name
}
```

---

## 🔐 Container Inputs (all required)

| Name           | Type   | Default | Required | Description                                |
|----------------|--------|---------|----------|--------------------------------------------|
| name           | string | n/a     | yes      | Name of the container                      |
| image          | string | n/a     | yes      | Docker image                               |
| internal_port  | number | n/a     | yes      | Container's internal port                  |
| external_port  | number | n/a     | yes      | Port to expose on host                     |
| network_name   | string | n/a     | yes      | Name of Docker network to attach container |

---

## 📤 Container Outputs

| Name           | Description                        |
|----------------|------------------------------------|
| container_id   | ID of the created container        |
| container_name | Name of the container              |

---

# ▶️ Usage

Initialize and deploy:

```bash
terraform init
terraform plan
terraform apply
```

Check running containers:

```bash
docker ps
```

Test endpoints:

```bash
curl http://localhost:8080   # frontend
curl http://localhost:9000   # backend
```

Test internal DNS:

```bash
docker exec -it frontend ping backend
```

---

# 🎓 Teaching Notes

This repository demonstrates the evolution from a simple multi‑resource Terraform setup into a **modular architecture** suitable for:

- SRE teams  
- Platform engineering  
- Cloud automation  
- Multi‑environment deployment patterns  

Concepts reinforced:

- Root module = orchestration  
- Feature modules = reusable building blocks  
- Inputs/outputs = clean contracts  
- Modules encourage consistency, safety, and scalability  

This is the natural upgrade path from Session 3 → Session 4.

---

# 📘 End of README
