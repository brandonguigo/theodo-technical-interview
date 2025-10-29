// Outputs for the cloud-sql wrapper module.
// This module delegates to a nested module named "sql-db" which is an
// external module (GoogleCloudPlatform/sql-db). We expose a small set of
// useful outputs and use `try()` to provide safe fallbacks when the nested
// module uses different attribute names.

output "instance_name" {
  description = "Cloud SQL instance name (from nested module)."
  value       = try(module.sql-db.instance_name, module.sql-db.name, null)
}

output "connection_name" {
  description = "Connection name usable by clients in the form project:region:instance."
  value       = try(module.sql-db.connection_name, module.sql-db.connection, null)
}

output "self_link" {
  description = "Self link URL for the Cloud SQL instance."
  value       = try(module.sql-db.self_link, null)
}

output "database_name" {
  description = "Name of the created database inside the instance (if any)."
  value       = try(module.sql-db.db_name, module.sql-db.database_name, module.sql-db.name, null)
}

output "ip_addresses" {
  description = "IP address information (may be empty for private-only instances)."
  value       = try(module.sql-db.ip_addresses, module.sql-db.ip_address, null)
}

