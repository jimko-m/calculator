#!/bin/bash

# --------------------------------------
# --- Setup project and push to GitHub ---
# --------------------------------------

# --- GitHub repository URL ---
REPO_URL="https://github.com/jimko-m/calculator-.git"

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
GIT_NAME=$(git config --global jimko-m)
GIT_EMAIL=$(git config --global abdehassni1@gmail.com)

if [ -z "$GIT_NAME" ]; then
    git config --global user.name "Your Name"
    echo "Git global user.name set to 'Your Name'"
fi

if [ -z "$GIT_EMAIL" ]; then
    git config --global user.email "you@example.com"
    echo "Git global user.email set to 'you@example.com'"
fi

# --- Create MIT LICENSE if not exists ---
if [ ! -f "LICENSE" ]; then
    YEAR=$(date +"%Y")
    cat <<EOL > LICENSE
MIT License

Copyright (c) $YEAR abde@M

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

# --- Fix dubious ownership issue (Termux / Android) ---
git config --global --add safe.directory "$(pwd)"

# --- Initialize Git ---
git init

# --- Add all files ---
git add .

# --- First commit ---
git commit -m "Initial commit: $PROJECT_NAME with MIT License"

# --- Add remote repository ---
git remote add origin $REPO_URL

# --- Rename branch to main ---
git branch -M main

# --- Push to GitHub ---
git push -u origin main

echo "Project has been successfully pushed to GitHub!"