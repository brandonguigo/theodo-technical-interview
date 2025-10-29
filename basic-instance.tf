// Minimal example for quick PoC / development use.
// Replace `project` and any sensitive values with your own values or
// use variables/terraform.tfvars in your root module.

resource "google_compute_network" "default" {
  name    = "test-network"
  project = "my-gcp-project"
}

module "db_poc" {
  source = "./modules/cloud-sql"

  project          = "my-gcp-project" // replace with your project
  region           = "us-central1"
  instance_name    = "poc-db"
  database_version = "POSTGRES_14"

  vpc_network = google_compute_network.default.name
  ip_address  = "10.220.0.0"

  # Small tier suitable for PoC (low cost)
  tier              = "db-f1-micro"
  availability_type = "ZONAL"
  disk_size_gb      = 10
  disk_type         = "PD_SSD"
  activation_policy = "ALWAYS"

  # Keep backups off for PoC to save cost (or set to true to enable)
  backup_enabled = false

  deletion_protection = false

  # Optional: create a default DB inside the instance
  database_name = "poc_db"

  labels = {
    env   = "poc"
    owner = "dev-team"
  }
}

