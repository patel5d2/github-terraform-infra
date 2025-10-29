variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "github_owner" {
  description = "GitHub username or organization name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  default     = "production"
  
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "default_branch" {
  description = "Default branch name for repositories"
  type        = string
  default     = "main"
}

variable "enable_dependabot" {
  description = "Enable Dependabot for all repositories"
  type        = bool
  default     = true
}

variable "enable_branch_protection" {
  description = "Enable branch protection for all repositories"
  type        = bool
  default     = true
}

variable "required_reviews" {
  description = "Number of required code reviews"
  type        = number
  default     = 1
  
  validation {
    condition     = var.required_reviews >= 0 && var.required_reviews <= 6
    error_message = "Required reviews must be between 0 and 6."
  }
}

variable "common_topics" {
  description = "Common topics to add to repositories"
  type        = list(string)
  default     = ["terraform", "infrastructure-as-code"]
}

variable "vulnerability_alerts" {
  description = "Enable vulnerability alerts for repositories"
  type        = bool
  default     = true
}

variable "repository_defaults" {
  description = "Default settings for repositories"
  type = object({
    visibility               = string
    has_issues              = bool
    has_projects            = bool
    has_wiki                = bool
    has_downloads           = bool
    allow_merge_commit      = bool
    allow_squash_merge      = bool
    allow_rebase_merge      = bool
    delete_branch_on_merge  = bool
    auto_init               = bool
    allow_auto_merge        = bool
  })
  default = {
    visibility               = "private"
    has_issues              = true
    has_projects            = true
    has_wiki                = false
    has_downloads           = true
    allow_merge_commit      = true
    allow_squash_merge      = true
    allow_rebase_merge      = true
    delete_branch_on_merge  = true
    auto_init               = true
    allow_auto_merge        = true
  }
}
