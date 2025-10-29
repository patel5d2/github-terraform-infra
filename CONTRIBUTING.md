# Contributing to GitHub Terraform Infrastructure

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## 🎯 Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features
- 📝 Improve documentation
- 🔧 Submit bug fixes
- ✨ Add new features
- 🧪 Add tests
- 📖 Share usage examples

## 🚀 Getting Started

### 1. Fork the Repository

```bash
gh repo fork patel5d2/github-terraform-infra --clone
cd github-terraform-infra
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 3. Make Your Changes

Follow the project structure and coding style.

### 4. Test Your Changes

```bash
# Format Terraform files
terraform fmt -recursive

# Validate configuration
terraform validate

# Run verification
./verify.sh
```

### 5. Commit Your Changes

```bash
git add .
git commit -m "feat: add your feature description"
```

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

### 6. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
gh pr create --fill
```

## 📋 Contribution Guidelines

### Code Style

- **Terraform**: Follow [Terraform style conventions](https://www.terraform.io/docs/language/syntax/style.html)
  - Use 2 spaces for indentation
  - Run `terraform fmt` before committing
  - Add comments for complex logic
  - Use meaningful variable names

- **Shell Scripts**: Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
  - Use `#!/bin/bash` shebang
  - Add error handling with `set -e`
  - Quote variables
  - Add comments for complex sections

- **Markdown**: Follow [Markdown lint rules](https://github.com/DavidAnson/markdownlint)
  - Use ATX-style headers (`#`)
  - Add blank lines around lists
  - Use fenced code blocks with language identifiers

### Documentation

- Update relevant documentation for any changes
- Add examples for new features
- Update README.md if adding major features
- Keep documentation concise and clear
- Include code examples where appropriate

### Testing

Before submitting:

```bash
# Format all Terraform files
make fmt

# Validate configuration
make validate

# Run verification
./verify.sh

# Test in isolated environment if possible
terraform plan
```

### Pull Request Process

1. **Update Documentation**: Ensure all docs are updated
2. **Add Examples**: Include usage examples for new features
3. **Test Thoroughly**: Test your changes
4. **Clear Description**: Explain what and why
5. **Link Issues**: Reference related issues
6. **Be Responsive**: Address review comments promptly

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Breaking change

## Testing
- [ ] Tested locally
- [ ] terraform fmt run
- [ ] terraform validate passed
- [ ] Documentation updated

## Related Issues
Fixes #(issue number)
```

## 🏗️ Project Structure

### Adding a New Feature

1. **Terraform Files**: Add to appropriate `.tf` file
2. **Module**: If reusable, create in `modules/`
3. **Template**: If workflow/config, add to `templates/`
4. **Documentation**: Update relevant `.md` files
5. **Example**: Add to `EXAMPLES.md`

### File Organization

```
github-terraform-infra/
├── *.tf                  # Core Terraform files
├── modules/              # Reusable modules
├── templates/            # GitHub config templates
├── environments/         # Environment configs
├── *.md                  # Documentation
└── *.sh                  # Automation scripts
```

## 🐛 Reporting Bugs

### Before Submitting

- Check existing issues
- Search discussions
- Review documentation
- Reproduce with minimal config

### Bug Report Template

```markdown
## Bug Description
Clear description of the bug

## Steps to Reproduce
1. Step one
2. Step two
3. ...

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- OS: [e.g., macOS 14.0]
- Terraform version: [e.g., 1.6.0]
- Provider version: [e.g., github 6.0]

## Additional Context
Any other relevant information
```

## 💡 Feature Requests

### Feature Request Template

```markdown
## Feature Description
Clear description of the feature

## Use Case
Why is this needed?

## Proposed Solution
How should it work?

## Alternatives Considered
Other approaches you've considered

## Additional Context
Any other relevant information
```

## 🔒 Security

### Reporting Security Issues

**DO NOT** open public issues for security vulnerabilities.

Instead:
1. Email: [your-email] (if you want to add)
2. Use GitHub Security Advisories
3. Provide detailed description
4. Include steps to reproduce

### Security Best Practices

- Never commit secrets or tokens
- Use `.gitignore` for sensitive files
- Validate user inputs
- Follow principle of least privilege
- Keep dependencies updated

## 📝 Code of Conduct

### Our Standards

- **Be Respectful**: Treat everyone with respect
- **Be Constructive**: Provide helpful feedback
- **Be Patient**: Remember everyone was a beginner once
- **Be Inclusive**: Welcome diverse perspectives
- **Be Professional**: Keep discussions on-topic

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information
- Other unprofessional conduct

## 🎓 Development Setup

### Prerequisites

```bash
# Install Terraform
brew install terraform

# Install GitHub CLI
brew install gh

# Authenticate with GitHub
gh auth login
```

### Local Development

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/github-terraform-infra.git
cd github-terraform-infra

# Set up git remote
git remote add upstream https://github.com/patel5d2/github-terraform-infra.git

# Create branch
git checkout -b feature/my-feature

# Make changes and test
terraform init
terraform fmt
terraform validate

# Commit and push
git add .
git commit -m "feat: my feature"
git push origin feature/my-feature
```

### Keeping Your Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Merge upstream main into your main
git checkout main
git merge upstream/main

# Push to your fork
git push origin main
```

## 🧪 Testing Guidelines

### Manual Testing

```bash
# Initialize
terraform init

# Plan changes
terraform plan

# Validate
terraform validate

# Format
terraform fmt -check
```

### Testing Checklist

- [ ] Terraform fmt passed
- [ ] Terraform validate passed
- [ ] No sensitive data in code
- [ ] Documentation updated
- [ ] Examples added/updated
- [ ] Works in isolated environment

## 📚 Resources

### Terraform

- [Terraform Documentation](https://www.terraform.io/docs)
- [GitHub Provider Docs](https://registry.terraform.io/providers/integrations/github/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

### GitHub

- [GitHub API](https://docs.github.com/en/rest)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Dependabot](https://docs.github.com/en/code-security/dependabot)

### Development Tools

- [GitHub CLI](https://cli.github.com/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Terraform Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)

## 🏆 Recognition

Contributors will be:
- Listed in release notes
- Acknowledged in documentation
- Added to contributors list

## 📞 Getting Help

- 💬 [Discussions](https://github.com/patel5d2/github-terraform-infra/discussions)
- 🐛 [Issues](https://github.com/patel5d2/github-terraform-infra/issues)
- 📖 [Documentation](README.md)

## ✅ Checklist for Contributors

Before submitting a PR:

- [ ] Code follows project style
- [ ] Terraform formatted (`terraform fmt`)
- [ ] Configuration validated (`terraform validate`)
- [ ] Documentation updated
- [ ] Examples added (if applicable)
- [ ] Tested locally
- [ ] Commit messages follow conventions
- [ ] PR description is clear
- [ ] No sensitive data included

## 🙏 Thank You!

Your contributions make this project better for everyone. We appreciate your time and effort!

---

**Questions?** Open a [discussion](https://github.com/patel5d2/github-terraform-infra/discussions) or [issue](https://github.com/patel5d2/github-terraform-infra/issues).

Happy Contributing! 🚀
