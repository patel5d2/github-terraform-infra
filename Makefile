# Terraform GitHub Infrastructure Makefile

.PHONY: help init plan apply destroy fmt validate clean setup

# Default target
.DEFAULT_GOAL := help

# Variables
GITHUB_OWNER ?= $(shell echo $$GITHUB_OWNER)
ENV ?= production
TFVARS_FILE ?= terraform.tfvars

# Colors
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)GitHub Terraform Infrastructure$(NC)"
	@echo ""
	@echo "$(YELLOW)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Examples:$(NC)"
	@echo "  make setup              # Initial setup"
	@echo "  make plan               # Preview changes"
	@echo "  make apply              # Apply changes"
	@echo "  make plan ENV=dev       # Plan for dev environment"
	@echo "  make apply ENV=staging  # Apply to staging"

setup: ## Run initial setup
	@echo "$(YELLOW)Running setup...$(NC)"
	@chmod +x setup.sh deploy.sh
	@./setup.sh

init: ## Initialize Terraform
	@echo "$(YELLOW)Initializing Terraform...$(NC)"
	@terraform init

fmt: ## Format Terraform files
	@echo "$(YELLOW)Formatting Terraform files...$(NC)"
	@terraform fmt -recursive

validate: init ## Validate Terraform configuration
	@echo "$(YELLOW)Validating Terraform configuration...$(NC)"
	@terraform validate

plan: validate ## Plan Terraform changes
	@echo "$(YELLOW)Planning changes for $(ENV) environment...$(NC)"
	@if [ "$(ENV)" != "production" ] && [ -f "environments/$(ENV)/terraform.tfvars" ]; then \
		terraform plan -var-file="environments/$(ENV)/terraform.tfvars" -var="github_owner=$(GITHUB_OWNER)"; \
	else \
		terraform plan -var-file="$(TFVARS_FILE)" -var="github_owner=$(GITHUB_OWNER)"; \
	fi

apply: validate ## Apply Terraform changes
	@echo "$(YELLOW)Applying changes for $(ENV) environment...$(NC)"
	@if [ "$(ENV)" != "production" ] && [ -f "environments/$(ENV)/terraform.tfvars" ]; then \
		terraform apply -var-file="environments/$(ENV)/terraform.tfvars" -var="github_owner=$(GITHUB_OWNER)"; \
	else \
		terraform apply -var-file="$(TFVARS_FILE)" -var="github_owner=$(GITHUB_OWNER)"; \
	fi

destroy: ## Destroy Terraform resources
	@echo "$(RED)WARNING: This will destroy resources in $(ENV) environment!$(NC)"
	@read -p "Are you sure? Type 'yes' to confirm: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		if [ "$(ENV)" != "production" ] && [ -f "environments/$(ENV)/terraform.tfvars" ]; then \
			terraform destroy -var-file="environments/$(ENV)/terraform.tfvars" -var="github_owner=$(GITHUB_OWNER)"; \
		else \
			terraform destroy -var-file="$(TFVARS_FILE)" -var="github_owner=$(GITHUB_OWNER)"; \
		fi \
	else \
		echo "$(YELLOW)Destroy cancelled$(NC)"; \
	fi

output: ## Show Terraform outputs
	@terraform output

refresh: ## Refresh Terraform state
	@echo "$(YELLOW)Refreshing state...$(NC)"
	@terraform refresh -var="github_owner=$(GITHUB_OWNER)"

clean: ## Clean Terraform files
	@echo "$(YELLOW)Cleaning Terraform files...$(NC)"
	@rm -rf .terraform
	@rm -f .terraform.lock.hcl
	@echo "$(GREEN)✓ Clean complete$(NC)"

docs: ## Generate documentation
	@echo "$(YELLOW)Generating documentation...$(NC)"
	@terraform-docs markdown table --output-file README-TERRAFORM.md .
	@echo "$(GREEN)✓ Documentation generated$(NC)"

check: ## Run all checks (format, validate, plan)
	@echo "$(YELLOW)Running all checks...$(NC)"
	@$(MAKE) fmt
	@$(MAKE) validate
	@$(MAKE) plan
	@echo "$(GREEN)✓ All checks passed$(NC)"

dev: ## Quick deploy to dev environment
	@$(MAKE) apply ENV=dev

staging: ## Quick deploy to staging environment
	@$(MAKE) apply ENV=staging

production: ## Quick deploy to production environment
	@$(MAKE) apply ENV=production
