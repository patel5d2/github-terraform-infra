# ==============================================================================
# Reusable Repository Module
# ==============================================================================

resource "github_repository" "repo" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  has_issues    = var.has_issues
  has_projects  = var.has_projects
  has_wiki      = var.has_wiki
  has_downloads = var.has_downloads

  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  allow_auto_merge       = var.allow_auto_merge

  auto_init            = var.auto_init
  is_template          = var.is_template
  vulnerability_alerts = var.vulnerability_alerts

  topics = var.topics

  dynamic "template" {
    for_each = var.template != null ? [var.template] : []
    content {
      owner                = template.value.owner
      repository           = template.value.repository
      include_all_branches = lookup(template.value, "include_all_branches", false)
    }
  }

  homepage_url = var.homepage_url
  archive_on_destroy = var.archive_on_destroy
}

# Branch Protection
resource "github_branch_protection" "main" {
  count = var.enable_branch_protection ? 1 : 0

  repository_id = github_repository.repo.node_id
  pattern       = var.branch_protection.pattern

  dynamic "required_pull_request_reviews" {
    for_each = var.branch_protection.required_reviews > 0 ? [1] : []
    content {
      dismiss_stale_reviews           = var.branch_protection.dismiss_stale_reviews
      require_code_owner_reviews      = var.branch_protection.require_code_owner_reviews
      required_approving_review_count = var.branch_protection.required_reviews
      require_last_push_approval      = var.branch_protection.require_last_push_approval
    }
  }

  dynamic "required_status_checks" {
    for_each = var.branch_protection.required_status_checks != null ? [1] : []
    content {
      strict   = var.branch_protection.required_status_checks.strict
      contexts = var.branch_protection.required_status_checks.contexts
    }
  }

  enforce_admins                  = var.branch_protection.enforce_admins
  allows_deletions                = var.branch_protection.allows_deletions
  allows_force_pushes             = var.branch_protection.allows_force_pushes
  require_conversation_resolution = var.branch_protection.require_conversation_resolution
  require_signed_commits          = var.branch_protection.require_signed_commits
  required_linear_history         = var.branch_protection.required_linear_history
}

# Dependabot Configuration
resource "github_repository_file" "dependabot" {
  count = var.enable_dependabot ? 1 : 0

  repository          = github_repository.repo.name
  branch              = var.default_branch
  file                = ".github/dependabot.yml"
  content             = var.dependabot_config
  commit_message      = "chore: add Dependabot configuration"
  overwrite_on_create = true
}

# Auto-update Workflow
resource "github_repository_file" "auto_update" {
  count = var.enable_auto_updates ? 1 : 0

  repository          = github_repository.repo.name
  branch              = var.default_branch
  file                = ".github/workflows/auto-update.yml"
  content             = var.auto_update_workflow
  commit_message      = "ci: add auto-update workflow"
  overwrite_on_create = true
}

# CODEOWNERS
resource "github_repository_file" "codeowners" {
  count = var.enable_branch_protection && var.codeowners != "" ? 1 : 0

  repository          = github_repository.repo.name
  branch              = var.default_branch
  file                = ".github/CODEOWNERS"
  content             = var.codeowners
  commit_message      = "chore: add CODEOWNERS file"
  overwrite_on_create = true
}

# Secrets
resource "github_actions_secret" "secrets" {
  for_each = var.secrets

  repository      = github_repository.repo.name
  secret_name     = each.key
  plaintext_value = each.value
}

# Variables
resource "github_actions_variable" "variables" {
  for_each = var.variables

  repository    = github_repository.repo.name
  variable_name = each.key
  value         = each.value
}

# Webhooks
resource "github_repository_webhook" "webhook" {
  count = var.webhook != null ? 1 : 0

  repository = github_repository.repo.name
  active     = var.webhook.active

  configuration {
    url          = var.webhook.url
    content_type = var.webhook.content_type
    secret       = var.webhook.secret
    insecure_ssl = var.webhook.insecure_ssl
  }

  events = var.webhook.events
}
