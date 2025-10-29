# ==============================================================================
# Repository Secrets
# ==============================================================================

# Example secrets for n8n repository
# NOTE: In production, use terraform.tfvars or environment variables
# Never commit actual secret values to version control

variable "n8n_secrets" {
  description = "Secrets for n8n repository"
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "glance_secrets" {
  description = "Secrets for Glance repository"
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "boilerplate_secrets" {
  description = "Secrets for Boilerplate repository"
  type        = map(string)
  sensitive   = true
  default     = {}
}

# n8n repository secrets
resource "github_actions_secret" "n8n_secrets" {
  for_each = var.n8n_secrets

  repository      = github_repository.n8n.name
  secret_name     = each.key
  plaintext_value = each.value
}

# Glance repository secrets
resource "github_actions_secret" "glance_secrets" {
  for_each = var.glance_secrets

  repository      = github_repository.glance.name
  secret_name     = each.key
  plaintext_value = each.value
}

# Boilerplate repository secrets
resource "github_actions_secret" "boilerplate_secrets" {
  for_each = var.boilerplate_secrets

  repository      = github_repository.boilerplate.name
  secret_name     = each.key
  plaintext_value = each.value
}

# ==============================================================================
# Common Secrets (applied to all repositories)
# ==============================================================================

variable "common_secrets" {
  description = "Common secrets to apply to all repositories"
  type        = map(string)
  sensitive   = true
  default     = {}
  # Example:
  # {
  #   "DOCKER_USERNAME" = "myusername"
  #   "DOCKER_PASSWORD" = "mypassword"
  #   "SLACK_WEBHOOK"   = "https://hooks.slack.com/..."
  # }
}

# Apply common secrets to n8n
resource "github_actions_secret" "n8n_common" {
  for_each = var.common_secrets

  repository      = github_repository.n8n.name
  secret_name     = each.key
  plaintext_value = each.value
}

# Apply common secrets to Glance
resource "github_actions_secret" "glance_common" {
  for_each = var.common_secrets

  repository      = github_repository.glance.name
  secret_name     = each.key
  plaintext_value = each.value
}

# Apply common secrets to Boilerplate
resource "github_actions_secret" "boilerplate_common" {
  for_each = var.common_secrets

  repository      = github_repository.boilerplate.name
  secret_name     = each.key
  plaintext_value = each.value
}

# ==============================================================================
# Repository Variables (Non-sensitive configuration)
# ==============================================================================

variable "n8n_variables" {
  description = "Non-sensitive variables for n8n repository"
  type        = map(string)
  default     = {}
}

variable "glance_variables" {
  description = "Non-sensitive variables for Glance repository"
  type        = map(string)
  default     = {}
}

variable "boilerplate_variables" {
  description = "Non-sensitive variables for Boilerplate repository"
  type        = map(string)
  default     = {}
}

# n8n repository variables
resource "github_actions_variable" "n8n_vars" {
  for_each = var.n8n_variables

  repository    = github_repository.n8n.name
  variable_name = each.key
  value         = each.value
}

# Glance repository variables
resource "github_actions_variable" "glance_vars" {
  for_each = var.glance_variables

  repository    = github_repository.glance.name
  variable_name = each.key
  value         = each.value
}

# Boilerplate repository variables
resource "github_actions_variable" "boilerplate_vars" {
  for_each = var.boilerplate_variables

  repository    = github_repository.boilerplate.name
  variable_name = each.key
  value         = each.value
}
