#!/bin/bash
# SSH Key Setup for GitHub
# Run these commands in your terminal step by step.

# ─── Step 1: Check if you already have an SSH key ────────────────────────────

ls ~/.ssh/*.pub
# If you see a file like id_ed25519.pub or id_rsa.pub — you already have a key.
# Skip to Step 3.
# If you get "No such file or directory" — continue to Step 2.

# ─── Step 2: Generate a new SSH key ──────────────────────────────────────────

ssh-keygen -t ed25519 -C "your-email@example.com"
# Press Enter to accept the default file location (~/.ssh/id_ed25519)
# Press Enter twice to skip the passphrase (or set one if you prefer)

# ─── Step 3: Copy your public key ─────────────────────────────────────────────

# Mac
cat ~/.ssh/id_ed25519.pub | pbcopy
# Your public key is now in your clipboard.

# Windows (Git Bash)
# cat ~/.ssh/id_ed25519.pub | clip

# Linux
# cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard

# ─── Step 4: Add the key to GitHub ────────────────────────────────────────────

# 1. Go to github.com → click your profile photo → Settings
# 2. In the left sidebar, click "SSH and GPG keys"
# 3. Click "New SSH key"
# 4. Give it a title (e.g. "My Laptop")
# 5. Paste your key into the Key field
# 6. Click "Add SSH key"

# ─── Step 5: Test the connection ──────────────────────────────────────────────

ssh -T git@github.com
# You should see: Hi <your-username>! You've successfully authenticated...

# ─── Step 6: Fork and clone the course repo ───────────────────────────────────

# 1. Go to https://github.com/homolamartin1-ai/apivibetesting
# 2. Click Fork → Create fork
# 3. Clone YOUR fork (replace YOUR-USERNAME):

git clone git@github.com:YOUR-USERNAME/apivibetesting.git
cd apivibetesting
