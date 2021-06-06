output "project_id" {
  value = var.project_id
}

output "cloud_kms_keyring" {
  value = google_kms_key_ring.vault.name
}

output "service_account_email" {
  value = google_service_account.vault_sa.email
}

output "bucket_name" {
  value = google_storage_bucket.vault_backend.name
}
