// High-availability, production-like example. Use this as a template for
// scalable HA instances. Replace secrets and project values with secure
// references (Secret Manager) in production.
module "db_ha" {
  source = "./modules/cloud-sql"

  project          = "my-gcp-project" // replace with your project
  region           = "europe-west1"
  instance_name    = "prod-db-ha"
  database_version = "POSTGRES_15"

  # Higher tier for production workload
  tier              = "db-n1-standard-4"
  availability_type = "REGIONAL" # enables high-availability across zones
  disk_size_gb      = 200
  disk_type         = "PD_SSD"
  activation_policy = "ALWAYS"

  # Rich backup configuration using the `backup_config` object shape.
  # Use the provided fields to control PITR and retention.
  backup_config = {
    enabled                        = true
    start_time                     = "03:00" // nightly backup start time (UTC)
    location                       = "europe-west1"
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = "7"
    retained_backups               = 30
    retention_unit                 = "DAYS"
  }

  # Protect against accidental deletion in prod
  deletion_protection = true

  # Enable private service access for the Cloud SQL instance
  vpc_network = google_compute_network.default.name
  ip_address  = "10.220.0.0"

  database_name = "app_prod"

  labels = {
    env     = "prod"
    team    = "platform"
    project = "theodo"
  }
}

