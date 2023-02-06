#-----------------------
# provider variables
#-----------------------
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region to deploy GCP resources"
  type        = string
  default     = "us-central1"
}


#-------------------------
# Artifact Registry
#-------------------------
variable "gar_repo_name" {
  description = "Google Artifact Registry repo name."
  type        = string
  default     = "vault-docker-repository"
}


#-------------------------
# GCS
#-------------------------
variable "bucket_name" {
  description = "Name of GCS bucket that will serve as Vault's backend"
  type        = string
  default     = "vault-backend"
}

variable "storage_class" {
  description = "Storage class, options are: STANDARD, MULTI_REGIONAL, REGIONAL.  There are other options, but you shouldn't be using those for Vault backend."
  type        = string
  default     = "MULTI_REGIONAL"
}

variable "location" {
  description = "Multi-region name, options are: ASIA, EU, US"
  type        = string
  default     = "US"
}

variable "force_destroy" {
  description = "Force destroy the GCS bucket even if it's not empty"
  type        = bool
  default     = true
}


#-------------------------
# Secret Manager
#-------------------------
variable "vault_server_config" {
  description = "Path of Vault server config"
  type        = string
  default     = "./cloud-run/vault-server.hcl"
}


#-------------------------
# Cloud Build
#-------------------------
variable "github_repo_owner" {
  description = "GitHub repo owner name (user or organization)"
  type        = string
}

variable "github_repo_name" {
  description = "GitHub repo name.  Not the full URI."
  type        = string
}

variable "cloudrun_service_name" {}

variable "cloudrun_ingress" {
  description = "Set ingress traffic sourcess allowed to call the service.  Options are: 'all', 'internal', 'internal-and-cloud-load-balancing'"
  type        = string
  default     = "all"
}

variable "cloudrun_region" {
  description = "Region where Cloud Run is deployed.  This may be different from the region due to the some feastures (i.e. custom domains) that are still in beta and not support everywhere yet."
  type        = string
  default     = "us-east4"
}

variable "cloudrun_exec_env" {
  description = "Set execution environment for Cloud Run.  Options are: 'gen1', 'gen2'"
  type        = string
  default     = "gen2"
}

variable "trigger_approval_required" {
  description = "Require approval before build executes"
  type        = bool
  default     = true
}
