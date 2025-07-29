#!/bin/bash
# run_demo.sh - Run demo vibe loop (no API key required)

echo "🚀 Starting Vibe Coding Demo..."

# Activate conda environment (if available)
echo "🔧 Activating vibes environment..."
if command -v conda >/dev/null 2>&1; then
    # Try to activate conda environment
    if conda env list | grep -q "vibes"; then
        # Source conda if needed
        if [[ -f "$(conda info --base)/etc/profile.d/conda.sh" ]]; then
            source "$(conda info --base)/etc/profile.d/conda.sh"
        fi
        conda activate vibes 2>/dev/null || echo "⚠️  Could not activate conda environment automatically"
    else
        echo "⚠️  Conda environment 'vibes' not found"
    fi
else
    echo "⚠️  Conda not found, continuing without conda environment"
fi

echo ""
echo "🎯 Running demo vibe coding loop..."
echo "This demonstrates how the AI analyzes the app and suggests improvements."
echo "No API key required - using mock data."
echo ""

# Run the demo
python demo_vibe_loop.py

echo "✅ Demo completed!" 