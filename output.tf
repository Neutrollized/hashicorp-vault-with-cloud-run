output "artifact_registry_id" {
  value       = google_artifact_registry_repository.vault_gar.id
  description = "Docker repository, Google Artifact Registry ID"
}

output "bucket_name" {
  value       = google_storage_bucket.vault_backend.name
  description = "Name of the GCS bucket used as Vault backend"
}

output "cloud_kms_keyring" {
  value       = google_kms_key_ring.vault.name
  description = "Cloud KMS key ring"
}

output "service_account_email" {
  value       = google_service_account.vault_sa.email
  description = "GCP service account used for Cloud Run service"
}

