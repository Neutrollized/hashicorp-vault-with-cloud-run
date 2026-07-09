# AppRole Example

## Setup

- enable KV2 Secrets Store:
```
vault secrets enable --path=mykv2 --version=2 kv
```

- add KV secret:
```
vault kv put mykv2/sandbox/mysecret username=admin password=s00p3rS3cr3t!
```

- configure access policy:
```
vault policy write my-access ./my-access-policy.hcl
```

- enable AppRole
```
vault auth enable approle
```

```
vault write auth/approle/role/agent-role token_policies=my-access
```

### Test Auth
- get role-id (username):
```
vault read -field=role_id auth/approle/role/agent-role/role-id
```

- get secret-id (password):
```
vault write -force -field=secret_id auth/approle/role/agent-role/secret-id
```

- test auth:
```
curl --request POST \
  --data '{"role_id":"ROLE_ID","secret_id":"SECRET_ID"}' \
  VAULT_ADDR/v1/auth/approle/login
```


## Demo
- create `approle/role_id.txt` and `approle/secret_id.txt` with the respective secrets
- create `config/agent.hcl` (copy from sample and add in your *VAULT_ADDR*)
```
podman compose up -d
```

- exec into vault-agent and verify contents of `/vault/secrets`:
```
podman exec -it vault-agent sh
```
