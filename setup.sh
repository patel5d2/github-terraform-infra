#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}==================================${NC}"
echo -e "${GREEN}GitHub Terraform Infrastructure${NC}"
echo -e "${GREEN}Setup Script${NC}"
echo -e "${GREEN}==================================${NC}"
echo ""

# Check for required tools
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command -v terraform &> /dev/null; then
    echo -e "${RED}Error: Terraform is not installed${NC}"
    echo "Please install Terraform from https://www.terraform.io/downloads"
    exit 1
fi

if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}Warning: GitHub CLI (gh) is not installed${NC}"
    echo "Some features may be limited. Install from https://cli.github.com/"
fi

echo -e "${GREEN}✓ Terraform found: $(terraform version -json | grep -o '"terraform_version":"[^"]*' | cut -d'"' -f4)${NC}"

# Check for GitHub token
echo ""
echo -e "${YELLOW}Checking GitHub authentication...${NC}"

if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${YELLOW}GITHUB_TOKEN environment variable not set${NC}"
    read -sp "Please enter your GitHub Personal Access Token: " TOKEN
    echo ""
    export GITHUB_TOKEN="$TOKEN"
fi

# Validate token
if curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep -q "login"; then
    USERNAME=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep -o '"login":"[^"]*' | cut -d'"' -f4)
    echo -e "${GREEN}✓ Authenticated as: $USERNAME${NC}"
else
    echo -e "${RED}Error: Invalid GitHub token${NC}"
    exit 1
fi

# Prompt for GitHub owner if not set
echo ""
if [ -z "$GITHUB_OWNER" ]; then
    read -p "Enter GitHub username or organization name [$USERNAME]: " OWNER
    export GITHUB_OWNER="${OWNER:-$USERNAME}"
else
    echo -e "${GREEN}Using GITHUB_OWNER: $GITHUB_OWNER${NC}"
fi

# Create terraform.tfvars if it doesn't exist
echo ""
echo -e "${YELLOW}Setting up configuration...${NC}"

if [ ! -f "terraform.tfvars" ]; then
    echo -e "${YELLOW}Creating terraform.tfvars from example...${NC}"
    cp terraform.tfvars.example terraform.tfvars
    
    # Update github_owner in terraform.tfvars
    if command -v sed &> /dev/null; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/your-github-username-or-org/$GITHUB_OWNER/" terraform.tfvars
        else
            sed -i "s/your-github-username-or-org/$GITHUB_OWNER/" terraform.tfvars
        fi
    fi
    
    echo -e "${GREEN}✓ Created terraform.tfvars${NC}"
    echo -e "${YELLOW}Please review and update terraform.tfvars with your settings${NC}"
else
    echo -e "${GREEN}✓ terraform.tfvars already exists${NC}"
fi

# Initialize Terraform
echo ""
echo -e "${YELLOW}Initializing Terraform...${NC}"
terraform init

echo ""
echo -e "${GREEN}==================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}==================================${NC}"
echo ""
echo "Next steps:"
echo "1. Review and update terraform.tfvars"
echo "2. Run 'terraform plan' to preview changes"
echo "3. Run 'terraform apply' to create resources"
echo ""
echo "Environment variables set:"
echo "  GITHUB_OWNER=$GITHUB_OWNER"
echo ""
echo -e "${YELLOW}To persist these settings, add to your shell profile:${NC}"
echo "  export GITHUB_TOKEN=\"your-token\""
echo "  export GITHUB_OWNER=\"$GITHUB_OWNER\""
