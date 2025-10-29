# ==============================================================================
# Repository Webhooks
# ==============================================================================

variable "webhook_url" {
  description = "Webhook URL for repository events"
  type        = string
  default     = ""
}

variable "webhook_secret" {
  description = "Secret for webhook authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "enable_webhooks" {
  description = "Enable webhooks for repositories"
  type        = bool
  default     = false
}

# Webhook for n8n repository
resource "github_repository_webhook" "n8n_webhook" {
  count = var.enable_webhooks && var.webhook_url != "" ? 1 : 0

  repository = github_repository.n8n.name
  active     = true

  configuration {
    url          = var.webhook_url
    content_type = "json"
    secret       = var.webhook_secret
    insecure_ssl = false
  }

  events = [
    "push",
    "pull_request",
    "pull_request_review",
    "issues",
    "issue_comment",
    "deployment",
    "deployment_status",
    "release",
    "workflow_run"
  ]
}

# Webhook for Glance repository
resource "github_repository_webhook" "glance_webhook" {
  count = var.enable_webhooks && var.webhook_url != "" ? 1 : 0

  repository = github_repository.glance.name
  active     = true

  configuration {
    url          = var.webhook_url
    content_type = "json"
    secret       = var.webhook_secret
    insecure_ssl = false
  }

  events = [
    "push",
    "pull_request",
    "pull_request_review",
    "issues",
    "issue_comment",
    "deployment",
    "deployment_status",
    "release",
    "workflow_run"
  ]
}

# Webhook for Boilerplate repository
resource "github_repository_webhook" "boilerplate_webhook" {
  count = var.enable_webhooks && var.webhook_url != "" ? 1 : 0

  repository = github_repository.boilerplate.name
  active     = true

  configuration {
    url          = var.webhook_url
    content_type = "json"
    secret       = var.webhook_secret
    insecure_ssl = false
  }

  events = [
    "push",
    "pull_request",
    "pull_request_review",
    "issues",
    "issue_comment",
    "deployment",
    "deployment_status",
    "release",
    "workflow_run"
  ]
}

# ==============================================================================
# Webhook Output
# ==============================================================================

output "webhook_status" {
  description = "Status of configured webhooks"
  value = {
    enabled      = var.enable_webhooks
    webhook_url  = var.enable_webhooks ? var.webhook_url : "not configured"
    repositories = var.enable_webhooks ? ["n8n", "glance", "boilerplate"] : []
  }
}
