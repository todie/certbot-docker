HELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

CUDA_VERSION=11.4.2
UBUNTU_VERSION=ubuntu20.04
PROJECT:=coreweave/cudaglx
BUILD_COMMAND:=docker buildx build
BUILD_ARGS:=

IMAGE_TAG_DEV:=${CUDA_VERSION}-devel-${UBUNTU_VERSION}
IMAGE_TAG_TEST:=${CUDA_VERSION}-test-${UBUNTU_VERSION}
IMAGE_TAG_RELEASE:=${CUDA_VERSION}-runtime-${UBUNTU_VERSION}

.PHONY: help
help: ## displays this help screen.
> @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort | awk '\
		BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2};\
		'

DOMAINS:="-d financesbyvita.com -d www.financesbyvita.com"
ARGS:="--dns-digitalocean --dns-digitalocean-credentials /workdir/certbot-creds.ini"
.PHONY: certbot-dns
dns-request: ## request dns based certbot verification ( make sure doctl is installed )
> docker run -it --rm --name $@ \
            -v "/etc/letsencrypt:/etc/letsencrypt" \
            -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
						-v "${PWD}/:/workdir/" \
            certbot/dns-digitalocean certonly \
						${ARGS} ${DOMAINS}

dns-renew: ## renew all existing letsencrypt certs that are near expiry
> docker run -it --rm --name $@ \
            -v "/etc/letsencrypt:/etc/letsencrypt" \
            -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
						-v "${PWD}/:/workdir/" \
            certbot/dns-digitalocean renew \
						--dry-run
