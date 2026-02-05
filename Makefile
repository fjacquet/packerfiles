# Packer HCL2 Build Automation
#
# Usage:
#   make validate OS=ubuntu VARIANT=ubuntu-2204-server
#   make build OS=ubuntu VARIANT=ubuntu-2204-server
#   make build-only OS=ubuntu VARIANT=ubuntu-2204-server BUILDER=vmware-iso
#   make validate-all    # Validate all templates
#   make init-all        # Initialize all plugins
#   make lint            # Run all linters (fmt, validate, shellcheck, markdownlint)
#   make fmt             # Check HCL2 formatting
#   make fmt-fix         # Auto-fix HCL2 formatting
#   make docs            # Show variant table + directory overview
#   make list-variants   # List all OS variants and builders
#   make clean           # Remove build output directories

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

.PHONY: help validate build build-only init init-all validate-all lint fmt fmt-fix shellcheck markdownlint docs list-variants clean

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

lint: fmt validate-all shellcheck markdownlint ## Run all linters (fmt, validate, shellcheck, markdownlint)
	@echo "All lint checks passed."

fmt: ## Check HCL2 formatting (packer fmt -check)
	@failed=0; \
	for os in $(ALL_OS); do \
		if ! $(PACKER) fmt -check templates/$$os/ > /dev/null 2>&1; then \
			echo "FAIL: templates/$$os/ needs formatting (run: make fmt-fix)"; \
			failed=1; \
		fi; \
	done; \
	if [ $$failed -eq 1 ]; then echo "FAILED: Some templates need formatting"; exit 1; fi; \
	echo "All templates are properly formatted."

fmt-fix: ## Auto-fix HCL2 formatting (packer fmt -write)
	@for os in $(ALL_OS); do \
		echo "==> Formatting $$os..."; \
		$(PACKER) fmt templates/$$os/; \
	done; \
	echo "All templates formatted."

shellcheck: ## Lint bash provisioning scripts with shellcheck
	@if command -v shellcheck > /dev/null 2>&1; then \
		echo "==> Running shellcheck on provisioning scripts..."; \
		find scripts/bash -name '*.sh' -exec shellcheck -s bash -S warning {} + && \
		echo "shellcheck passed." || \
		(echo "FAILED: shellcheck found issues"; exit 1); \
	else \
		echo "SKIP: shellcheck not installed (brew install shellcheck)"; \
	fi

markdownlint: ## Lint markdown files
	@if command -v markdownlint-cli2 > /dev/null 2>&1; then \
		echo "==> Running markdownlint..."; \
		markdownlint-cli2 '*.md' 'iso/*.md' && \
		echo "markdownlint passed." || \
		(echo "FAILED: markdownlint found issues"; exit 1); \
	elif command -v markdownlint > /dev/null 2>&1; then \
		echo "==> Running markdownlint..."; \
		markdownlint '*.md' 'iso/*.md' && \
		echo "markdownlint passed." || \
		(echo "FAILED: markdownlint found issues"; exit 1); \
	else \
		echo "SKIP: markdownlint not installed (npm install -g markdownlint-cli2)"; \
	fi

docs: list-variants ## Generate documentation (variant table + directory tree)
	@echo ""
	@echo "=== Directory Structure ==="
	@echo ""
	@echo "templates/          HCL2 Packer templates (14 OS families)"
	@for os in $(ALL_OS); do \
		files=$$(ls templates/$$os/*.pkr.hcl 2>/dev/null | xargs -n1 basename | tr '\n' ', ' | sed 's/,$$//'); \
		printf "  %-18s %s\n" "$$os/" "$$files"; \
	done
	@echo ""
	@echo "vars/               Variable files (.pkrvars.hcl)"
	@for os in $(ALL_OS); do \
		count=$$(ls vars/$$os/*.pkrvars.hcl 2>/dev/null | wc -l | tr -d ' '); \
		if [ "$$count" -gt 0 ]; then \
			printf "  %-18s %s variant(s)\n" "$$os/" "$$count"; \
		else \
			printf "  %-18s (no variants)\n" "$$os/"; \
		fi; \
	done
	@echo ""
	@echo "http/               Preseed, Kickstart, Agama, autoinstall configs"
	@echo "scripts/            Provisioning scripts (bash, batch, powershell)"
	@echo "floppy/             Windows Autounattend.xml and install-time scripts"
	@echo "archive/            Legacy JSON templates, EOL variants"

list-variants: ## List all OS families and their available variants
	@echo "=== Available Variants ==="
	@echo ""
	@printf "%-18s %-50s %s\n" "OS Family" "Variants" "Builders"
	@printf "%-18s %-50s %s\n" "---------" "--------" "--------"
	@for os in $(ALL_OS); do \
		variants=$$(ls vars/$$os/*.pkrvars.hcl 2>/dev/null | xargs -n1 basename | sed 's/.pkrvars.hcl//' | tr '\n' ', ' | sed 's/,$$//'); \
		if [ -z "$$variants" ]; then variants="(none)"; fi; \
		builders=""; \
		if grep -rq 'vmware-iso' templates/$$os/*.pkr.hcl 2>/dev/null; then builders="VMware"; fi; \
		if grep -rq 'virtualbox-iso' templates/$$os/*.pkr.hcl 2>/dev/null; then builders="$$builders,VBox"; fi; \
		if grep -rq 'parallels-iso' templates/$$os/*.pkr.hcl 2>/dev/null; then builders="$$builders,Parallels"; fi; \
		if grep -rq 'proxmox-iso' templates/$$os/*.pkr.hcl 2>/dev/null; then builders="$$builders,Proxmox"; fi; \
		if grep -rq 'amazon-ebs' templates/$$os/*.pkr.hcl 2>/dev/null; then builders="$$builders,AWS"; fi; \
		if grep -rq 'azure-arm' templates/$$os/*.pkr.hcl 2>/dev/null; then builders="$$builders,Azure"; fi; \
		builders=$$(echo "$$builders" | sed 's/^,//'); \
		printf "%-18s %-50s %s\n" "$$os" "$$variants" "$$builders"; \
	done

clean: ## Remove Packer build output directories
	@echo "==> Cleaning build output..."
	@rm -rf output-*
	@echo "Done."

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
