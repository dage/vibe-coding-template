#!/bin/bash
# run_demo.sh - Run demo vibe loop (no API key required)

echo "🚀 Starting Vibe Coding Demo..."

# Activate conda environment
echo "🔧 Activating vibes environment..."
conda activate vibes

echo ""
echo "🎯 Running demo vibe coding loop..."
echo "This demonstrates how the AI analyzes the app and suggests improvements."
echo "No API key required - using mock data."
echo ""

# Run the demo
python demo_vibe_loop.py

echo "✅ Demo completed!" 