#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}Terraform Configuration Verification${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check files
echo -e "${YELLOW}Checking required files...${NC}"

required_files=(
    "main.tf"
    "variables.tf"
    "outputs.tf"
    "repositories.tf"
    "branch-protection.tf"
    "secrets.tf"
    "webhooks.tf"
    "README.md"
    "QUICKSTART.md"
    "setup.sh"
    "deploy.sh"
    "Makefile"
    ".gitignore"
    "terraform.tfvars.example"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file"
        missing_files+=("$file")
    fi
done

echo ""

# Check directories
echo -e "${YELLOW}Checking directories...${NC}"

required_dirs=(
    "modules/repository"
    "templates/workflows"
    "environments/dev"
    "environments/staging"
    "environments/production"
)

missing_dirs=()
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $dir/"
    else
        echo -e "${RED}✗${NC} $dir/"
        missing_dirs+=("$dir")
    fi
done

echo ""

# Check templates
echo -e "${YELLOW}Checking template files...${NC}"

if [ -f "templates/dependabot.yml" ]; then
    echo -e "${GREEN}✓${NC} templates/dependabot.yml"
else
    echo -e "${RED}✗${NC} templates/dependabot.yml"
fi

if [ -f "templates/workflows/auto-update.yml" ]; then
    echo -e "${GREEN}✓${NC} templates/workflows/auto-update.yml"
else
    echo -e "${RED}✗${NC} templates/workflows/auto-update.yml"
fi

echo ""

# Check executables
echo -e "${YELLOW}Checking executable permissions...${NC}"

if [ -x "setup.sh" ]; then
    echo -e "${GREEN}✓${NC} setup.sh is executable"
else
    echo -e "${YELLOW}!${NC} setup.sh is not executable (run: chmod +x setup.sh)"
fi

if [ -x "deploy.sh" ]; then
    echo -e "${GREEN}✓${NC} deploy.sh is executable"
else
    echo -e "${YELLOW}!${NC} deploy.sh is not executable (run: chmod +x deploy.sh)"
fi

echo ""

# Terraform validation
echo -e "${YELLOW}Checking Terraform...${NC}"

if command -v terraform &> /dev/null; then
    echo -e "${GREEN}✓${NC} Terraform installed: $(terraform version -json 2>/dev/null | grep -o '"terraform_version":"[^"]*' | cut -d'"' -f4)"
else
    echo -e "${RED}✗${NC} Terraform not installed"
fi

echo ""

# Summary
echo -e "${BLUE}=====================================${NC}"
if [ ${#missing_files[@]} -eq 0 ] && [ ${#missing_dirs[@]} -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo -e "${GREEN}Your Terraform infrastructure is ready to use!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Run: ./setup.sh"
    echo "2. Edit: terraform.tfvars"
    echo "3. Deploy: make apply"
else
    echo -e "${YELLOW}! Some files or directories are missing${NC}"
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        echo ""
        echo "Missing files:"
        for file in "${missing_files[@]}"; do
            echo "  - $file"
        done
    fi
    
    if [ ${#missing_dirs[@]} -gt 0 ]; then
        echo ""
        echo "Missing directories:"
        for dir in "${missing_dirs[@]}"; do
            echo "  - $dir/"
        done
    fi
fi
echo -e "${BLUE}=====================================${NC}"
