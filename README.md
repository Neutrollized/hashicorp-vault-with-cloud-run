# Free-tier Vault with Cloud Run

[Storage Bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)

[Secret Manager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)

[Cloud KMS](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring)

[Cloud Build](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger)

Based on Kelsey Hightower's [Serverless Vault with Cloud Run](https://github.com/kelseyhightower/serverless-vault-with-cloud-run) repo, this TF blueprint will set up your GCS, Secrets Manager, Cloud KMS (for auto-unseal) and a Cloud Build trigger that will build and deploy Vault onto Cloud Run.  

**DISCLAIMER**: This setup is more for a dev/test setup rather than prod as it will be publicly accessible as Cloud Run is mean to run container images that runs an HTTP server and unfortunately you can't apply any firewall rules to it unless you set up an external HTTP(S) balncer with serverless NEGs backends, etc.  If you are trying to setup a production Vault, this is probably not the best way to go about it.  Also, if you're going to use Vault for prod, please build something a bit more "proper" and following the [production hardening](https://learn.hashicorp.com/tutorials/vault/production-hardening) guide.

## How to Use
#### 0 - Enable Required APIs
You can do this via console or... 
```
gcloud services enable --async \
  containerregistry.googleapis.com \
  run.googleapis.com \
  storage.googleapis.com \
  secretmanager.googleapis.com \
  cloudkms.googleapis.com \
  cloudbuild.googleapis.com
```

#### 1 - Fork this Repo

#### 2 - Connect Repository
Unless you're using [Cloud Source Repository](https://cloud.google.com/source-repositories/docs) to host your code, you will have to first [connect your GitHub repository](https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github) to GCP Cloud Build otherwise you may get an error similar to the following:
```
Error 400: Repository mapping does not exist. Please visit https://console.cloud.google.com/cloud-build/triggers/connect?project=01234567890 to connect a repository to your project
```

#### 2 - Plan & Apply Terraform code
Before you do so, please look over the variables and create your `terraform.tfvars` (you can base it on the [template](./terraform.tfvars.template) I provided).
```
terraform plan -out=myvault.plan
terraform apply myvault.plan
```

Once the deploy is done, you can commit and push the changes which should trigger the Cloud Build trigger that was just created, build your image, and deploy the Cloud Run Vault app (from my experience, this took < 2min).


#### 3 - Initialize Vault
Obtain the Cloud Run deployment URL and initialize Vault

```
VAULT_SERVICE_URL=$(gcloud run services describe myvault \
  --platform managed \
  --region ${REGION} \
  --format 'value(status.url)')
```

```
curl -s -X PUT ${VAULT_SERVICE_URL}/v1/sys/init --data @cloud-run/init.json
```


#### 4 - Create Domain Mapping (optional)
I'm not 100% sure, but I don't think the service name needs to match your URL subdomain name, but I do it so that it's consistent:
```
gcloud beta run domain-mappings create \
  --service myvault \
  --domain myvault.example.com
  --region ${REGION}
```

Afterwards, you will be prompted to create some DNS entries and once GCP verifies that, it will provision your SSL certs and your custom domain mapping will be up and running.  This part took ~15min or so for me.


## RECOMMENDED
Enable [File Audit Device](https://www.vaultproject.io/docs/audit/file#file-audit-device) and write file to `stdout` instead.  This way, logs will go to GCP's [Cloud Logging](https://cloud.google.com/logging):
```
vault audit enable file file_path=stdout
```


## Cloud Build Troubleshooting
Ensure Cloud Build Service Account `[PROJECT_NUMBER]@cloudbuild.gserviceaccount.com` needs to have the following additional roles:
- Cloud Run Admin
- Service Account User
