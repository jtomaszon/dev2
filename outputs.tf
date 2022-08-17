output "bastion_eip" {
    value = aws_eip.bastion.public_ip
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = try(module.aurora.cluster_endpoint, "")
}

output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = try(module.aurora.cluster_reader_endpoint, "")
}

output "cluster_master_username" {
  description = "The database master username"
  value       = try(module.aurora.cluster_master_username, "")
  sensitive   = true
}

output "cluster_master_password" {
  description = "The database master password"
  value       = random_password.master.result
  sensitive   = true
}