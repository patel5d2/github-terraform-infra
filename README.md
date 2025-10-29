# GitHub Repository Infrastructure as Code

This Terraform configuration manages GitHub repositories, their settings, branch protection rules, secrets, and auto-update mechanisms.

## Features

- 🏗️ **Repository Management**: Define repositories as code with complete settings
- 🔒 **Branch Protection**: Configure protection rules for main/production branches
- 🔐 **Secrets Management**: Store and manage repository secrets
- 🔄 **Auto-Updates**: Maintain Dependabot and GitHub Actions workflows
- 🌍 **Multi-Environment**: Support for dev, staging, and production
- 🎯 **Webhooks**: Configure repository webhooks
- 👥 **Team Management**: Manage repository access and permissions

## Prerequisites

1. **Terraform**: Install Terraform >= 1.0
   ```bash
   brew install terraform  # macOS
   ```

2. **GitHub Personal Access Token**: Create a token with the following scopes:
   - `repo` (Full control of private repositories)
   - `admin:repo_hook` (Full control of repository hooks)
   - `delete_repo` (Delete repositories)
   - `admin:org` (Full control of orgs and teams) - if managing org repos

   Create token at: https://github.com/settings/tokens/new

3. **Environment Variables**: Set your GitHub token
   ```bash
   export GITHUB_TOKEN="your_github_token_here"
   export GITHUB_OWNER="your_github_username_or_org"
   ```

## Quick Start

### 1. Initialize Terraform
```bash
cd github-terraform-infra
terraform init
```

### 2. Configure Your Repositories
Edit `repositories.tf` to define your repositories or use `terraform.tfvars` for customization.

### 3. Plan Your Changes
```bash
terraform plan -var="github_owner=$GITHUB_OWNER"
```

### 4. Apply Configuration
```bash
terraform apply -var="github_owner=$GITHUB_OWNER"
```

### 5. Destroy Resources (if needed)
```bash
terraform destroy -var="github_owner=$GITHUB_OWNER"
```

## Project Structure

```
github-terraform-infra/
├── README.md                    # This file
├── main.tf                      # Provider configuration
├── variables.tf                 # Variable definitions
├── terraform.tfvars.example     # Example variable values
├── repositories.tf              # Repository definitions
├── branch-protection.tf         # Branch protection rules
├── secrets.tf                   # Repository secrets
├── webhooks.tf                  # Webhook configurations
├── workflows/                   # GitHub Actions workflows
│   ├── dependabot-auto-merge.yml
│   └── auto-update.yml
├── modules/                     # Reusable Terraform modules
│   └── repository/              # Repository module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/                # Environment-specific configs
│   ├── dev/
│   ├── staging/
│   └── production/
└── outputs.tf                   # Output values

```

## Configuration Examples

### Adding a New Repository

```hcl
module "my_new_repo" {
  source = "./modules/repository"
  
  name        = "my-awesome-project"
  description = "My awesome project description"
  visibility  = "private"
  
  enable_auto_updates = true
  enable_dependabot   = true
  
  branch_protection = {
    pattern                 = "main"
    required_reviews        = 1
    require_code_owner_reviews = true
  }
  
  secrets = {
    DEPLOYMENT_TOKEN = "sensitive_value"
  }
  
  environment = "production"
}
```

### Multi-Environment Setup

```bash
# Deploy to development
terraform workspace new dev
terraform apply -var-file="environments/dev/terraform.tfvars"

# Deploy to production
terraform workspace new production
terraform apply -var-file="environments/production/terraform.tfvars"
```

## Common Use Cases

### 1. Replicate Repository Across Organizations
```hcl
# In different workspaces or state files
provider "github" {
  owner = var.github_owner  # Change per environment
}
```

### 2. Bulk Repository Creation
Define multiple repositories in `repositories.tf` and apply once.

### 3. Standardize Branch Protection
Use the repository module to enforce consistent protection rules.

### 4. Secret Rotation
Update secrets in Terraform and apply to rotate across all repos.

## Best Practices

1. **State Management**: Use remote state (S3, Terraform Cloud) for team collaboration
2. **Sensitive Data**: Never commit secrets to version control - use environment variables or secret managers
3. **Workspaces**: Use Terraform workspaces for environment separation
4. **Modules**: Create reusable modules for common patterns
5. **Version Control**: Commit Terraform files (except `*.tfstate`, `*.tfvars` with secrets)

## Troubleshooting

### Authentication Issues
```bash
# Verify token has correct permissions
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

### State Conflicts
```bash
# Refresh state
terraform refresh

# Import existing resources
terraform import github_repository.example repository-name
```

### Dependency Errors
```bash
# Re-initialize
rm -rf .terraform
terraform init
```

## Security Notes

⚠️ **Important Security Considerations**:
- Never commit `terraform.tfvars` with sensitive data
- Use GitHub Actions secrets or HashiCorp Vault for production secrets
- Rotate GitHub tokens regularly
- Use least-privilege access for tokens
- Enable 2FA on your GitHub account

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `terraform plan`
5. Submit a pull request

## License

MIT License - Feel free to use and modify for your needs.

## Resources

- [Terraform GitHub Provider Documentation](https://registry.terraform.io/providers/integrations/github/latest/docs)
- [GitHub API Documentation](https://docs.github.com/en/rest)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
