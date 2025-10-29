# Cloud SQL module

This module provides a minimal, reusable Cloud SQL instance and optional database.

## Usage

```hcl
module "db" {
  source         = "./modules/cloud-sql"
  project        = "my-gcp-project"
  region         = "us-central1"
  instance_name  = "example-db"
  database_name  = "app_db" # optional
  database_version = "POSTGRES_14"
  tier           = "db-f1-micro"
}
```

## Inputs
- `project` (string) - GCP project id (required)
- `instance_name` (string) - instance name (required)
- `region` (string) - region, default `us-central1`
- `database_version` (string) - default `POSTGRES_14`
- other variables in `variables.tf` have sensible defaults.

## Outputs
- `instance_name`
- `connection_name`
- `self_link`
- `database_name` (if created)

## Notes
- This is a template. Review security best practices before using in production (private IP, IAM, secrets management, backups, maintenance windows, etc.).

## Module behavior and implementation details

- This module is a lightweight wrapper that internally instantiates the
  external module `GoogleCloudPlatform/sql-db/google//modules/postgresql` as
  `module "sql-db"` (see `main.tf`). The wrapper passes the inputs through
  to the nested module. Because the nested module may expose attributes under
  different names, the outputs in `outputs.tf` use `try()` fallbacks where
  appropriate.

## Detailed outputs

- `instance_name` (string) — the Cloud SQL instance name as reported by the
  nested module.

- `connection_name` (string) — the instance connection name (project:region:instance)
  which is typically used by client libraries.

- `self_link` (string) — the GCP self link for the created instance.

- `database_name` (string|null) — the created database name inside the instance,
  if `database_name` was provided and the nested module created it; otherwise null.

- `ip_addresses` (object|null) — IP address objects for the instance (may be
  null for private-only instances or if the nested module uses different naming).
  
- `users` (list(object)) - list of username / pwd combo to use to access the database.

## Examples and notes about referencing outputs

- Basic usage (from root module):

```hcl
module "db" {
  source        = "./modules/cloud-sql"
  project       = var.project
  instance_name = "example-db"
}

output "db_connection_name" {
  value = module.db.connection_name
}
```

- Note: because the wrapper uses a nested module named `sql-db` (with a
  hyphen), internal references to the nested module in code use the
  bracket-syntax: `module["sql-db"]`. Consumers of this wrapper do not need
  to use that bracket syntax — they reference outputs via `module.<your_name>.<output>`.

## Security and production notes

- Prefer managing credentials with Secrets Manager and creating SQL Users via
  dedicated resources rather than passing root passwords directly.
- Consider enabling private IP, restricting authorized networks, setting
  maintenance windows, and configuring automated backups for production.

