output "repositories" {
  description = "Map of created repositories"
  value = {
    for k, v in merge(
      { for repo in [github_repository.n8n] : repo.name => {
        full_name     = repo.full_name
        html_url      = repo.html_url
        ssh_clone_url = repo.ssh_clone_url
        http_clone_url = repo.http_clone_url
      }},
      { for repo in [github_repository.glance] : repo.name => {
        full_name     = repo.full_name
        html_url      = repo.html_url
        ssh_clone_url = repo.ssh_clone_url
        http_clone_url = repo.http_clone_url
      }},
      { for repo in [github_repository.boilerplate] : repo.name => {
        full_name     = repo.full_name
        html_url      = repo.html_url
        ssh_clone_url = repo.ssh_clone_url
        http_clone_url = repo.http_clone_url
      }}
    ) : k => v
  }
}

output "branch_protection_rules" {
  description = "Branch protection rules applied"
  value = {
    n8n         = var.enable_branch_protection ? "enabled" : "disabled"
    glance      = var.enable_branch_protection ? "enabled" : "disabled"
    boilerplate = var.enable_branch_protection ? "enabled" : "disabled"
  }
}

output "dependabot_status" {
  description = "Dependabot configuration status"
  value = {
    enabled      = var.enable_dependabot
    repositories = ["n8n", "glance", "boilerplate"]
  }
}

output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "repository_urls" {
  description = "Quick access URLs for repositories"
  value = {
    n8n         = "https://github.com/${var.github_owner}/n8n"
    glance      = "https://github.com/${var.github_owner}/glance"
    boilerplate = "https://github.com/${var.github_owner}/boilerplate"
  }
}
