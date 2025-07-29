#!/bin/bash
# create_local_vibe_project.sh - Fast local-only vibe project creation

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
    
    # Remove any leading/trailing whitespace
    PROJECT_NAME=$(echo "$PROJECT_NAME" | xargs)
    
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
    
    print_success "Project name: $PROJECT_NAME"
}

# Clone template and setup local repository
setup_project() {
    print_status "Setting up local project..."
    
    # Go up one directory
    cd ..
    
    # Clone the template
    print_status "Cloning vibe-coding-template..."
    git clone https://github.com/dage/vibe-coding-template.git "$PROJECT_NAME"
    
    # Change to project directory
    cd "$PROJECT_NAME"
    
    # Remove the original git history and initialize new repo
    print_status "Initializing local git repository..."
    rm -rf .git
    git init
    git add .
    git commit -m "Initial commit from vibe-coding-template"
    
    print_success "Local project setup completed"
}

# Setup environment
setup_environment() {
    print_status "Setting up environment..."
    
    # Check if .env exists, if not create from template
    if [[ ! -f ".env" ]]; then
        if [[ -f "env_template.txt" ]]; then
            print_status "Creating .env from template..."
            cp env_template.txt .env
            print_warning "Please edit .env and add your DeepInfra API key"
        else
            print_warning "No env_template.txt found. You may need to create .env manually"
        fi
    fi
    
    # Check if conda environment exists
    if command_exists conda; then
        if conda env list | grep -q "vibes"; then
            print_status "Activating vibes conda environment..."
            conda activate vibes
        else
            print_warning "Conda environment 'vibes' not found. You may need to create it manually"
        fi
    fi
    
    print_success "Environment setup completed"
}

# Run the start script
run_start_script() {
    print_status "Running start script..."
    
    if [[ -f "start_vibe_coding.sh" ]]; then
        chmod +x start_vibe_coding.sh
        ./start_vibe_coding.sh
    elif [[ -f "run_vibe_test.sh" ]]; then
        chmod +x run_vibe_test.sh
        ./run_vibe_test.sh
    else
        print_warning "No start script found. You can run the project manually:"
        print_warning "  python playloop.py"
        print_warning "  or"
        print_warning "  ./run_demo.sh"
    fi
}

# Main execution
main() {
    echo "🚀 Local Vibe Project Creator (Fast Mode)"
    echo "=========================================="
    echo "This creates a local-only project for fast iteration"
    echo "No GitHub repository will be created"
    echo ""
    
    check_prerequisites
    get_project_name
    setup_project
    setup_environment
    run_start_script
    
    print_success "Local project '$PROJECT_NAME' created successfully!"
    print_status "Next steps:"
    print_status "1. Edit .env and add your DeepInfra API key"
    print_status "2. Activate conda environment: conda activate vibes"
    print_status "3. Start coding with: python playloop.py"
    print_status "4. When ready, you can create a GitHub repo manually"
}

# Run main function
main "$@" 