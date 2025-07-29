#!/bin/bash
# setup_env.sh - Activate vibes conda environment and verify setup

echo "🔧 Activating vibes conda environment..."

# Check if conda is available
if ! command -v conda >/dev/null 2>&1; then
    echo "❌ Conda not found. Please install conda first."
    exit 1
fi

# Source conda if needed
if [[ -f "$(conda info --base)/etc/profile.d/conda.sh" ]]; then
    source "$(conda info --base)/etc/profile.d/conda.sh"
fi

# Check if vibes environment exists
if conda env list | grep -q "vibes"; then
    conda activate vibes
    if [ $? -eq 0 ]; then
        echo "✅ Vibes environment activated successfully"
        echo "Python version: $(python --version)"
        echo "Aider version: $(aider --version 2>/dev/null || echo 'not installed')"
        echo ""
        echo "You can now use aider and other tools in this environment."
        echo "To deactivate, run: conda deactivate"
    else
        echo "❌ Failed to activate vibes environment"
        exit 1
    fi
else
    echo "❌ Vibes environment not found"
    echo "Create it with: conda create -n vibes python=3.9"
    exit 1
fi 