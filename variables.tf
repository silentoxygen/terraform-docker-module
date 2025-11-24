variable "name" {
  description = "Name of the Docker container"
  type        = string
}

variable "image" {
  description = "Docker image to run (e.g. nginx:latest)"
  type        = string
}

variable "internal_port" {
  description = "Port inside the container that the app listens on"
  type        = number
}

variable "external_port" {
  description = "Port on the host to map to the internal port"
  type        = number
}

variable "env" {
  description = "Optional list of environment variables in KEY=VALUE form"
  type        = list(string)
  default     = []
}

variable "create_network" {
  description = "Whether this module should create a Docker network"
  type        = bool
  default     = true
}

variable "network_name" {
  description = <<EOT
Name of the Docker network.

If create_network = true, this is the name of the network to create.
If create_network = false, this must be the name of an existing network.
EOT
  type    = string
  default = "app_network"
}

variable "keep_image_locally" {
  description = "Whether Docker should keep the image locally when the container is destroyed"
  type        = bool
  default     = false
}
