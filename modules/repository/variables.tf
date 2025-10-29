variable "name" {
  description = "Repository name"
  type        = string
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Repository visibility (public, private, internal)"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Visibility must be public, private, or internal."
  }
}

variable "has_issues" {
  description = "Enable issues"
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Enable projects"
  type        = bool
  default     = true
}

variable "has_wiki" {
  description = "Enable wiki"
  type        = bool
  default     = false
}

variable "has_downloads" {
  description = "Enable downloads"
  type        = bool
  default     = true
}

variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Allow squash merges"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merges"
  type        = bool
  default     = true
}

variable "delete_branch_on_merge" {
  description = "Delete branch on merge"
  type        = bool
  default     = true
}

variable "allow_auto_merge" {
  description = "Allow auto-merge"
  type        = bool
  default     = true
}

variable "auto_init" {
  description = "Initialize repository with README"
  type        = bool
  default     = true
}

variable "is_template" {
  description = "Make this a template repository"
  type        = bool
  default     = false
}

variable "vulnerability_alerts" {
  description = "Enable vulnerability alerts"
  type        = bool
  default     = true
}

variable "topics" {
  description = "Repository topics"
  type        = list(string)
  default     = []
}

variable "template" {
  description = "Template repository configuration"
  type = object({
    owner                = string
    repository           = string
    include_all_branches = optional(bool, false)
  })
  default = null
}

variable "homepage_url" {
  description = "Repository homepage URL"
  type        = string
  default     = ""
}

variable "archive_on_destroy" {
  description = "Archive repository on destroy instead of deleting"
  type        = bool
  default     = true
}

variable "default_branch" {
  description = "Default branch name"
  type        = string
  default     = "main"
}

variable "enable_branch_protection" {
  description = "Enable branch protection"
  type        = bool
  default     = true
}

variable "branch_protection" {
  description = "Branch protection configuration"
  type = object({
    pattern                         = string
    required_reviews                = number
    dismiss_stale_reviews           = optional(bool, true)
    require_code_owner_reviews      = optional(bool, true)
    require_last_push_approval      = optional(bool, true)
    enforce_admins                  = optional(bool, false)
    allows_deletions                = optional(bool, false)
    allows_force_pushes             = optional(bool, false)
    require_conversation_resolution = optional(bool, true)
    require_signed_commits          = optional(bool, false)
    required_linear_history         = optional(bool, false)
    required_status_checks = optional(object({
      strict   = bool
      contexts = list(string)
    }), null)
  })
  default = {
    pattern          = "main"
    required_reviews = 1
  }
}

variable "enable_dependabot" {
  description = "Enable Dependabot configuration"
  type        = bool
  default     = true
}

variable "dependabot_config" {
  description = "Dependabot configuration content"
  type        = string
  default     = ""
}

variable "enable_auto_updates" {
  description = "Enable auto-update workflow"
  type        = bool
  default     = true
}

variable "auto_update_workflow" {
  description = "Auto-update workflow content"
  type        = string
  default     = ""
}

variable "codeowners" {
  description = "CODEOWNERS file content"
  type        = string
  default     = ""
}

variable "secrets" {
  description = "Repository secrets"
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "variables" {
  description = "Repository variables"
  type        = map(string)
  default     = {}
}

variable "webhook" {
  description = "Webhook configuration"
  type = object({
    url          = string
    content_type = string
    secret       = string
    insecure_ssl = bool
    active       = bool
    events       = list(string)
  })
  default = null
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
