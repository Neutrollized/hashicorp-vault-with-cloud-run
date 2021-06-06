resource "random_id" "name_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "vault_backend" {
  name          = "${var.bucket_name}-${random_id.name_suffix.hex}"
  storage_class = var.storage_class
  location      = var.location
}


#--------------------
# Cloud KMS
#--------------------

resource "google_kms_key_ring" "vault" {
  #name     = "vault-server"
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
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "vault_server_config" {
  secret      = google_secret_manager_secret.vault_secret.id
  secret_data = file(var.vault_server_config)
}
