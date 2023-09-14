FROM debian:buster as builder

ENV VAULT_VERSION=1.14.3

ARG DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates openssl wget unzip zip
RUN wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
# hadolint ignore=DL3059
RUN unzip vault_${VAULT_VERSION}_linux_amd64.zip

# hadolint ignore=DL3007
FROM alpine:latest as certs
# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates

FROM scratch
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /vault ${WORKDIR}/.

ENTRYPOINT ["/vault", "server", "-config", "/etc/vault/config.hcl"]
