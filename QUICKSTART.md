# Quick Start Guide

## Prerequisites

1. **Install Terraform**
   ```bash
   # macOS
   brew install terraform
   
   # Linux
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
   sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
   sudo apt-get update && sudo apt-get install terraform
   ```

2. **Create GitHub Personal Access Token**
   
   Go to: https://github.com/settings/tokens/new
   
   Required scopes:
   - ✅ `repo` - Full control of private repositories
   - ✅ `admin:repo_hook` - Full control of repository hooks
   - ✅ `delete_repo` - Delete repositories (optional, for destroy)
   - ✅ `admin:org` - Full control of orgs (if using organization)

3. **Set Environment Variables**
   ```bash
   export GITHUB_TOKEN="ghp_your_token_here"
   export GITHUB_OWNER="your-username-or-org"
   ```

## Setup (5 minutes)

### Option 1: Automated Setup (Recommended)

```bash
cd github-terraform-infra
chmod +x setup.sh
./setup.sh
```

The setup script will:
- ✅ Check prerequisites
- ✅ Validate GitHub authentication
- ✅ Create terraform.tfvars from example
- ✅ Initialize Terraform

### Option 2: Manual Setup

```bash
# 1. Copy example configuration
cp terraform.tfvars.example terraform.tfvars

# 2. Edit configuration
nano terraform.tfvars  # Update github_owner and other settings

# 3. Initialize Terraform
terraform init
```

## Deploy Your Repositories

### Quick Deploy

```bash
# Preview changes
terraform plan

# Apply changes
terraform apply

# Or use the deployment script
chmod +x deploy.sh
./deploy.sh
```

### Using Makefile

```bash
# Show available commands
make help

# Run setup
make setup

# Plan changes
make plan

# Apply changes
make apply

# Deploy to specific environment
make dev        # Deploy to development
make staging    # Deploy to staging
make production # Deploy to production
```

## Multi-Environment Deployment

### Development Environment

```bash
# Create dev configuration
cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars

# Edit dev settings
nano environments/dev/terraform.tfvars

# Deploy to dev
terraform workspace new dev
terraform apply -var-file="environments/dev/terraform.tfvars"

# Or use Make
make apply ENV=dev
```

### Staging Environment

```bash
terraform workspace new staging
terraform apply -var-file="environments/staging/terraform.tfvars"

# Or use Make
make apply ENV=staging
```

### Production Environment

```bash
terraform workspace new production
terraform apply -var-file="environments/production/terraform.tfvars"

# Or use Make
make apply ENV=production
```

## Common Operations

### Add a New Repository

1. Edit `repositories.tf` or create a new module instance:

```hcl
module "my_new_repo" {
  source = "./modules/repository"
  
  name        = "my-new-repo"
  description = "My new repository"
  visibility  = "private"
  
  enable_branch_protection = true
  enable_dependabot       = true
  enable_auto_updates     = true
  
  branch_protection = {
    pattern          = "main"
    required_reviews = 1
  }
  
  topics = ["terraform", "my-topic"]
}
```

2. Apply changes:
```bash
terraform apply
```

### Update Repository Settings

1. Modify the repository configuration in `repositories.tf`
2. Preview changes: `terraform plan`
3. Apply changes: `terraform apply`

### Add Secrets to Repository

1. Edit `secrets.tf` or add to `terraform.tfvars`:

```hcl
n8n_secrets = {
  "DATABASE_URL" = "postgresql://..."
  "API_KEY"      = "your-secret-key"
}
```

2. Apply changes:
```bash
terraform apply
```

### Configure Webhooks

1. Edit `terraform.tfvars`:

```hcl
enable_webhooks = true
webhook_url     = "https://your-endpoint.com/github"
webhook_secret  = "your-webhook-secret"
```

2. Apply changes:
```bash
terraform apply
```

## Verify Deployment

```bash
# View created resources
terraform output

# Check repository status
terraform show

# List all resources
terraform state list
```

## Cleanup

### Destroy Specific Environment

```bash
# Using Terraform
terraform destroy -var-file="environments/dev/terraform.tfvars"

# Using Make
make destroy ENV=dev

# Using deploy script
./deploy.sh  # Choose destroy option
```

### Destroy All Resources

```bash
terraform destroy

# Or use Make
make destroy
```

## Troubleshooting

### Authentication Issues

```bash
# Test GitHub token
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

# Check scopes
curl -I -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep x-oauth-scopes
```

### State Lock Issues

```bash
# Force unlock (use with caution)
terraform force-unlock <lock-id>
```

### Import Existing Repository

```bash
# Import existing repository
terraform import github_repository.n8n n8n

# Import branch protection
terraform import 'github_branch_protection.n8n_main[0]' n8n:main
```

### Re-initialize

```bash
# Clean and re-initialize
make clean
terraform init
```

## Best Practices

1. **Always Preview**: Run `terraform plan` before `apply`
2. **Use Workspaces**: Separate environments with workspaces
3. **Version Control**: Commit `.tf` files, not `.tfstate` or `.tfvars` with secrets
4. **Remote State**: Use remote state for team collaboration
5. **Test in Dev**: Always test changes in dev environment first

## Next Steps

- [ ] Set up remote state (S3, Terraform Cloud)
- [ ] Configure team access and permissions
- [ ] Add more repositories
- [ ] Customize branch protection rules
- [ ] Set up CI/CD integration
- [ ] Configure monitoring and alerting

## Getting Help

- 📖 [Terraform GitHub Provider Docs](https://registry.terraform.io/providers/integrations/github/latest/docs)
- 🐛 [Report Issues](https://github.com/your-repo/issues)
- 💬 [Discussions](https://github.com/your-repo/discussions)
