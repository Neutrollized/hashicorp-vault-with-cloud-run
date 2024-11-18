# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [0.10.0] - 2024-11-18
### Added
- `options.defaultLogsBucketBehavior` to [store build logs in user-owned, regionalized bucket](https://cloud.google.com/build/docs/securing-builds/store-manage-build-logs)
### Changed
- Updated Vault version from `1.17.6` to `1.18.1`
- Using Compute Engine default service account as Cloud Build service account as per [changes](https://cloud.google.com/build/docs/cloud-build-service-account-updates)
- Updated IAM to include new roles required for logging and building using new service account
- Updated **google** and **google-beta** providers from `~> 4.0` to `~> 6.0`
### Fixed
- The `env` field within the Cloud Run deploy step was not being honored, and hence environment variables that are to be passed to the container will be done via `--set-env-vars` instead (part of `gcloud run deploy` option)

## [0.9.4] - 2024-09-26
### Changed
- Updated Vault version from `1.17.0` to `1.17.6`

## [0.9.3] - 2024-06-12
### Changed
- Updated Vault version from `1.16.1` to `1.17.0`

## [0.9.2] - 2024-04-06
### Added
- [Custom input validation rules](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules)
- Added `description` to output values
### Changed
- Changed how environment variables are passed in `cloudbuild.yaml`'s deploy step
- Updated Vault version from `1.15.6` to `1.16.1`

## [0.9.1] - 2024-03-14
### Changed
- `google_secret_manager_secret`'s replication argument, `automatic` is being deprecated for `auto` instead
- Updated Vault version from `1.15.5` to `1.15.6`

## [0.9.0] - 2024-02-05
### Changed
- Added `--cpu-boost` for [faster cold starts](https://cloud.google.com/blog/products/serverless/announcing-startup-cpu-boost-for-cloud-run--cloud-functions)
- Updated Vault version from `1.14.7` to `1.15.5`

## [0.8.3] - 2023-12-01
### Changed
- Updated Vault version from `1.14.3` to `1.14.7`

## [0.8.2] - 2023-09-13
### Changed
- Updated Vault version from `1.13.2` to `1.14.3`

## [0.8.1] - 2023-05-19
### Changed
- Updated `cloudbuild.yaml`, but left Binary Authorization commented out (see Known Issues section in README for more details)
- Updated Vault version from `1.13.1` to `1.13.2`

## [0.8.0] - 2023-03-31
### Fixed
- Updated `cloud-run/init.json` to remove `secret_shares` and `secret_threshold` as part of [GH-16379](https://github.com/hashicorp/vault/pull/16379) applied to v1.12.0
### Changed
- Updated Vault version from `1.12.3` to `1.13.1`

## [0.7.0] - 2023-02-06
### Added
- Running on Cloud Run [Gen2 execution environment](https://cloud.google.com/run/docs/about-execution-environments) specified by new variable, `cloudrun_exec_env` (default: `gen2`) 
### Changed
- Updated Vault version from `1.12.2` to `1.12.3`

## [0.6.0] - 2023-01-04
### Added
- Image efficiency scan using [`dive`](https://github.com/wagoodman/dive) as a pipeline step (will exit with exit code 1 if any of the 3 rules produce a FAIL status)
- [.dive-ci](./dive-ci) rules file used by `dive --ci`
### Changed
- Memory size units changed from `M` to `Mi`

## [0.5.0] - 2012-12-12
### Added
- Image security scan using [`trivy`](https://aquasecurity.github.io/trivy/) as a pipeline step (will exit with exit code 1 if HIGH or CRITICAL vulnerability detected)
### Changed
- Updated Vault version from `1.12.1` to `1.12.2`

## [0.4.0] - 2022-11-29
### Added
- Google Artifact Registry 
- Variable descriptions & type constraints
### Removed
- Removed hardcoded dependency on use of credentials file.  Users should now provide this via [environment variables](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#full-reference)

## [0.3.0] - 2022-11-07
### Added
- Added [hadolint](https://github.com/hadolint/hadolint) to lint the Dockerfile prior to the build step
### Changed
- Updated Vault version from `1.11.4` to `1.12.1`
### Fixed
- Added `roles/cloudkms.viewer` to provide the `cloudkms.cryptoKeys.get` permission. Cloud Run deploys of Vault v1.12.0+ without this permission will fail

## [0.2.3] - 2022-10-03
### Changed
- Updated Vault version from `1.11.3` to `1.11.4`
### Fixed
- Added `--allow-unauthenticated` back into [cloudbuild.yaml](./cloudbuild.yaml) (I misread the docs and got confused -- it's diffferent from Ingress, my bad!)

## [0.2.2] - 2022-09-29
### Changed
- Replaced `--allow-unauthenticated` in [cloudbuild.yaml](./cloudbuild.yaml) with `--ingress` which is specified by new variable, `cloudrun_ingress` (default: `all`)
- Updated Vault version from `1.11.2` to `1.11.3`
### Removed
- `zone` variable and any references to it (services used only require `region`)

## [0.2.1] - 2022-08-30
### Changed
- Using `data.google_project` to obtain project number instead of it being a user provided variable/value

## [0.2.0] - 2022-08-27
### Added
- Added **Cloud Run Admin** and **Service Account User** roles to Cloud Build service account
- [Google Cloud Build Trigger](https://cloud.google.com/build/docs/triggers) to use the `cloudbuild.yaml` that was introduced in **v0.1.1**
### Changed
- Updated **terraform** provider from `~> 0.15.0` to `~> 1.0`
- Updated **google** and **google-beta** providers from `~> 3.0` to `~> 4.0`
- Uses env var `VAULT_GCPCKMS_SEAL_KEY_RING` to get key ring name rather than via `cloud-run/vault-server.hcl`

## [0.1.6] - 2022-08-20
### Changed
- Updated Vault initialization README
- Updated Vault version from `1.10.4` to `1.11.2`

## [0.1.5] - 2022-06-22
### Added
- Apache v2 license
### Changed
- Updated Vault version from `1.9.4` to `1.10.4`

## [0.1.4] - 2022-04-05
### Changed
- Updated Vault version from `1.8.5` to `1.9.4`

## [0.1.3] - 2021-11-08
### Added
- `terraform.tfvars.sample` file
- Notes to enable Vault Audit Devices to send logs to Cloud Logging
### Changed
- Updated Vault version from `1.8.3` to `1.8.5`

## [0.1.2] - 2021-09-29
### Added
- [`.gcloudignore`](https://cloud.google.com/sdk/gcloud/reference/topic/gcloudignore) to exclude files that don't need to be part of the build
### Changed
- Updated Vault version from `1.7.3` to `1.8.3`

## [0.1.1] - 2021-07-21
### Added
- `clouldbuild.yaml` for [Cloud Build](https://cloud.google.com/build) to pick up
### Changed
- Updated Vault version from `1.7.2` to `1.7.3`

## [0.1.0] - 2021-06-06
### Added
- Initial commit
