data "google_project" "project" {
  project_id = var.project_id
}

resource "random_id" "name_suffix" {
  byte_length = 4
}


#---------------------------
# Artifact Registry
#---------------------------
resource "google_artifact_registry_repository" "vault_gar" {
  location      = var.region
  repository_id = var.gar_repo_name
  description   = "Docker GAR - Terraform managed"
  format        = "DOCKER"
}


#--------------------
# GCS
#--------------------
resource "google_storage_bucket" "vault_backend" {
  name          = "${var.bucket_name}-${random_id.name_suffix.hex}"
  storage_class = var.storage_class
  location      = var.location

  force_destroy = var.force_destroy
}


#--------------------
# Cloud KMS
#--------------------
resource "google_kms_key_ring" "vault" {
  name     = "vault-server-${random_id.name_suffix.hex}"
  location = "global"
}

resource "google_kms_crypto_key" "auto_unseal" {
  name     = "auto_unseal"
  key_ring = google_kms_key_ring.vault.id
  purpose  = "ENCRYPT_DECRYPT"
}


#---------------------------
# Secret Manager
#---------------------------
resource "google_secret_manager_secret" "vault_secret" {
  secret_id = "vault-server-config"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "vault_server_config" {
  secret      = google_secret_manager_secret.vault_secret.id
  secret_data = file(var.vault_server_config)
}


#---------------------------
# Cloud Build
#---------------------------
resource "google_cloudbuild_trigger" "docker_build_trigger" {
  name        = "hashicorp-vault-cloudrun-build-and-deploy"
  description = "Docker Build and Deploy - Terraform managed"

  filename = "cloudbuild.yaml"

  github {
    owner = var.github_repo_owner
    name  = var.github_repo_name
    push {
      branch = "^(main|master)$"
    }
  }

  substitutions = {
    _GAR_REGION            = var.region
    _GAR_REPO_NAME         = var.gar_repo_name
    _GCS_BUCKET_NAME       = google_storage_bucket.vault_backend.name
    _KMS_KEY_RING          = google_kms_key_ring.vault.name
    _REGION                = var.cloudrun_region
    _SERVICE_ACCOUNT_EMAIL = google_service_account.vault_sa.email
    _SERVICE_NAME          = var.cloudrun_service_name
    _INGRESS               = var.cloudrun_ingress
    _EXECUTION_ENVIRONMENT = var.cloudrun_exec_env
  }

  approval_config {
    approval_required = var.trigger_approval_required
  }
}
