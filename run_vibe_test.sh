#!/bin/bash
# run_vibe_test.sh - Start test app and run vibe coding loop

echo "🚀 Starting Vibe Coding Test..."

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

# Check if test app exists
if [ ! -d "test-app" ]; then
    echo "❌ test-app directory not found!"
    exit 1
fi

# Check if test-app dependencies are installed
echo "🔍 Checking test-app dependencies..."
cd test-app
if [[ ! -d "node_modules" ]]; then
    echo "📦 Installing test-app dependencies..."
    npm install
fi
cd ..

# Start the test app in the background
echo "🌐 Starting test app..."
cd test-app
npm run dev &
DEV_PID=$!
cd ..

# Wait for the app to start
echo "⏳ Waiting for app to start..."
sleep 5

# Check if app is running
if curl -s http://localhost:5173 > /dev/null; then
    echo "✅ Test app is running at http://localhost:5173"
else
    echo "❌ Test app failed to start"
    kill $DEV_PID 2>/dev/null
    exit 1
fi

echo ""
echo "🎯 Running vibe coding loop..."
echo "The AI will analyze the app and suggest improvements."
echo "Press Ctrl+C to stop the loop."
echo ""

# Run the vibe loop
python playloop.py

# Cleanup
echo ""
echo "🧹 Cleaning up..."
kill $DEV_PID 2>/dev/null
echo "✅ Done!" 