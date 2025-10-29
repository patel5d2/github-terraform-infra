# ==============================================================================
# Branch Protection Rules
# ==============================================================================

# Branch protection for n8n
resource "github_branch_protection" "n8n_main" {
  count = var.enable_branch_protection ? 1 : 0

  repository_id = github_repository.n8n.node_id
  pattern       = var.default_branch

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = var.required_reviews
    require_last_push_approval      = true
  }

  required_status_checks {
    strict   = true
    contexts = []  # Add specific check names like ["ci/tests", "ci/lint"]
  }

  enforce_admins = false  # Set to true for stricter enforcement
  
  allows_deletions                = false
  allows_force_pushes             = false
  require_conversation_resolution = true
  require_signed_commits          = false  # Enable if using commit signing
  required_linear_history         = false

  depends_on = [github_repository.n8n]
}

# Branch protection for Glance
resource "github_branch_protection" "glance_main" {
  count = var.enable_branch_protection ? 1 : 0

  repository_id = github_repository.glance.node_id
  pattern       = var.default_branch

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = var.required_reviews
    require_last_push_approval      = true
  }

  required_status_checks {
    strict   = true
    contexts = []
  }

  enforce_admins = false
  
  allows_deletions                = false
  allows_force_pushes             = false
  require_conversation_resolution = true
  require_signed_commits          = false
  required_linear_history         = false

  depends_on = [github_repository.glance]
}

# Branch protection for Boilerplate
resource "github_branch_protection" "boilerplate_main" {
  count = var.enable_branch_protection ? 1 : 0

  repository_id = github_repository.boilerplate.node_id
  pattern       = var.default_branch

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = var.required_reviews
    require_last_push_approval      = true
  }

  required_status_checks {
    strict   = true
    contexts = []
  }

  enforce_admins = false
  
  allows_deletions                = false
  allows_force_pushes             = false
  require_conversation_resolution = true
  require_signed_commits          = false
  required_linear_history         = false

  depends_on = [github_repository.boilerplate]
}

# ==============================================================================
# CODEOWNERS File
# ==============================================================================

# CODEOWNERS for n8n
resource "github_repository_file" "n8n_codeowners" {
  count = var.enable_branch_protection ? 1 : 0
  
  repository          = github_repository.n8n.name
  branch              = var.default_branch
  file                = ".github/CODEOWNERS"
  content             = <<-EOT
    # Default code owners for entire repository
    * @${var.github_owner}
    
    # Workflows and CI/CD
    .github/ @${var.github_owner}
    
    # Infrastructure and configuration
    *.tf @${var.github_owner}
    *.yml @${var.github_owner}
    *.yaml @${var.github_owner}
  EOT
  commit_message      = "chore: add CODEOWNERS file"
  overwrite_on_create = true

  depends_on = [github_repository.n8n]
}

# CODEOWNERS for Glance
resource "github_repository_file" "glance_codeowners" {
  count = var.enable_branch_protection ? 1 : 0
  
  repository          = github_repository.glance.name
  branch              = var.default_branch
  file                = ".github/CODEOWNERS"
  content             = <<-EOT
    # Default code owners for entire repository
    * @${var.github_owner}
    
    # Workflows and CI/CD
    .github/ @${var.github_owner}
    
    # Infrastructure and configuration
    *.tf @${var.github_owner}
    *.yml @${var.github_owner}
    *.yaml @${var.github_owner}
  EOT
  commit_message      = "chore: add CODEOWNERS file"
  overwrite_on_create = true

  depends_on = [github_repository.glance]
}

# CODEOWNERS for Boilerplate
resource "github_repository_file" "boilerplate_codeowners" {
  count = var.enable_branch_protection ? 1 : 0
  
  repository          = github_repository.boilerplate.name
  branch              = var.default_branch
  file                = ".github/CODEOWNERS"
  content             = <<-EOT
    # Default code owners for entire repository
    * @${var.github_owner}
    
    # Workflows and CI/CD
    .github/ @${var.github_owner}
    
    # Infrastructure and configuration
    *.tf @${var.github_owner}
    *.yml @${var.github_owner}
    *.yaml @${var.github_owner}
  EOT
  commit_message      = "chore: add CODEOWNERS file"
  overwrite_on_create = true

  depends_on = [github_repository.boilerplate]
}
