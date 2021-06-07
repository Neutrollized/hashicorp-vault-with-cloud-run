# README
Based on my Vault setup on my home Raspberry Pi, I know I don't require that much resources, so I've sized the Cloud Run deployment pretty small and it shouldn't have much problems fitting within Google Cloud's [always free](https://cloud.google.com/free/docs/gcp-free-tier/#cloud-run) tier, so you shouldn't have to pay much for this setup (if at all).  Feel free to bump up the resources accordingly.

#### 0 - Building the Image
```
docker build -t gcr.io/${PROJECT_ID}/vault-server:1.7.2 .
docker push gcr.io/${PROJECT_ID}/vault-server:1.7.2
```

#### 1 - Initial Deploy
Deploy privately first so you can authenticate with your GCP account and setup the Vault instance:

```
gcloud beta run deploy vault-server \
  --no-allow-unauthenticated \
  --concurrency 20 \
  --cpu 1 \
  --image gcr.io/${PROJECT_ID}/vault-server:1.7.2 \
  --memory '1G' \
  --min-instances 1 \
  --max-instances 1 \
  --platform managed \
  --port 8200 \
  --service-account ${SERVICE_ACCOUNT_EMAIL} \
  --set-env-vars="GOOGLE_PROJECT=${PROJECT_ID},GOOGLE_STORAGE_BUCKET=${GCS_BUCKET_NAME}" \
  --set-secrets="/etc/vault/config.hcl=vault-server-config:1" \
  --timeout 300 \
  --region ${REGION}
```


### 2 - Connect To & Initialize Vault
You need to give the current logged in GCP user access so that you can initialize the Vault server

```
gcloud run services add-iam-policy-binding vault-server \
  --member="user:${CURRENT_USER_EMAIL}" \
  --role='roles/run.invoker' \
  --platform managed \
  --region ${REGION}
```

- the last line of your Cloud Run deploy output should tell you what your Service URL is, but if you need it again:
```
VAULT_SERVICE_URL=$(gcloud run services describe vault-server \
  --platform managed \
  --region ${REGION} \
  --format 'value(status.url)')
```

- this should tell you that your Vault us up, but is not initialized:
```
curl -s -X GET \
  ${VAULT_SERVICE_URL}/v1/sys/seal-status \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)"
```

- initialize it (update `init.json` settings as it pertains to you)
```
curl -s -X PUT \
  ${VAULT_SERVICE_URL}/v1/sys/init \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  --data @init.json
```

### 3a - Mapping Custom Domains
If you want to map your service to a custom domain (I'm going to use *myvault.example.com* as my example), there are some settings you may want to change.  If you're not, then you can go straight to step 3b below.

Also, beware that there are currently some [limitations](https://cloud.google.com/run/docs/mapping-custom-domains#limitations) to Cloud Run domain mappings.  This is only availabile in certain regions.  For example, I can't deploy it in Montreal (`northamerica-northeast1`), so I'll have to choose a different region like `us-central1` or `us-east1`, etc.

### 3b - Finalize & Make Public
One down side of Cloud Run is that it's meant more for (public) applications and not something that should be more internal/restricted.  You can require authentication to access the service with the `--no-allow-unauthenticated` flag like you did in the first step, but depending on what you actually want to use this Vault for, it might be a lot more hassle than it is worth.

```
gcloud beta run deploy myvault \
  --allow-unauthenticated \
  --concurrency 20 \
  --cpu 1 \
  --image gcr.io/${PROJECT_ID}/vault-server:1.7.2 \
  --memory '1G' \
  --min-instances 1 \
  --max-instances 1 \
  --platform managed \
  --port 8200 \
  --service-account ${SERVICE_ACCOUNT_EMAIL} \
  --set-env-vars="GOOGLE_PROJECT=${PROJECT_ID},GOOGLE_STORAGE_BUCKET=${GCS_BUCKET_NAME}" \
  --set-secrets="/etc/vault/config.hcl=vault-server-config:1" \
  --timeout 300 \
  --region ${REGION}
```

### 3c - Creating Domain Mapping
I'm not 100% sure, but I don't think the service name needs to match your URL subdomain name, but I do it so that it's consistent:
```
gcloud beta run domain-mappings create \
  --service myvault \
  --domain myvault.example.com
  --region ${REGION}
```

Afterwards, you will be prompted to create some DNS entries and once GCP verifies that, it will provision your SSL certs and your custom domain mapping will be up and running.  This part took ~15min or so for me.
