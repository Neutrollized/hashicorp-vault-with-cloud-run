resource "google_service_account" "vault_sa" {
  account_id   = "vault-server-sa"
  display_name = "HashiCorp Vault service account"
}

resource "google_storage_bucket_iam_binding" "bucket_iam_binding" {
  bucket = google_storage_bucket.vault_backend.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.vault_sa.email}",
  ]
}

resource "google_secret_manager_secret_iam_binding" "secret_iam_binding" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.vault_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.vault_sa.email}",
  ]
}

# https://developer.hashicorp.com/vault/docs/configuration/seal/gcpckms#authentication-permissions
# this provides the cloudkms.cryptoKeyVersions.useToEncrypt and .useToDecrypt perms
resource "google_kms_crypto_key_iam_binding" "auto_unseal_iam_binding_encdec" {
  crypto_key_id = google_kms_crypto_key.auto_unseal.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:${google_service_account.vault_sa.email}",
  ]
}

# this provides the cloudkms.cryptoKeys.get perm
resource "google_kms_crypto_key_iam_binding" "auto_unseal_iam_binding_viewer" {
  crypto_key_id = google_kms_crypto_key.auto_unseal.id
  role          = "roles/cloudkms.viewer"
  members = [
    "serviceAccount:${google_service_account.vault_sa.email}",
  ]
}


#-------------------------------
# Cloud Build service account
#-------------------------------
resource "google_project_iam_member" "iam_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "iam_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
