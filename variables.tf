#-----------------------
# provider variables
#-----------------------
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


#-------------------------
# Secret Manager
#-------------------------

variable "vault_server_config" {
  description = "Path of Vault server config"
  default     = "./cloud-run/vault-server.hcl"
}
