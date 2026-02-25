# GitHub Setup Guide

## Step 1: Configure Git
Run these commands to set your GitHub username and email:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@github.com"
```

## Step 2: Create a Repository on GitHub
1. Go to https://github.com/new
2. Create a new repository with the same name as your folder
3. Don't initialize with README (we already have one)

## Step 3: Connect Local Repository to GitHub
After creating the repo, GitHub will show commands. Run:
```bash
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
git branch -M main
git push -u origin main
```

## Step 4: Auto-Push When Files Change
Use the provided `auto-push.ps1` script to automatically commit and push changes.

### Option A: Run the script manually
```bash
powershell -ExecutionPolicy Bypass -File auto-push.ps1
```

### Option B: Set up automatic monitoring (runs continuously)
The script watches for file changes and pushes automatically.
