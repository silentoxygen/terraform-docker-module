output "container_id" {
  description = "ID of the created container"
  value       = docker_container.this.id
}

output "container_name" {
  description = "Name of the created container"
  value       = docker_container.this.name
}

output "network_name" {
  description = "Name of the network the container is attached to"
  value       = local.effective_network_name
}

output "network_id" {
  description = "ID of the network created by this module (null if using an existing network)"
  value       = var.create_network ? docker_network.this[0].id : null
}
