# Vibe Coding Template - AI-Powered Development Workflow

This project provides a clean, working template for AI-assisted coding workflows using Aider, DeepInfra's open-source vision and code models, and Playwright for screenshot analysis. The template is designed to be cost-efficient by using open-source models at DeepInfra instead of traditional frontier models, and offers ease of setup by staying within the DeepInfra ecosystem, allowing you to use the same credits pool for all models - both code generation and vision analysis.

## Quick Start

### Option 1: Clone and Use Script (Recommended)

```bash
# Clone this template first
git clone https://github.com/dage/vibe-coding-template.git
cd vibe-coding-template

# Run the project creator
./create_vibe_project.sh
```

The script will:
- Ask for a project name (pre-filled with "vibe-")
- Clone the template to a new directory
- Set up local git repository
- Set up the environment
- Start the development workflow

**Prerequisites:**
- Git installed
- Conda (optional but recommended)
- DeepInfra API key (get one at [https://deepinfra.com/](https://deepinfra.com/))

**Setup API Key (One-time):**
```bash
# Edit the template's .env file with your API key
cp env_template.txt .env
# Edit .env and add your DeepInfra API key
```

**To create a GitHub repository later:**
```bash
gh repo create your-project-name --public --source=. --remote=origin --push
```

### Option 2: Use GitHub Template

1. Go to [https://github.com/dage/vibe-coding-template](https://github.com/dage/vibe-coding-template)
2. Click "Use this template" → "Create a new repository"
3. Name your repository and create it
4. Clone your new repository locally
5. Set up the environment manually

**For local development with GitHub template:**
```bash
# Clone your GitHub repo
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

# Set up environment
cp env_template.txt .env
# Edit .env with your DeepInfra API key

# Activate conda environment
conda activate vibes

# Start development
python playloop.py
```

**Prerequisites:**
- Git installed
- Conda (optional but recommended)
- DeepInfra API key (get one at [https://deepinfra.com/](https://deepinfra.com/))

#### Demo Mode (No API Key Required)
```bash
# Run the demo to see how the system works
./run_demo.sh
```

#### Full Mode (Requires API Key)
1. Start your development server (if using Vite):
   ```bash
   npm run dev
   ```

2. Run the automated coding loop:
   ```bash
   python playloop.py
   # or
   ./run_vibe_test.sh
   ```

## How It Works

1. **Screenshot Capture**: Playwright takes a screenshot of your running app
2. **Vision Analysis**: Llama-3.2-90B-Vision analyzes the screenshot and console logs
3. **Issue Detection**: Identifies UX/UI/logic issues and proposes changes
4. **Code Generation**: Qwen3-Coder generates specific code instructions
5. **Auto-Apply**: Aider applies the changes automatically with testing

## Models Used

- **Vision**: `meta-llama/Llama-3.2-90B-Vision-Instruct` - Analyzes screenshots
- **Code**: `Qwen/Qwen3-Coder-480B-A35B-Instruct-Turbo` - Generates code changes
- **Alternative**: `moonshotai/Kimi-K2-Instruct` - Text-only code generation

## Project Structure

### Core Files
- `playloop.py` - Main AI automation script
- `demo_vibe_loop.py` - Demo version (no API required)
- `create_initial_app.py` - Creates initial Vite app structure
- `test_setup.py` - Environment testing script

### Scripts
- `create_vibe_project.sh` - Project creation helper (creates local repo, GitHub optional)
- `run_demo.sh` - Demo runner script
- `run_vibe_test.sh` - Full vibe loop runner
- `setup_env.sh` - Environment activation helper
- `setup_deepinfra.sh` - DeepInfra API setup (alternative)

### Configuration
- `env_template.txt` - Environment variables template
- `.cursorrules` - Cursor IDE rules with project history lessons
- `PROJECT_HISTORY_LESSONS.md` - Complete project development history

### Application
- `test-app/` - Working Vite application (included in template)
- `ai_loop_artifacts/` - Generated screenshots and analysis files (gitignored)

## Tips

- **Start with the demo**: Run `./run_demo.sh` to see how the system works without API calls
- **Use the helper script**: `./create_vibe_project.sh` for quick project setup
- **Check the history**: Read `PROJECT_HISTORY_LESSONS.md` to understand what not to do
- **Template approach**: Clone this template for each new project to avoid git history pollution
- **Environment setup**: Always activate the conda environment before running: `conda activate vibes`
- **API key management**: Keep your `.env` file gitignored and secure
- **Fast iteration**: Create local projects first, push to GitHub only when ready

## Troubleshooting

### API Connection Issues
- Make sure your API key is valid and has sufficient credits
- Check your internet connection
- Try running the demo first: `./run_demo.sh`

### App Not Starting
- Ensure your dev server is running on the expected port (default: 5173)
- Check that all dependencies are installed: `python test_setup.py`

### GitHub CLI Issues
- Install GitHub CLI: `brew install gh`
- Authenticate: `gh auth login`
- Check status: `gh auth status`

### Debugging
- Check the `ai_loop_artifacts/` directory for screenshots and analysis files
- Run `python test_setup.py` to verify your environment
- Use the demo mode to test the workflow without API calls
- Check `.cursorrules` for project-specific guidance

## Project History & Lessons Learned

This template has evolved through significant development iterations. To avoid repeating past mistakes:

- **Read `PROJECT_HISTORY_LESSONS.md`** - Complete development history with detailed analysis
- **Check `.cursorrules`** - Concise guidelines for AI agents working on this project
- **Key lesson**: Never isolate the test-app from git tracking
- **Key lesson**: Avoid over-engineering workflows
- **Key lesson**: Keep the template simple and focused

The current state represents a clean, working template that avoids the complexity and issues of previous iterations. 