# Advanced Usage Examples

## Table of Contents

- [Custom Repository Module](#custom-repository-module)
- [Bulk Repository Creation](#bulk-repository-creation)
- [Dynamic Branch Protection](#dynamic-branch-protection)
- [Secret Management](#secret-management)
- [Webhook Automation](#webhook-automation)
- [Team and Permissions](#team-and-permissions)
- [Monorepo Support](#monorepo-support)
- [GitOps Integration](#gitops-integration)

## Custom Repository Module

### Using the Repository Module

```hcl
module "custom_app" {
  source = "./modules/repository"
  
  name        = "custom-app"
  description = "Custom application with full configuration"
  visibility  = "private"
  
  # Repository settings
  has_issues    = true
  has_projects  = true
  has_wiki      = false
  is_template   = false
  homepage_url  = "https://example.com"
  
  # Branch protection
  enable_branch_protection = true
  branch_protection = {
    pattern                         = "main"
    required_reviews                = 2
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    require_last_push_approval      = true
    enforce_admins                  = false
    allows_deletions                = false
    allows_force_pushes             = false
    require_conversation_resolution = true
    require_signed_commits          = true
    required_linear_history         = true
    
    required_status_checks = {
      strict   = true
      contexts = ["ci/tests", "ci/lint", "ci/security-scan"]
    }
  }
  
  # Auto-updates
  enable_dependabot   = true
  enable_auto_updates = true
  
  dependabot_config = templatefile("${path.module}/templates/dependabot.yml", {})
  auto_update_workflow = templatefile("${path.module}/templates/workflows/auto-update.yml", {})
  
  # Secrets
  secrets = {
    DATABASE_URL    = var.database_url
    API_KEY         = var.api_key
    DEPLOY_TOKEN    = var.deploy_token
    SENTRY_DSN      = var.sentry_dsn
  }
  
  # Variables
  variables = {
    ENVIRONMENT     = "production"
    LOG_LEVEL       = "info"
    FEATURE_FLAG_X  = "true"
    API_VERSION     = "v2"
  }
  
  # Topics
  topics = [
    "terraform",
    "infrastructure-as-code",
    "microservice",
    "docker",
    "kubernetes"
  ]
  
  # Webhook
  webhook = {
    url          = "https://hooks.example.com/github"
    content_type = "json"
    secret       = var.webhook_secret
    insecure_ssl = false
    active       = true
    events       = ["push", "pull_request", "deployment"]
  }
}
```

## Bulk Repository Creation

### Using for_each to Create Multiple Repositories

```hcl
# Define repositories in a map
locals {
  repositories = {
    frontend = {
      description = "Frontend application"
      topics      = ["react", "typescript", "frontend"]
      visibility  = "public"
    }
    backend = {
      description = "Backend API service"
      topics      = ["nodejs", "express", "api"]
      visibility  = "private"
    }
    mobile = {
      description = "Mobile application"
      topics      = ["react-native", "mobile"]
      visibility  = "private"
    }
    docs = {
      description = "Documentation site"
      topics      = ["documentation", "mkdocs"]
      visibility  = "public"
    }
  }
}

# Create all repositories
module "repositories" {
  source   = "./modules/repository"
  for_each = local.repositories
  
  name        = each.key
  description = each.value.description
  visibility  = each.value.visibility
  topics      = concat(var.common_topics, each.value.topics)
  
  enable_branch_protection = true
  enable_dependabot       = true
  enable_auto_updates     = true
  
  branch_protection = {
    pattern          = "main"
    required_reviews = each.value.visibility == "public" ? 2 : 1
  }
  
  dependabot_config = file("${path.module}/templates/dependabot.yml")
  auto_update_workflow = file("${path.module}/templates/workflows/auto-update.yml")
}

# Output all repository URLs
output "repository_urls" {
  value = {
    for k, v in module.repositories : k => v.repository_url
  }
}
```

## Dynamic Branch Protection

### Environment-Specific Protection Rules

```hcl
locals {
  # Define protection rules per environment
  protection_rules = {
    dev = {
      required_reviews        = 0
      enforce_admins          = false
      require_signed_commits  = false
      status_checks           = []
    }
    staging = {
      required_reviews        = 1
      enforce_admins          = false
      require_signed_commits  = false
      status_checks           = ["ci/tests"]
    }
    production = {
      required_reviews        = 2
      enforce_admins          = true
      require_signed_commits  = true
      status_checks           = ["ci/tests", "ci/security", "ci/coverage"]
    }
  }
  
  current_rules = local.protection_rules[var.environment]
}

resource "github_branch_protection" "dynamic" {
  repository_id = github_repository.app.node_id
  pattern       = var.default_branch
  
  required_pull_request_reviews {
    required_approving_review_count = local.current_rules.required_reviews
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = local.current_rules.required_reviews > 0
  }
  
  dynamic "required_status_checks" {
    for_each = length(local.current_rules.status_checks) > 0 ? [1] : []
    content {
      strict   = true
      contexts = local.current_rules.status_checks
    }
  }
  
  enforce_admins         = local.current_rules.enforce_admins
  require_signed_commits = local.current_rules.require_signed_commits
}
```

## Secret Management

### Using External Secret Managers

```hcl
# Read secrets from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "github_secrets" {
  secret_id = "github/repository-secrets"
}

locals {
  secrets = jsondecode(data.aws_secretsmanager_secret_version.github_secrets.secret_string)
}

# Apply secrets to repository
resource "github_actions_secret" "from_aws" {
  for_each = local.secrets
  
  repository      = github_repository.app.name
  secret_name     = each.key
  plaintext_value = each.value
}
```

### Using HashiCorp Vault

```hcl
# Configure Vault provider
provider "vault" {
  address = "https://vault.example.com"
}

# Read secrets from Vault
data "vault_generic_secret" "github" {
  path = "secret/github/repositories"
}

# Apply to repositories
resource "github_actions_secret" "from_vault" {
  for_each = data.vault_generic_secret.github.data
  
  repository      = github_repository.app.name
  secret_name     = each.key
  plaintext_value = each.value
}
```

## Webhook Automation

### Conditional Webhooks with Multiple Endpoints

```hcl
locals {
  webhooks = {
    slack = {
      url    = "https://hooks.slack.com/services/XXX"
      events = ["push", "pull_request", "issues"]
      active = var.enable_slack_notifications
    }
    discord = {
      url    = "https://discord.com/api/webhooks/XXX"
      events = ["push", "release"]
      active = var.enable_discord_notifications
    }
    jenkins = {
      url    = "https://jenkins.example.com/github-webhook/"
      events = ["push", "pull_request"]
      active = var.enable_ci_cd
    }
  }
}

resource "github_repository_webhook" "webhooks" {
  for_each = { for k, v in local.webhooks : k => v if v.active }
  
  repository = github_repository.app.name
  active     = true
  
  configuration {
    url          = each.value.url
    content_type = "json"
    insecure_ssl = false
  }
  
  events = each.value.events
}
```

## Team and Permissions

### Managing Team Access

```hcl
# Create teams
resource "github_team" "developers" {
  name        = "developers"
  description = "Development team"
  privacy     = "closed"
}

resource "github_team" "admins" {
  name        = "admins"
  description = "Admin team"
  privacy     = "closed"
}

# Grant team access to repositories
resource "github_team_repository" "dev_access" {
  team_id    = github_team.developers.id
  repository = github_repository.app.name
  permission = "push"  # pull, push, maintain, admin
}

resource "github_team_repository" "admin_access" {
  team_id    = github_team.admins.id
  repository = github_repository.app.name
  permission = "admin"
}

# Add team members
resource "github_team_membership" "developers" {
  for_each = toset(var.developer_usernames)
  
  team_id  = github_team.developers.id
  username = each.value
  role     = "member"  # member or maintainer
}
```

## Monorepo Support

### Managing Multiple Repositories in Monorepo Structure

```hcl
# repositories.auto.tfvars
repositories = {
  "monorepo/frontend" = {
    description = "Frontend monorepo package"
    path        = "packages/frontend"
  }
  "monorepo/backend" = {
    description = "Backend monorepo package"
    path        = "packages/backend"
  }
  "monorepo/shared" = {
    description = "Shared utilities"
    path        = "packages/shared"
  }
}

# Create repository with monorepo structure
resource "github_repository_file" "monorepo_structure" {
  for_each = var.repositories
  
  repository = github_repository.monorepo.name
  branch     = "main"
  file       = "${each.value.path}/README.md"
  content    = "# ${each.key}\n\n${each.value.description}"
}
```

## GitOps Integration

### ArgoCD/Flux Integration

```hcl
# Create repository for GitOps manifests
module "gitops_repo" {
  source = "./modules/repository"
  
  name        = "gitops-manifests"
  description = "GitOps deployment manifests"
  visibility  = "private"
  
  enable_branch_protection = true
  branch_protection = {
    pattern                         = "main"
    required_reviews                = 2
    require_conversation_resolution = true
    required_status_checks = {
      strict   = true
      contexts = ["validate-manifests", "security-scan"]
    }
  }
  
  topics = ["gitops", "kubernetes", "argocd"]
}

# Add ArgoCD application manifest
resource "github_repository_file" "argocd_app" {
  repository = module.gitops_repo.repository_name
  branch     = "main"
  file       = "apps/my-app.yaml"
  content    = templatefile("${path.module}/templates/argocd-app.yaml", {
    app_name    = "my-app"
    namespace   = var.kubernetes_namespace
    repo_url    = module.app_repo.clone_url
    target_path = "manifests"
  })
}

# Validation workflow
resource "github_repository_file" "validate_workflow" {
  repository = module.gitops_repo.repository_name
  branch     = "main"
  file       = ".github/workflows/validate.yml"
  content    = file("${path.module}/templates/workflows/gitops-validate.yml")
}
```

### Continuous Deployment Pipeline

```hcl
# Production deployment workflow
resource "github_repository_file" "cd_pipeline" {
  repository = github_repository.app.name
  branch     = "main"
  file       = ".github/workflows/deploy.yml"
  content    = templatefile("${path.module}/templates/workflows/deploy.yml", {
    environment        = var.environment
    kubernetes_cluster = var.k8s_cluster_name
    docker_registry    = var.docker_registry
  })
}

# Environment-specific secrets
resource "github_actions_secret" "deployment" {
  for_each = {
    KUBE_CONFIG     = base64encode(var.kubeconfig)
    DOCKER_USERNAME = var.docker_username
    DOCKER_PASSWORD = var.docker_password
    AWS_ACCESS_KEY  = var.aws_access_key
    AWS_SECRET_KEY  = var.aws_secret_key
  }
  
  repository      = github_repository.app.name
  secret_name     = each.key
  plaintext_value = each.value
}
```

## Import Existing Resources

```bash
# Import existing repository
terraform import github_repository.existing my-existing-repo

# Import branch protection
terraform import 'github_branch_protection.existing[0]' my-existing-repo:main

# Import team
terraform import github_team.existing 12345678

# Import team repository access
terraform import github_team_repository.existing 12345678:my-repo

# Import secrets (note: values won't be imported, only metadata)
terraform import github_actions_secret.existing my-repo:SECRET_NAME
```

## State Management

### Remote State with S3

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "github-infra/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

### Terraform Cloud

```hcl
# backend.tf
terraform {
  cloud {
    organization = "my-organization"
    
    workspaces {
      name = "github-infrastructure"
    }
  }
}
```
