#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================${NC}"
echo -e "${BLUE}Terraform Deployment Script${NC}"
echo -e "${BLUE}==================================${NC}"
echo ""

# Function to check prerequisites
check_prerequisites() {
    echo -e "${YELLOW}Checking prerequisites...${NC}"
    
    if ! command -v terraform &> /dev/null; then
        echo -e "${RED}Error: Terraform is not installed${NC}"
        exit 1
    fi
    
    if [ -z "$GITHUB_TOKEN" ]; then
        echo -e "${RED}Error: GITHUB_TOKEN environment variable not set${NC}"
        exit 1
    fi
    
    if [ -z "$GITHUB_OWNER" ]; then
        echo -e "${RED}Error: GITHUB_OWNER environment variable not set${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Prerequisites met${NC}"
    echo ""
}

# Function to select environment
select_environment() {
    echo -e "${YELLOW}Select environment:${NC}"
    echo "1) Development"
    echo "2) Staging"
    echo "3) Production"
    echo "4) Custom (use root terraform.tfvars)"
    read -p "Enter choice [1-4]: " ENV_CHOICE
    
    case $ENV_CHOICE in
        1)
            ENV="dev"
            TFVARS_FILE="environments/dev/terraform.tfvars"
            ;;
        2)
            ENV="staging"
            TFVARS_FILE="environments/staging/terraform.tfvars"
            ;;
        3)
            ENV="production"
            TFVARS_FILE="environments/production/terraform.tfvars"
            ;;
        4)
            ENV="custom"
            TFVARS_FILE="terraform.tfvars"
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}Selected environment: $ENV${NC}"
    echo ""
}

# Function to validate tfvars file
validate_tfvars() {
    if [ ! -f "$TFVARS_FILE" ]; then
        echo -e "${YELLOW}Warning: $TFVARS_FILE not found${NC}"
        
        if [ -f "${TFVARS_FILE}.example" ]; then
            read -p "Create from example? [Y/n]: " CREATE
            if [[ $CREATE != "n" && $CREATE != "N" ]]; then
                cp "${TFVARS_FILE}.example" "$TFVARS_FILE"
                echo -e "${GREEN}✓ Created $TFVARS_FILE${NC}"
                echo -e "${YELLOW}Please edit $TFVARS_FILE and run this script again${NC}"
                exit 0
            fi
        fi
        
        echo -e "${RED}Cannot proceed without tfvars file${NC}"
        exit 1
    fi
}

# Function to run terraform commands
run_terraform() {
    local COMMAND=$1
    
    echo -e "${BLUE}Running terraform $COMMAND...${NC}"
    echo ""
    
    case $COMMAND in
        plan)
            terraform plan -var-file="$TFVARS_FILE" -var="github_owner=$GITHUB_OWNER"
            ;;
        apply)
            terraform apply -var-file="$TFVARS_FILE" -var="github_owner=$GITHUB_OWNER"
            ;;
        destroy)
            echo -e "${RED}WARNING: This will destroy all resources!${NC}"
            read -p "Are you sure? Type 'yes' to confirm: " CONFIRM
            if [ "$CONFIRM" == "yes" ]; then
                terraform destroy -var-file="$TFVARS_FILE" -var="github_owner=$GITHUB_OWNER"
            else
                echo -e "${YELLOW}Destroy cancelled${NC}"
                exit 0
            fi
            ;;
        *)
            echo -e "${RED}Unknown command: $COMMAND${NC}"
            exit 1
            ;;
    esac
}

# Main script
main() {
    check_prerequisites
    select_environment
    validate_tfvars
    
    echo -e "${YELLOW}Select action:${NC}"
    echo "1) Plan (preview changes)"
    echo "2) Apply (create/update resources)"
    echo "3) Destroy (delete resources)"
    read -p "Enter choice [1-3]: " ACTION_CHOICE
    
    echo ""
    
    case $ACTION_CHOICE in
        1)
            run_terraform plan
            ;;
        2)
            run_terraform apply
            ;;
        3)
            run_terraform destroy
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}==================================${NC}"
    echo -e "${GREEN}Operation Complete!${NC}"
    echo -e "${GREEN}==================================${NC}"
}

# Run main function
main
