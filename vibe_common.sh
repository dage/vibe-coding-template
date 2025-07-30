#!/bin/bash
# vibe_common.sh - Common functionality for vibe coding workflows

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

# Function to activate conda environment
activate_conda_env() {
    print_status "Activating vibes environment..."
    if command -v conda >/dev/null 2>&1; then
        if conda env list | grep -q "vibes"; then
            if [[ -f "$(conda info --base)/etc/profile.d/conda.sh" ]]; then
                source "$(conda info --base)/etc/profile.d/conda.sh"
            fi
            conda activate vibes 2>/dev/null || print_warning "Could not activate conda environment automatically"
        else
            print_warning "Conda environment 'vibes' not found"
        fi
    else
        print_warning "Conda not found, continuing without conda environment"
    fi
}

# Function to check test app exists
check_test_app() {
    if [ ! -d "test-app" ]; then
        print_error "test-app directory not found!"
        exit 1
    fi
}

# Function to install test app dependencies
install_test_app_deps() {
    print_status "Checking test-app dependencies..."
    cd test-app
    if [[ ! -d "node_modules" ]]; then
        print_status "Installing test-app dependencies..."
        npm install
    fi
    cd ..
}

# Function to start test app
start_test_app() {
    print_status "Starting test app..."
    cd test-app
    npm run dev &
    DEV_PID=$!
    cd ..
    
    # Wait for the app to start
    print_status "Waiting for app to start..."
    sleep 5
    
    # Check if app is running
    if curl -s http://localhost:5173 > /dev/null; then
        print_success "Test app is running at http://localhost:5173"
        echo $DEV_PID
    else
        print_error "Test app failed to start"
        kill $DEV_PID 2>/dev/null
        exit 1
    fi
}

# Function to stop test app
stop_test_app() {
    local dev_pid=$1
    if [ ! -z "$dev_pid" ]; then
        print_status "Stopping test app..."
        kill $dev_pid 2>/dev/null
        print_success "Test app stopped"
    fi
}

# Function to run vibe loop
run_vibe_loop() {
    local mode=$1
    local custom_prompt=$2
    
    if [ "$mode" = "demo" ]; then
        print_status "Running demo vibe coding loop..."
        python demo_vibe_loop.py
    else
        print_status "Running vibe coding loop..."
        if [ ! -z "$custom_prompt" ]; then
            print_status "Using custom prompt: $custom_prompt"
            python playloop.py "$custom_prompt"
        else
            python playloop.py
        fi
    fi
}

# Function to get custom prompt from user
get_custom_prompt() {
    echo ""
    print_status "Enter a custom prompt to direct the AI (or press Enter for default):"
    echo "Example: 'Add dark mode support' or 'Improve mobile responsiveness'"
    echo -n "> "
    read -r custom_prompt
    echo "$custom_prompt"
}

# Function to check if test app is already running
check_app_running() {
    if curl -s http://localhost:5173 > /dev/null; then
        print_success "Test app is already running at http://localhost:5173"
        return 0
    else
        return 1
    fi
}

# Function to handle continuation scenario
handle_continuation() {
    local custom_prompt=$1
    
    print_status "Continuation mode - resuming AI iteration loop"
    
    # Activate conda environment
    activate_conda_env
    
    # Check if app is running
    if ! check_app_running; then
        print_warning "Test app is not running. Starting it now..."
        DEV_PID=$(start_test_app)
        APP_STARTED=true
    else
        print_status "Using existing test app instance"
        APP_STARTED=false
    fi
    
    # Get custom prompt if not provided
    if [ -z "$custom_prompt" ]; then
        custom_prompt=$(get_custom_prompt)
    fi
    
    # Run the vibe loop with custom prompt
    if [ ! -z "$custom_prompt" ]; then
        print_status "Continuing with custom direction: $custom_prompt"
        run_vibe_loop "full" "$custom_prompt"
    else
        print_status "Continuing with default AI direction"
        run_vibe_loop "full"
    fi
    
    # Cleanup if we started the app
    if [ "$APP_STARTED" = true ]; then
        echo ""
        print_status "Cleaning up..."
        stop_test_app $DEV_PID
    fi
} 