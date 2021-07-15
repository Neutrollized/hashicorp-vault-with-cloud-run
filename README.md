# Free-tier Vault with Cloud Run

[Storage Bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)

[Secret Manager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)

[Cloud KMS](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring)

Based on Kelsey Hightower's [Server Vault with Cloud Run](https://github.com/kelseyhightower/serverless-vault-with-cloud-run) repo, this TF blueprint will set up your GCS, Secrets Manager, Cloud KMS (for auto-unseal), but the actual Cloud Run deploy is something you will have to do manually either in the console or via `gcloud`.  

**DISCLAIMER**: This setup is more for a dev/test setup rather than prod as it will be publicly accessible as Cloud Run is mean to run container images that runs an HTTP server and unfortunately you can't apply any firewall rules to it unless you set up an external HTTP(S) balncer with serverless NEGs backends, etc.  If you are trying to setup a production Vault, this is probably not the best way to go about it.  Also, if you're going to use Vault for prod, please build something a bit more "proper" and following the [production hardening](https://learn.hashicorp.com/tutorials/vault/production-hardening) guide.

### Enable Required APIs
You can do this via console or... 
```
gcloud services enable --async \
  containerregistry.googleapis.com \
  run.googleapis.com \
  storage.googleapis.com \
  secretmanager.googleapis.com \
  cloudkms.googleapis.com
```

### Example `terraform.tfvars`
```
project_id            = "my-project"
credentials_file_path = "/path/to/my/credentials.json"
region                = "northamerica-northeast1"
zone                  = "northamerica-northeast1-c"
```

# **IMPORTANT!** PLEASE READ
I had set up my Secret Manager using TF, including the secret, which ingest the [*cloud-run/vault-server.hcl*](./cloud-run/vault-server.hcl), however you will notice that I append the random hex unique identifier at the end of the Cloud KMS keyring, which needs to be referenced, which means I had to update the *cloud-run/vault-server.hcl* and re-run `terraform apply`, so now when I reference the secret version in my Cloud Run deploy command, I had to make sure I refer to version 2 (or *latest*) of the secret.  It's a little awkward and I didn't realize it until afterwards, so since I already made my bed, now I have to lie in it.

There are a couple of ways to avoid this:
1. don't add a unique hex as a suffix to the Cloud KMS name and this way you'll know what the keyring will be called

or...

2. comment out the Secret Manager section and deploy the secret via `gcloud` command:
```
gcloud secrets create vault-server-config \
  --replication-policy automatic \
  --data-file ./cloud-run/vault-server.hcl
```
