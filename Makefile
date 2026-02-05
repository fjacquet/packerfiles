# Packer HCL2 Build Automation
#
# Usage:
#   make validate OS=ubuntu VARIANT=ubuntu-2204-server
#   make build OS=ubuntu VARIANT=ubuntu-2204-server
#   make build-only OS=ubuntu VARIANT=ubuntu-2204-server BUILDER=vmware-iso
#   make validate-all
#   make init-all

PACKER ?= packer

# OS family (ubuntu, debian, centos, fedora, oraclelinux, almalinux, rockylinux, opensuse, freebsd, openbsd, netbsd, dragonflybsd, windows, esxi)
OS ?=
# Variant name without extension (e.g. ubuntu-2204-server, eval-win2022-standard-cygwin)
VARIANT ?=
# Optional: specific builder (e.g. vmware-iso.ubuntu, virtualbox-iso.ubuntu)
BUILDER ?=

TEMPLATE_DIR = templates/$(OS)
VAR_FILE = vars/$(OS)/$(VARIANT).pkrvars.hcl

# All OS families
ALL_OS = ubuntu debian centos fedora oraclelinux almalinux rockylinux opensuse freebsd openbsd netbsd dragonflybsd windows esxi

# Default variant per OS for validation
DEFAULT_VARIANTS = \
	ubuntu:ubuntu-2204-server \
	debian:debian-12 \
	fedora:fedora-41-server \
	oraclelinux:ol-9-server \
	almalinux:alma-9-server \
	rockylinux:rocky-9-server \
	opensuse:leap-16-server \
	freebsd:freebsd-14 \
	openbsd:openbsd-76 \
	netbsd:netbsd-10 \
	dragonflybsd:dragonflybsd-64 \
	windows:eval-win2022-standard-cygwin \
	esxi:esxi-80

.PHONY: help validate build build-only init init-all validate-all

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

validate: _check-params ## Validate a template (requires OS and VARIANT)
	$(PACKER) validate -var-file=$(VAR_FILE) $(TEMPLATE_DIR)/

build: _check-params ## Build a template (requires OS and VARIANT)
	$(PACKER) build -var-file=$(VAR_FILE) $(TEMPLATE_DIR)/

build-only: _check-params _check-builder ## Build with specific builder (requires OS, VARIANT, BUILDER)
	$(PACKER) build -only='$(BUILDER)' -var-file=$(VAR_FILE) $(TEMPLATE_DIR)/

init: _check-os ## Initialize plugins for an OS template (requires OS)
	$(PACKER) init $(TEMPLATE_DIR)/

init-all: ## Initialize plugins for all OS templates
	@for os in $(ALL_OS); do \
		echo "==> Initializing $$os..."; \
		$(PACKER) init templates/$$os/ || true; \
	done

validate-all: ## Validate all templates with default variants
	@failed=0; \
	for pair in $(DEFAULT_VARIANTS); do \
		os=$${pair%%:*}; \
		variant=$${pair##*:}; \
		echo "==> Validating $$os ($$variant)..."; \
		$(PACKER) validate -var-file=vars/$$os/$$variant.pkrvars.hcl templates/$$os/ || failed=1; \
	done; \
	if [ $$failed -eq 1 ]; then echo "FAILED: Some templates did not validate"; exit 1; fi; \
	echo "All templates validated successfully."

_check-params:
	@test -n "$(OS)" || (echo "ERROR: OS is required (e.g. make validate OS=ubuntu VARIANT=ubuntu-2204-server)" && exit 1)
	@test -n "$(VARIANT)" || (echo "ERROR: VARIANT is required (e.g. make validate OS=ubuntu VARIANT=ubuntu-2204-server)" && exit 1)
	@test -d "$(TEMPLATE_DIR)" || (echo "ERROR: Template directory $(TEMPLATE_DIR) not found" && exit 1)
	@test -f "$(VAR_FILE)" || (echo "ERROR: Var file $(VAR_FILE) not found" && exit 1)

_check-os:
	@test -n "$(OS)" || (echo "ERROR: OS is required" && exit 1)
	@test -d "$(TEMPLATE_DIR)" || (echo "ERROR: Template directory $(TEMPLATE_DIR) not found" && exit 1)

_check-builder:
	@test -n "$(BUILDER)" || (echo "ERROR: BUILDER is required (e.g. vmware-iso.ubuntu)" && exit 1)
