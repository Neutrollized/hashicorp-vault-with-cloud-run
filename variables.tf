#-----------------------
# provider variables
#-----------------------
variable "project_number" {}

variable "project_id" {}

variable "credentials_file_path" {}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}


#-------------------------
# GCS
#-------------------------

variable "bucket_name" {
  description = "Name of GCS bucket that will serve as Vault's backend"
  default     = "vault-backend"
}

variable "storage_class" {
  description = "Storage class, options are: STANDARD, MULTI_REGIONAL, REGIONAL.  There are other options, but you shouldn't be using those for Vault backend."
  default     = "MULTI_REGIONAL"
}

variable "location" {
  description = "Multi-region name, options are: ASIA, EU, US"
  default     = "US"
}

variable "force_destroy" {
  description = "Force destroy the GCS bucket even if it's not empty"
  default     = "true"
}


#-------------------------
# Secret Manager
#-------------------------

variable "vault_server_config" {
  description = "Path of Vault server config"
  default     = "./cloud-run/vault-server.hcl"
}


#-------------------------
# Cloud Build
#-------------------------

variable "github_repo_owner" {
  description = "GitHub repo owner name (user or organization)"
}

variable "github_repo_name" {
  description = "GitHub repo name.  Not the full URI"
}

variable "cloudrun_service_name" {}

variable "cloudrun_region" {
  description = "Region where Cloud Run is deployed.  This may be different from the region due to the some feastures (i.e. custom domains) that are still in beta and not support everywehre yet."
  default     = "us-east4"
}

variable "trigger_approval_required" {
  description = "Require approval before build executes"
  default     = "true"
}
