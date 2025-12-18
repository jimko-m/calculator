#!/bin/bash

# --------------------------------------
# --- Fully automated GitHub push script ---
# --------------------------------------

# --- GitHub repository URL (replace with your repo) ---
REPO_URL="https://github.com/jimko-m/calculator.git"

# --- Project name for LICENSE ---
PROJECT_NAME="Calculator Flet Project"

# --- Check if Git is installed ---
if ! command -v git &> /dev/null
then
    echo "Git not found, installing..."
    # Termux
    if command -v pkg &> /dev/null; then
        pkg install git -y
    # Ubuntu/Debian
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt install git -y
    else
        echo "Please install Git manually."
        exit 1
    fi
fi

# --- Set Git global user if not set ---
GIT_NAME=$(git config --global user.name)
GIT_EMAIL=$(git config --global user.email)

if [ -z "$GIT_NAME" ]; then
    read -p "Enter your GitHub name: " INPUT_NAME
    git config --global user.name "$INPUT_NAME"
else
    INPUT_NAME=$GIT_NAME
fi

if [ -z "$GIT_EMAIL" ]; then
    read -p "Enter your GitHub email: " INPUT_EMAIL
    git config --global user.email "$INPUT_EMAIL"
else
    INPUT_EMAIL=$GIT_EMAIL
fi

# --- Create MIT LICENSE if not exists ---
if [ ! -f "LICENSE" ]; then
    YEAR=$(date +"%Y")
    cat <<EOL > LICENSE
MIT License

Copyright (c) $YEAR $INPUT_NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL
    echo "LICENSE file created successfully."
fi

# --- Create .gitignore for Python and Flet ---
if [ ! -f ".gitignore" ]; then
    cat <<EOL > .gitignore
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
*.swp
*.egg-info/
dist/
build/

# Flet
*.flet/
EOL
    echo ".gitignore file created successfully."
fi

# --- Fix dubious ownership issue (Termux / Android) ---
git config --global --add safe.directory "$(pwd)"

# --- Initialize Git ---
git init

# --- Add all files ---
git add .

# --- First commit if needed ---
git commit -m "Initial commit: $PROJECT_NAME with MIT License" 2>/dev/null

# --- Remove existing remote if exists ---
git remote remove origin 2>/dev/null

# --- Add remote repository ---
git remote add origin $REPO_URL

# --- Rename branch to main ---
git branch -M main

# --- Prompt for GitHub username and Personal Access Token ---
read -p "Enter your GitHub username: " GH_USER
read -s -p "Enter your GitHub Personal Access Token: " GH_TOKEN
echo

# --- Pull remote changes to avoid rejected push ---
git pull https://$GH_USER:$GH_TOKEN@$(echo $REPO_URL | sed 's|https://||') main --rebase 2>/dev/null

# --- Push to GitHub using token ---
git push https://$GH_USER:$GH_TOKEN@$(echo $REPO_URL | sed 's|https://||') main

echo "Project has been successfully pushed to GitHub!"