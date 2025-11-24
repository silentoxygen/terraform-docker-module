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
