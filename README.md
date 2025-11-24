## Terraform Docker Module

This Terraform module creates a Docker image, a Docker container, and (optionally) a Docker network using the kreuzwerker/docker provider.

It is intended for simple local deployments or CI runners where you want Terraform to manage a container lifecycle.

Key features
- create (or attach to) a Docker network
- pull and manage a container image
- create a container with port mapping and environment variables

## Contract
- Inputs: container configuration (name, image, ports, env, network settings).
- Outputs: container id/name and network information.
- Error modes: fails if Docker daemon is unavailable, or if an existing network is referenced but missing when `create_network = false`.

## Requirements
- Terraform >= 1.5.0
- Provider: `kreuzwerker/docker` >= 3.0.0
- Access to a Docker daemon (local socket or remote daemon) from where you run Terraform.

The module's provider requirement is declared in the module, but you must configure the provider block in your root module (example below).

## Inputs

Required inputs
- `name` (string) — Name of the Docker container.
- `image` (string) — Docker image to run (for example `nginx:latest`).
- `internal_port` (number) — Port inside the container that the app listens on.
- `external_port` (number) — Port on the host to map to the internal port.

Optional inputs (with defaults)
- `env` (list(string), default = []) — Optional list of environment variables in `KEY=VALUE` form.
- `create_network` (bool, default = true) — Whether this module should create a Docker network. If `false`, the module will attach the container to the network named by `network_name` and will not create a network resource.
- `network_name` (string, default = "app_network") — Name of the Docker network. If `create_network = true` this is the name that will be created; if `create_network = false` this must be the name of an existing network.
- `keep_image_locally` (bool, default = false) — Whether Docker should keep the pulled image locally when the container is destroyed.

Notes on required vs optional
- The module requires `name`, `image`, `internal_port`, and `external_port` because they have no defaults. All other inputs are optional with sensible defaults.

## Outputs
- `container_id` — ID of the created container.
- `container_name` — Name of the created container.
- `network_name` — Name of the network the container is attached to (either the created network or the provided `network_name`).
- `network_id` — ID of the network created by this module, or `null` when using an existing network (`create_network = false`).

## Example usage

Basic example (create network + container)

```hcl
provider "docker" {
  # Example: local socket
  host = "unix:///var/run/docker.sock"
  # Or for remote daemon:
  # host = "tcp://192.0.2.10:2376"
}

module "web" {
  source        = "../../module-local/modules/docker-module"
  name          = "my-web"
  image         = "nginx:latest"
  internal_port = 80
  external_port = 8080
  env           = ["ENV=production", "LOG_LEVEL=info"]
  # create_network defaults to true; network_name defaults to "app_network"
}
```

Example: attach to an existing network

```hcl
module "worker" {
  source        = "../../module-local/modules/docker-module"
  name          = "worker-1"
  image         = "alpine:latest"
  internal_port = 8080
  external_port = 18080
  create_network = false
  network_name   = "preexisting_network"
}
```

## Edge cases & notes
- If `create_network = false` and `network_name` does not exist, the `docker_container` resource will fail to attach; create the network manually or set `create_network = true`.
- `network_id` output will be `null` when `create_network = false` (module didn't create a network resource).
- If the Docker daemon is unreachable or the configured `host` is incorrect, `terraform plan/apply` will fail.
- `keep_image_locally = true` prevents Terraform's docker provider from removing the image when the container is destroyed; useful for caching images in CI.

## Testing / Quick start
1. Initialize Terraform in your root module directory:

```bash
terraform init
```

2. Apply the example configuration (review plan first):

```bash
terraform plan
terraform apply
```

3. Destroy when done:

```bash
terraform destroy
```

## Troubleshooting
- Permission errors talking to the Docker socket are usually solved by running with a user that can access `/var/run/docker.sock`, or by configuring a remote Docker daemon and proper TLS credentials.
- Provider version mismatches: the module declares `kreuzwerker/docker` >= 3.0.0; if you have a global lockfile or other provider constraints, ensure compatibility.

## Acknowledgements
This module is a lightweight wrapper around the `kreuzwerker/docker` provider to make simple container lifecycles reproducible from Terraform.

If you want additional features (volumes, healthchecks, complex networking, multiple containers), open an issue or extend the module by adding variables and resources.
