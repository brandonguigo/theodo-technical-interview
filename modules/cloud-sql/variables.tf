// Variables for the cloud-sql module

variable "project" {
  description = "GCP project id where the Cloud SQL instance will be created"
  type        = string
}

variable "region" {
  description = "GCP region for the Cloud SQL instance"
  type        = string
  default     = "us-central1"
}

variable "instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "Cloud SQL database version (e.g. POSTGRES_14, MYSQL_8_0)"
  type        = string
  default     = "POSTGRES_14"
}

variable "tier" {
  description = "Machine type / tier for the instance (e.g. db-f1-micro, db-n1-standard-1)"
  type        = string
  default     = "db-f1-micro"
}

variable "availability_type" {
  description = "Availability type: ZONAL or REGIONAL"
  type        = string
  default     = "ZONAL"
}

variable "disk_size_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Disk type, e.g. PD_SSD or PD_HDD"
  type        = string
  default     = "PD_SSD"
}

variable "activation_policy" {
  description = "Activation policy for the instance (ALWAYS, NEVER, ON_DEMAND)"
  type        = string
  default     = "ALWAYS"
}

variable "backup_enabled" {
  description = "Enable automated backups"
  type        = bool
  default     = false
}

// Optional complex backup configuration. Use this to pass a rich backup
// configuration object to the nested module. The structure supports optional
// attributes with sensible defaults using the `optional()` type modifier.
variable "backup_config" {
  description = "Backup configuration block to pass to the nested module."
  type = object({
    enabled                        = optional(bool, false)
    start_time                     = optional(string)
    location                       = optional(string)
    point_in_time_recovery_enabled = optional(bool, false)
    transaction_log_retention_days = optional(string)
    retained_backups               = optional(number)
    retention_unit                 = optional(string)
  })
  // Default to an empty object -> wrapper will fall back to `backup_enabled`
  default = {}
}

variable "deletion_protection" {
  description = "Prevent instance deletion when true"
  type        = bool
  default     = true
}

variable "additional_users" {
  type        = list(string)
  description = "Optional list of users to add to the database."
  default     = []
}

variable "database_name" {
  description = "Optional database to create inside the instance"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels to apply to the Cloud SQL instance"
  type        = map(string)
  default     = {}
}

variable "vpc_network" {
  description = "Optional VPC network self-link to use for private IP configuration"
  type        = string
  default     = null
}

variable "ip_address" {
  description = "Optional static IP address resource to use for private IP configuration"
  type        = string
  default     = null
}
