output "repository" {
  description = "Repository details"
  value = {
    id            = github_repository.repo.id
    node_id       = github_repository.repo.node_id
    name          = github_repository.repo.name
    full_name     = github_repository.repo.full_name
    html_url      = github_repository.repo.html_url
    ssh_clone_url = github_repository.repo.ssh_clone_url
    http_clone_url = github_repository.repo.http_clone_url
    git_clone_url = github_repository.repo.git_clone_url
  }
}

output "repository_name" {
  description = "Repository name"
  value       = github_repository.repo.name
}

output "repository_url" {
  description = "Repository URL"
  value       = github_repository.repo.html_url
}

output "clone_url" {
  description = "Clone URL (HTTPS)"
  value       = github_repository.repo.http_clone_url
}

output "ssh_clone_url" {
  description = "Clone URL (SSH)"
  value       = github_repository.repo.ssh_clone_url
}
