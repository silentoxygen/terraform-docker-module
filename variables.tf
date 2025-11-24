variable "container_name" {
  description = <<EOT
Name of the Docker container.
EOT
  type        = string
}

variable "image" {
  description = <<EOT
Image to use for the container (e.g. nginx:latest).
EOT
  type        = string
}

variable "internal_port" {
  description = <<EOT
The internal port the container listens on.
EOT
  type        = number
}

variable "external_port" {
  description = <<EOT
The port exposed on the host system.
EOT
  type        = number
}

variable "create_network" {
  description = <<EOT
Whether to create a new Docker network.
If false, you must supply 'network_name'.
EOT
  type        = bool
  default     = true
}

variable "network_name" {
  description = <<EOT
If create_network = true, this is the name of the network to create.
If create_network = false, this must be the name of an existing network.
EOT
  type        = string
  default     = "app_network"
}

variable "keep_image_locally" {
  description = <<EOT
If true, the image is not removed from the local Docker host.
EOT
  type        = bool
  default     = false
}

variable "name" {
  description = <<EOT
The name of the container resource created by this module.
This is passed into docker_container.this.name.
EOT
  type        = string
}

variable "env" {
  description = <<EOT
A set of environment variables to pass into the container.

Each entry must be of the form "KEY=VALUE", for example:

  [
    "PORT=8080",
    "DEBUG=false"
  ]

This is passed directly into docker_container.this.env.
EOT
  type        = set(string)
  default     = []
}

