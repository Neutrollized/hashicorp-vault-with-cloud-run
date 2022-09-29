# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.2.2] - 2022-09-29
### Changed
- replaced `--allow-unauthenticated` in [cloudbuild.yaml](./cloudbuild.yaml) with `--ingress` which is specified by new variable, `cloudrun_ingress` (default: `all`)
- updated Vault version from `1.11.2` to `1.11.3`
### Removed
- `zone` variable and any references to it (services used only require `region`)

## [0.2.1] - 2022-08-30
### Changed
- using `data.google_project` to obtain project number instead of it being a user provided variable/value

## [0.2.0] - 2022-08-27
### Added
- added **Cloud Run Admin** and **Service Account User** roles to Cloud Build service account
- [Google Cloud Build Trigger](https://cloud.google.com/build/docs/triggers) to use the `cloudbuild.yaml` that was introduced in **v0.1.1**
### Changed
- updated **terraform** provider from `~> 0.15.0` to `~> 1.0`
- updated **google** and **google-beta** providers from `~> 3.0` to `~> 4.0`
- uses env var `VAULT_GCPCKMS_SEAL_KEY_RING` to get key ring name rather than via `cloud-run/vault-server.hcl`

## [0.1.6] - 2022-08-20
### Changed
- updated Vault initialization README
- updated Vault version from `1.10.4` to `1.11.2`

## [0.1.5] - 2022-06-22
### Added
- Apache v2 license
### Changed
- updated Vault version from `1.9.4` to `1.10.4`

## [0.1.4] - 2022-04-05
### Changed
- updated Vault version from `1.8.5` to `1.9.4`

## [0.1.3] - 2021-11-08
### Added
- `terraform.tfvars.sample` file
- notes to enable Vault Audit Devices to send logs to Cloud Logging
### Changed
- updated Vault version from `1.8.3` to `1.8.5`

## [0.1.2] - 2021-09-29
### Added
- [`.gcloudignore`](https://cloud.google.com/sdk/gcloud/reference/topic/gcloudignore) to exclude files that don't need to be part of the build
### Changed
- updated Vault version from `1.7.3` to `1.8.3`

## [0.1.1] - 2021-07-21
### Added
- `clouldbuild.yaml` for [Cloud Build](https://cloud.google.com/build) to pick up
### Changed
- updated Vault version from `1.7.2` to `1.7.3`

## [0.1.0] - 2021-06-06
### Added
- Initial commit
