# Project Structure

```
github-terraform-infra/
│
├── README.md                           # Main documentation
├── QUICKSTART.md                       # Quick start guide
├── EXAMPLES.md                         # Advanced usage examples
├── .gitignore                          # Git ignore patterns
├── Makefile                            # Automation commands
├── setup.sh                            # Initial setup script
├── deploy.sh                           # Deployment script
│
├── main.tf                             # Terraform provider configuration
├── variables.tf                        # Variable definitions
├── outputs.tf                          # Output definitions
├── terraform.tfvars.example            # Example configuration
│
├── repositories.tf                     # Repository definitions
├── branch-protection.tf                # Branch protection rules
├── secrets.tf                          # Repository secrets
├── webhooks.tf                         # Webhook configurations
│
├── modules/                            # Reusable Terraform modules
│   └── repository/                     # Repository module
│       ├── main.tf                     # Module main configuration
│       ├── variables.tf                # Module variables
│       └── outputs.tf                  # Module outputs
│
├── templates/                          # Template files
│   ├── dependabot.yml                  # Dependabot configuration
│   └── workflows/                      # GitHub Actions workflows
│       └── auto-update.yml             # Auto-update workflow
│
└── environments/                       # Environment-specific configs
    ├── dev/
    │   └── terraform.tfvars.example    # Dev environment config
    ├── staging/
    │   └── terraform.tfvars.example    # Staging environment config
    └── production/
        └── terraform.tfvars.example    # Production environment config
```

## File Descriptions

### Core Terraform Files

- **main.tf**: Configures the GitHub Terraform provider and backend
- **variables.tf**: Defines all input variables with descriptions and validation
- **outputs.tf**: Defines outputs to display after applying configuration
- **repositories.tf**: Main repository definitions for n8n, Glance, and boilerplate
- **branch-protection.tf**: Branch protection rules and CODEOWNERS files
- **secrets.tf**: Repository secrets and variables management
- **webhooks.tf**: Webhook configurations for all repositories

### Automation Scripts

- **setup.sh**: Interactive setup script
  - Checks prerequisites
  - Validates GitHub authentication
  - Creates configuration files
  - Initializes Terraform

- **deploy.sh**: Deployment automation script
  - Environment selection
  - Plan/Apply/Destroy operations
  - Safety confirmations

- **Makefile**: Make targets for common operations
  - `make setup`: Run initial setup
  - `make plan`: Preview changes
  - `make apply`: Apply changes
  - `make destroy`: Destroy resources
  - `make dev/staging/production`: Quick environment deploys

### Templates

- **templates/dependabot.yml**: Dependabot configuration
  - NPM, Docker, GitHub Actions, pip, Terraform
  - Weekly update schedule
  - Auto-labeling and assignment

- **templates/workflows/auto-update.yml**: Auto-update workflow
  - Auto-merge Dependabot PRs (minor/patch)
  - Manual approval for major updates
  - Dependency check summaries

### Modules

- **modules/repository/**: Reusable repository module
  - Complete repository configuration
  - Branch protection
  - Dependabot and workflows
  - Secrets and variables
  - Webhooks
  - CODEOWNERS

### Environments

- **environments/dev/**: Development environment
  - No required reviews
  - Debug logging
  - More permissive settings

- **environments/staging/**: Staging environment
  - 1 required review
  - Moderate protection
  - Production-like settings

- **environments/production/**: Production environment
  - 2 required reviews
  - Strict protection
  - Enhanced security

## Documentation

- **README.md**: Comprehensive project documentation
  - Features overview
  - Prerequisites
  - Quick start guide
  - Configuration examples
  - Best practices
  - Troubleshooting

- **QUICKSTART.md**: Step-by-step quick start
  - Installation steps
  - Setup process
  - Common operations
  - Multi-environment deployment

- **EXAMPLES.md**: Advanced usage examples
  - Custom repository modules
  - Bulk repository creation
  - Dynamic configurations
  - Secret management
  - GitOps integration
  - Team management

## Configuration Files

### terraform.tfvars.example

Example configuration file showing all available options:
- GitHub settings
- Repository defaults
- Branch protection settings
- Secrets and variables
- Webhook configuration

Copy to `terraform.tfvars` and customize for your needs.

### Environment-Specific Configs

Each environment directory contains:
- `terraform.tfvars.example`: Environment-specific settings
- Customized for development, staging, or production use

## Key Features by File

### repositories.tf
- ✅ Define repositories (n8n, Glance, boilerplate)
- ✅ Configure repository settings
- ✅ Add Dependabot configuration
- ✅ Add auto-update workflows
- ✅ Set repository topics
- ✅ Template support

### branch-protection.tf
- ✅ Protect main branch
- ✅ Required reviews
- ✅ Status checks
- ✅ Code owner reviews
- ✅ CODEOWNERS files
- ✅ Environment-specific rules

### secrets.tf
- ✅ Repository secrets (sensitive)
- ✅ Repository variables (non-sensitive)
- ✅ Common secrets for all repos
- ✅ Per-repository secrets
- ✅ Secure handling

### webhooks.tf
- ✅ Webhook configuration
- ✅ Multiple event types
- ✅ Secure authentication
- ✅ Per-repository webhooks

## Usage Patterns

### Single Repository Management
```bash
# Edit repositories.tf
terraform plan
terraform apply
```

### Multi-Environment Deployment
```bash
# Deploy to dev
make apply ENV=dev

# Deploy to staging
make apply ENV=staging

# Deploy to production
make apply ENV=production
```

### Bulk Operations
```bash
# Format all files
make fmt

# Validate configuration
make validate

# Run all checks
make check
```

### Module Usage
```hcl
module "my_repo" {
  source = "./modules/repository"
  # ... configuration
}
```

## Best Practices Implemented

1. **Separation of Concerns**: Each file handles specific resource types
2. **Reusability**: Module-based architecture for common patterns
3. **Environment Isolation**: Separate configs per environment
4. **Security**: Secrets management, .gitignore for sensitive files
5. **Automation**: Scripts and Makefile for common tasks
6. **Documentation**: Comprehensive guides and examples
7. **Version Control**: Template files for sharing, actual config ignored
8. **Validation**: Input validation on variables
9. **Outputs**: Useful information displayed after apply
10. **Flexibility**: Support for multiple deployment patterns

## Next Steps

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Update with your GitHub username/org and settings
3. Run `./setup.sh` or `make setup`
4. Review plan with `terraform plan` or `make plan`
5. Apply with `terraform apply` or `make apply`
6. Customize for your specific needs

## Integration Points

- **CI/CD**: GitHub Actions workflows included
- **Security**: Dependabot for dependency updates
- **Team Collaboration**: CODEOWNERS, branch protection
- **Monitoring**: Webhook support for external systems
- **Multi-Environment**: Workspace and tfvars support
- **Secret Management**: Support for external secret stores
