
locals {
  additional_users = [for userid in var.additional_users : {
    name            = userid
    random_password = true
  }]
}

resource "random_password" "root_password" {
  length           = 32
  special          = true
  override_special = "_%@!#"
}

module "sql-db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 22.0"

  project_id        = var.project
  region            = var.region
  name              = var.instance_name
  database_version  = var.database_version
  tier              = var.tier
  availability_type = var.availability_type
  disk_size         = var.disk_size_gb
  disk_type         = var.disk_type
  activation_policy = var.activation_policy
  # Build the backup configuration to pass to the nested module. If
  # `var.backup_config` is empty (default) we pass the legacy shape, otherwise
  # we pass `var.backup_config` directly. This expression creates the final
  # value under the attribute name expected by the nested module.
  backup_configuration = (var.backup_config == {} ? { enabled = var.backup_enabled } : var.backup_config)
  root_password        = random_password.root_password.result
  deletion_protection  = var.deletion_protection
  db_name              = var.database_name
  user_labels          = var.labels
  additional_users     = local.additional_users
}



