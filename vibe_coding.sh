#!/bin/bash
# vibe_coding.sh - Main vibe coding workflow (single, loop, demo, continue modes)

# Source common functionality
source "$(dirname "$0")/vibe_common.sh"

# Default values
MODE="single"
CUSTOM_PROMPT=""
MAX_ITERATIONS=10
ITERATION_DELAY=30

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -m, --mode MODE         Mode: single, loop, or continue (default: single)"
    echo "  -p, --prompt PROMPT     Custom prompt for AI direction"
    echo "  -i, --iterations N      Max iterations for loop mode (default: 10)"
    echo "  -d, --delay SECONDS     Delay between iterations (default: 30)"
    echo ""
    echo "Modes:"
    echo "  single     Run one iteration and exit (default) - equivalent to old run_vibe_test.sh"
    echo "  loop       Run continuous autonomous iterations - equivalent to old start_vibe_coding.sh"
    echo "  continue   Resume after human intervention with new direction - equivalent to old continue_vibe_coding.sh"
    echo ""
    echo "Quick Start Examples:"
    echo "  $0                                    # Test single iteration (like old run_vibe_test.sh)"
    echo "  $0 --mode loop                        # Start autonomous AI iteration loop"
    echo ""
    echo "Advanced Examples:"
    echo "  $0 --mode loop --iterations 5         # Loop with 5 iterations"
    echo "  $0 --mode loop --prompt 'Add dark mode' # Loop with custom direction"
    echo "  $0 --mode continue                    # Resume with interactive prompt"
    echo "  $0 --mode continue --prompt 'Fix bugs' # Resume with specific direction"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -m|--mode)
            MODE="$2"
            shift 2
            ;;
        -p|--prompt)
            CUSTOM_PROMPT="$2"
            shift 2
            ;;
        -i|--iterations)
            MAX_ITERATIONS="$2"
            shift 2
            ;;
        -d|--delay)
            ITERATION_DELAY="$2"
            shift 2
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate mode
case $MODE in
    single|loop|continue)
        ;;
    *)
        print_error "Invalid mode: $MODE"
        show_usage
        exit 1
        ;;
esac

echo "🚀 Starting Vibe Coding Test..."
print_status "Mode: $MODE"
if [ ! -z "$CUSTOM_PROMPT" ]; then
    print_status "Custom prompt: $CUSTOM_PROMPT"
fi
if [ "$MODE" = "loop" ]; then
    print_status "Max iterations: $MAX_ITERATIONS"
    print_status "Delay between iterations: ${ITERATION_DELAY}s"
fi

# Handle continuation mode separately
if [ "$MODE" = "continue" ]; then
    handle_continuation "$CUSTOM_PROMPT"
    exit 0
fi

# Activate conda environment
activate_conda_env

# Check if test app exists
check_test_app

# Install test app dependencies
install_test_app_deps

# Start the test app
DEV_PID=$(start_test_app)

# Function to run iterations
run_iterations() {
    local iteration=1
    
    while [ $iteration -le $MAX_ITERATIONS ]; do
        echo ""
        echo "🔄 Iteration $iteration/$MAX_ITERATIONS"
        echo "=================================="
        
        # Run the vibe loop
        run_vibe_loop "full" "$CUSTOM_PROMPT"
        
        # Check if we should continue
        if [ $iteration -lt $MAX_ITERATIONS ]; then
            echo ""
            print_status "Waiting ${ITERATION_DELAY} seconds before next iteration..."
            print_status "Press Ctrl+C to stop the loop"
            print_status "To resume later with a new direction, run: $0 --mode continue"
            sleep $ITERATION_DELAY
        fi
        
        iteration=$((iteration + 1))
    done
    
    echo ""
    print_success "Completed $MAX_ITERATIONS iterations!"
}

# Run based on mode
case $MODE in
    single)
        echo ""
        echo "🎯 Running single vibe coding loop..."
        echo "The AI will analyze the app and suggest improvements."
        echo "Press Ctrl+C to stop the loop."
        echo ""
        run_vibe_loop "full" "$CUSTOM_PROMPT"
        ;;
    loop)
        echo ""
        echo "🔄 Starting autonomous vibe coding loop..."
        echo "The AI will continuously analyze and improve the app."
        echo "Press Ctrl+C to stop the loop."
        echo "To resume later with a new direction, run: $0 --mode continue"
        echo ""
        run_iterations
        ;;

esac

# Cleanup
echo ""
echo "🧹 Cleaning up..."
stop_test_app $DEV_PID
echo "✅ Done!" 