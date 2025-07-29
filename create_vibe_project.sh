#!/bin/bash
# create_vibe_project.sh - Helper script to create new vibe projects from template

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists git; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    if ! command_exists conda; then
        print_warning "Conda is not installed. You may need to install it for the vibe environment."
    fi
    
    print_success "Prerequisites check completed"
}

# Get project name from user
get_project_name() {
    print_status "Enter project name (should start with 'vibe-'):"
    echo -n "vibe-"
    read PROJECT_NAME
    
    # Prepend "vibe-" if user didn't include it
    if [[ ! "$PROJECT_NAME" =~ ^vibe- ]]; then
        PROJECT_NAME="vibe-$PROJECT_NAME"
    fi
    
    # Store original name for GitHub repo (keep dashes)
    GITHUB_REPO_NAME="$PROJECT_NAME"
    
    # Clean project name: lowercase, replace spaces/periods/dashes with underscores
    PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' .-' '_')
    
    # Remove any leading/trailing whitespace and underscores
    PROJECT_NAME=$(echo "$PROJECT_NAME" | xargs | sed 's/^_\+//' | sed 's/_\+$//')
    
    # Validate project name
    if [[ -z "$PROJECT_NAME" ]]; then
        print_error "Project name cannot be empty"
        exit 1
    fi
    
    # Check if directory already exists
    if [[ -d "../$PROJECT_NAME" ]]; then
        print_error "Directory '../$PROJECT_NAME' already exists"
        exit 1
    fi
    
    print_success "Project name: $PROJECT_NAME (GitHub repo: $GITHUB_REPO_NAME)"
}

# Clone template and setup repository
setup_project() {
    print_status "Setting up project..."
    
    # Go up one directory
    cd ..
    
    # Clone the template
    print_status "Cloning vibe-coding-template..."
    git clone https://github.com/dage/vibe-coding-template.git "$PROJECT_NAME"
    
    # Change to project directory
    cd "$PROJECT_NAME"
    
    # Remove the original git history and initialize new repo
    print_status "Initializing new git repository..."
    rm -rf .git
    git init -b main
    git add .
    git commit -m "Initial commit from vibe-coding-template"
    
    print_success "Local project setup completed"
    print_status "To create a GitHub repository later, run:"
    print_status "  gh repo create $GITHUB_REPO_NAME --public --source=. --remote=origin --push"
}

# Setup environment
setup_environment() {
    print_status "Setting up environment..."
    
    # Set execute permissions for scripts
    print_status "Setting execute permissions..."
    chmod +x *.py *.sh 2>/dev/null || true
    print_success "Execute permissions set"
    
    # Check if .env exists in the template directory and copy it
    if [[ -f "../.env" ]]; then
        print_status "Copying .env from template directory..."
        cp ../.env .env
        print_success "API key copied from template"
    elif [[ -f "env_template.txt" ]]; then
        print_status "Creating .env from template..."
        cp env_template.txt .env
        print_warning "Please edit .env and add your DeepInfra API key"
    else
        print_warning "No .env or env_template.txt found. You may need to create .env manually"
    fi
    
    # Install dependencies in conda environment
    print_status "Installing dependencies..."
    if command_exists conda && conda env list | grep -q "vibes"; then
        print_status "Installing dependencies in vibes environment..."
        conda run -n vibes pip install -r requirements.txt
        print_success "Dependencies installed in vibes environment"
    elif command_exists pip; then
        print_warning "Installing in current environment (not vibes)"
        pip install -r requirements.txt
        print_success "Dependencies installed"
    else
        print_warning "pip not found. Please install dependencies manually: pip install -r requirements.txt"
    fi
    
    # Install Playwright browsers in conda environment
    print_status "Installing Playwright browsers..."
    if command_exists conda && conda env list | grep -q "vibes"; then
        conda run -n vibes playwright install
        print_success "Playwright browsers installed in vibes environment"
    elif command_exists playwright; then
        playwright install
        print_success "Playwright browsers installed"
    else
        print_warning "playwright not found. Please install manually: playwright install"
    fi
    
    # Install test-app dependencies
    print_status "Installing test-app dependencies..."
    if [[ -d "test-app" ]] && command_exists npm; then
        cd test-app
        npm install
        cd ..
        print_success "Test-app dependencies installed"
    else
        print_warning "test-app not found or npm not available"
    fi
    
    print_success "Environment setup completed"
}

# Provide next steps
provide_next_steps() {
    print_status "Project setup completed!"
    print_status ""
    print_status "You are now in the project directory: $(pwd)"
    print_status ""
    print_status "Next steps:"
    print_status "1. Activate the vibes environment: conda activate vibes"
    print_status "2. Start development:"
    print_status "   - Demo mode: ./run_demo.sh"
    print_status "   - Full mode: ./run_vibe_test.sh"
    print_status ""
    print_status "Note: You must activate 'conda activate vibes' in each new terminal session."
}

# Main execution
main() {
    echo "🚀 Vibe Project Creator"
    echo "========================"
    
    check_prerequisites
    get_project_name
    setup_project
    setup_environment
    provide_next_steps
    
    print_success "Project '$PROJECT_NAME' created successfully!"
    print_status "To create GitHub repo later:"
    print_status "  gh repo create $GITHUB_REPO_NAME --public --source=. --remote=origin --push"
    print_status ""
    print_status "You are now ready to start development in your new project!"
    print_status ""
    print_status "Next steps:"
    print_status "1. Change to the project directory: cd ../$PROJECT_NAME"
    print_status "2. Activate the vibes environment: conda activate vibes"
    print_status "3. Start development: ./run_demo.sh or ./run_vibe_test.sh"
}

# Run main function
main "$@" 