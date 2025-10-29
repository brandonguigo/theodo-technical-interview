module "test_psa" {
  count   = var.vpc_network != null && var.ip_address != null ? 1 : 0
  source  = "terraform-google-modules/sql-db/google//modules/private_service_access"
  version = "~> 26.0"

  project_id  = var.project
  vpc_network = var.vpc_network
  address     = var.ip_address
}
