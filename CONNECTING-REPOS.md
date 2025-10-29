# How to Connect to Your Other Repositories

This guide shows you how to use this Terraform infrastructure to manage your existing GitHub repositories.

## Option 1: Import Existing Repositories

If you already have repositories like n8n, Glance, or other projects, you can import them into Terraform management.

### Step 1: Import the Repository

```bash
# Import existing repository
terraform import github_repository.n8n n8n

# Import branch protection (if exists)
terraform import 'github_branch_protection.n8n_main[0]' n8n:main
```

### Step 2: Verify Import

```bash
terraform state list
terraform show github_repository.n8n
```

### Step 3: Update Configuration

The repository is now managed by Terraform. Future changes should be made in `repositories.tf`.

## Option 2: Create New Repositories

### Using this Infrastructure to Create Repos

1. **Edit `repositories.tf`** - Add your repository definition
2. **Run `terraform apply`** - Creates the repository on GitHub
3. **Clone and develop** - Start working in your new repo

```bash
# After terraform creates the repo
git clone https://github.com/patel5d2/your-new-repo.git
cd your-new-repo
# Start developing!
```

## Option 3: Connect to Existing Repositories as Submodules

If you want to keep your existing repos separate but link them:

```bash
# Add existing repo as submodule
git submodule add https://github.com/patel5d2/n8n.git repos/n8n
git submodule add https://github.com/patel5d2/glance.git repos/glance

# Update submodules
git submodule update --init --recursive
```

## Managing Multiple Repositories

### Scenario 1: You have repositories across different orgs

```bash
# Deploy to personal account
export GITHUB_OWNER="patel5d2"
terraform workspace new personal
terraform apply

# Deploy to organization
export GITHUB_OWNER="your-org-name"
terraform workspace new organization
terraform apply
```

### Scenario 2: Use Terraform to configure existing repos

Edit `repositories.tf` to match your existing repository names:

```hcl
resource "github_repository" "existing_repo" {
  name = "your-existing-repo-name"
  # ... other settings
}
```

Then import and manage:

```bash
terraform import github_repository.existing_repo your-existing-repo-name
```

## Apply Terraform Config to Existing Repos

### Add Dependabot to Existing Repos

1. Edit `repositories.tf` - change repository names to your existing ones
2. Run `terraform import` for each repository
3. Run `terraform apply` - adds Dependabot, workflows, protection

### Add Branch Protection to Existing Repos

```bash
# Import existing repo
terraform import github_repository.my_repo my-repo-name

# Apply protection rules
terraform apply
```

## Practical Examples

### Example 1: Manage Your N8N Repository

If you already have an n8n repository at `https://github.com/patel5d2/n8n`:

```bash
# 1. Import it
terraform import github_repository.n8n n8n

# 2. Apply Terraform config (adds Dependabot, workflows, etc.)
terraform apply

# 3. Your repo now has auto-updates!
```

### Example 2: Create a New Project Repository

```bash
# 1. Add to repositories.tf
cat >> repositories.tf << 'EOF'

resource "github_repository" "my_new_project" {
  name        = "my-new-project"
  description = "My new project"
  visibility  = "private"
  # ... other settings from template
}
EOF

# 2. Apply
terraform apply

# 3. Clone and start working
git clone https://github.com/patel5d2/my-new-project.git
```

### Example 3: Bulk Update Settings Across Repos

```bash
# Update variables.tf to change default settings
# For example, change required_reviews from 1 to 2

# Apply to all repositories
terraform apply

# All your repos now require 2 reviews!
```

## Repository Organization

### Recommended Structure

```
~/
├── github-terraform-infra/          # This repo - manages infrastructure
│   ├── repositories.tf              # Defines your repos
│   ├── terraform.tfvars             # Your settings
│   └── ...
│
└── projects/                        # Your actual project repositories
    ├── n8n/                         # Managed by Terraform
    ├── glance/                      # Managed by Terraform
    ├── my-app/                      # Managed by Terraform
    └── ...
```

### Workflow

1. **Update infrastructure** in `github-terraform-infra/`
2. **Apply changes** with `terraform apply`
3. **Develop** in your individual project repos
4. **Benefit** from auto-updates and protection rules

## GitHub Actions Integration

### Enable Auto-Updates Across All Repos

Once you run `terraform apply`, all your repositories will have:

- ✅ Dependabot configuration
- ✅ Auto-update workflows
- ✅ Branch protection
- ✅ CODEOWNERS files

### Check Auto-Update Status

```bash
# View which repos are managed
terraform state list | grep github_repository

# Check Dependabot status
gh repo list --json name,url | jq '.[]'
```

## Connecting to Continuous Deployment

### Link to Your CI/CD Pipeline

1. **Add secrets** to repositories via Terraform
2. **Configure webhooks** for deployment triggers
3. **Use GitHub Actions** for automated deployments

Example in `secrets.tf`:

```hcl
n8n_secrets = {
  "DEPLOY_URL"    = "https://your-deployment-url.com"
  "DEPLOY_TOKEN"  = "your-token"
}
```

## Repository Templates

### Use Boilerplate as Template

The `boilerplate` repository is configured as a template:

```bash
# Create new repo from template
gh repo create my-new-app --template patel5d2/boilerplate --private

# Or via Terraform
module "new_app" {
  source = "./modules/repository"
  
  name = "new-app"
  template = {
    owner      = "patel5d2"
    repository = "boilerplate"
  }
}
```

## Monitoring and Maintenance

### Check Repository Status

```bash
# List all managed repositories
terraform state list | grep github_repository

# View repository details
gh repo view patel5d2/n8n

# Check Dependabot PRs
gh pr list --repo patel5d2/n8n --label dependencies
```

### Update All Repositories

```bash
# Make changes in repositories.tf
# Apply to all repos at once
terraform apply
```

## Troubleshooting

### Repository Already Exists Error

```bash
# Import existing repository before applying
terraform import github_repository.name repository-name
```

### Branch Protection Conflicts

```bash
# Remove existing protection, let Terraform manage it
gh api repos/patel5d2/repo-name/branches/main/protection -X DELETE

# Then apply
terraform apply
```

### Sync Issues

```bash
# Refresh Terraform state
terraform refresh

# Re-import if needed
terraform import github_repository.name repository-name
```

## Best Practices

1. **Start Small** - Import one repo at a time
2. **Test First** - Use dev environment for testing
3. **Document** - Keep track of which repos are managed
4. **Version Control** - Commit all `.tf` files (not `.tfvars` with secrets)
5. **Review Plans** - Always run `terraform plan` before `apply`
6. **Backup State** - Use remote state for production

## Next Steps

1. ✅ Repository pushed to GitHub
2. ⏭️ Import your existing repositories
3. ⏭️ Apply auto-update configuration
4. ⏭️ Configure secrets and webhooks
5. ⏭️ Set up multi-environment deployment
6. ⏭️ Enjoy automated infrastructure management!

## Quick Reference

```bash
# Import existing repo
terraform import github_repository.NAME repo-name

# Add new repo
# Edit repositories.tf, then:
terraform apply

# Update settings
# Edit terraform.tfvars, then:
terraform apply

# Remove repo from Terraform (doesn't delete from GitHub)
terraform state rm github_repository.NAME

# View managed repos
terraform state list

# Check GitHub CLI
gh repo list patel5d2
```

## Support

- 📖 [Main README](README.md)
- 🚀 [Quick Start](QUICKSTART.md)
- 💡 [Examples](EXAMPLES.md)
- 🐛 [Open an Issue](https://github.com/patel5d2/github-terraform-infra/issues)

Happy Infrastructure Management! 🚀
