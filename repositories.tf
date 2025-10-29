# ==============================================================================
# Repository: n8n (Workflow Automation)
# ==============================================================================

resource "github_repository" "n8n" {
  name        = "n8n"
  description = "n8n workflow automation - ${var.environment} environment"
  visibility  = var.repository_defaults.visibility

  has_issues             = var.repository_defaults.has_issues
  has_projects           = var.repository_defaults.has_projects
  has_wiki               = var.repository_defaults.has_wiki
  has_downloads          = var.repository_defaults.has_downloads
  
  allow_merge_commit     = var.repository_defaults.allow_merge_commit
  allow_squash_merge     = var.repository_defaults.allow_squash_merge
  allow_rebase_merge     = var.repository_defaults.allow_rebase_merge
  delete_branch_on_merge = var.repository_defaults.delete_branch_on_merge
  allow_auto_merge       = var.repository_defaults.allow_auto_merge

  auto_init              = var.repository_defaults.auto_init
  
  vulnerability_alerts   = var.vulnerability_alerts

  topics = concat(var.common_topics, [
    "n8n",
    "workflow-automation",
    "automation",
    var.environment
  ])

  template {
    owner      = "n8n-io"
    repository = "n8n"
    include_all_branches = false
  }
}

# ==============================================================================
# Repository: Glance (Dashboard)
# ==============================================================================

resource "github_repository" "glance" {
  name        = "glance"
  description = "Glance dashboard application - ${var.environment} environment"
  visibility  = var.repository_defaults.visibility

  has_issues             = var.repository_defaults.has_issues
  has_projects           = var.repository_defaults.has_projects
  has_wiki               = var.repository_defaults.has_wiki
  has_downloads          = var.repository_defaults.has_downloads
  
  allow_merge_commit     = var.repository_defaults.allow_merge_commit
  allow_squash_merge     = var.repository_defaults.allow_squash_merge
  allow_rebase_merge     = var.repository_defaults.allow_rebase_merge
  delete_branch_on_merge = var.repository_defaults.delete_branch_on_merge
  allow_auto_merge       = var.repository_defaults.allow_auto_merge

  auto_init              = var.repository_defaults.auto_init
  
  vulnerability_alerts   = var.vulnerability_alerts

  topics = concat(var.common_topics, [
    "glance",
    "dashboard",
    "monitoring",
    var.environment
  ])

  # Remove or modify template block if you're not using a template
  # template {
  #   owner      = "template-owner"
  #   repository = "template-repo"
  # }
}

# ==============================================================================
# Repository: Boilerplate (Project Template)
# ==============================================================================

resource "github_repository" "boilerplate" {
  name        = "boilerplate"
  description = "Project boilerplate template - ${var.environment} environment"
  visibility  = var.repository_defaults.visibility

  has_issues             = var.repository_defaults.has_issues
  has_projects           = var.repository_defaults.has_projects
  has_wiki               = var.repository_defaults.has_wiki
  has_downloads          = var.repository_defaults.has_downloads
  
  allow_merge_commit     = var.repository_defaults.allow_merge_commit
  allow_squash_merge     = var.repository_defaults.allow_squash_merge
  allow_rebase_merge     = var.repository_defaults.allow_rebase_merge
  delete_branch_on_merge = var.repository_defaults.delete_branch_on_merge
  allow_auto_merge       = var.repository_defaults.allow_auto_merge

  auto_init              = var.repository_defaults.auto_init
  is_template            = true  # This repository can be used as a template
  
  vulnerability_alerts   = var.vulnerability_alerts

  topics = concat(var.common_topics, [
    "boilerplate",
    "template",
    "starter",
    var.environment
  ])
}

# ==============================================================================
# Dependabot Configuration Files
# ==============================================================================

# Dependabot configuration for n8n
resource "github_repository_file" "n8n_dependabot" {
  count = var.enable_dependabot ? 1 : 0
  
  repository          = github_repository.n8n.name
  branch              = var.default_branch
  file                = ".github/dependabot.yml"
  content             = file("${path.module}/templates/dependabot.yml")
  commit_message      = "chore: add Dependabot configuration"
  overwrite_on_create = true

  depends_on = [github_repository.n8n]
}

# Dependabot configuration for Glance
resource "github_repository_file" "glance_dependabot" {
  count = var.enable_dependabot ? 1 : 0
  
  repository          = github_repository.glance.name
  branch              = var.default_branch
  file                = ".github/dependabot.yml"
  content             = file("${path.module}/templates/dependabot.yml")
  commit_message      = "chore: add Dependabot configuration"
  overwrite_on_create = true

  depends_on = [github_repository.glance]
}

# Dependabot configuration for Boilerplate
resource "github_repository_file" "boilerplate_dependabot" {
  count = var.enable_dependabot ? 1 : 0
  
  repository          = github_repository.boilerplate.name
  branch              = var.default_branch
  file                = ".github/dependabot.yml"
  content             = file("${path.module}/templates/dependabot.yml")
  commit_message      = "chore: add Dependabot configuration"
  overwrite_on_create = true

  depends_on = [github_repository.boilerplate]
}

# ==============================================================================
# Auto-Update GitHub Actions Workflow
# ==============================================================================

# Auto-update workflow for n8n
resource "github_repository_file" "n8n_auto_update" {
  count = var.enable_dependabot ? 1 : 0
  
  repository          = github_repository.n8n.name
  branch              = var.default_branch
  file                = ".github/workflows/auto-update.yml"
  content             = file("${path.module}/templates/workflows/auto-update.yml")
  commit_message      = "ci: add auto-update workflow"
  overwrite_on_create = true

  depends_on = [github_repository.n8n]
}

# Auto-update workflow for Glance
resource "github_repository_file" "glance_auto_update" {
  count = var.enable_dependabot ? 1 : 0
  
  repository          = github_repository.glance.name
  branch              = var.default_branch
  file                = ".github/workflows/auto-update.yml"
  content             = file("${path.module}/templates/workflows/auto-update.yml")
  commit_message      = "ci: add auto-update workflow"
  overwrite_on_create = true

  depends_on = [github_repository.glance]
}

# Auto-update workflow for Boilerplate
resource "github_repository_file" "boilerplate_auto_update" {
  count = var.enable_dependabot ? 1 : 0
  
  repository          = github_repository.boilerplate.name
  branch              = var.default_branch
  file                = ".github/workflows/auto-update.yml"
  content             = file("${path.module}/templates/workflows/auto-update.yml")
  commit_message      = "ci: add auto-update workflow"
  overwrite_on_create = true

  depends_on = [github_repository.boilerplate]
}
