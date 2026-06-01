#!/bin/bash
# All environment variables needed for this course.
# Add these to your shell profile — NOT inside the project folder.
#
# Mac/Linux (zsh):  open ~/.zshrc, paste the exports below, then: source ~/.zshrc
# Mac/Linux (bash): open ~/.bashrc, paste the exports below, then: source ~/.bashrc
# Windows:          Start → Edit the system environment variables
#                   → Environment Variables → User variables → New

# ─── TechShop API ─────────────────────────────────────────────────────────────
export BASE_URL=http://localhost:3000

# ─── Test credentials (TechShop demo account) ─────────────────────────────────
export TEST_EMAIL=demo@techshop.com
export TEST_PASSWORD=password123

# ─── Postman API key ──────────────────────────────────────────────────────────
# Leave blank for now — fill in during Section 5 after generating the key.
# Postman → Settings → API Keys → Generate API Key
export POSTMAN_API_KEY=

# ─── After adding, reload your shell profile ──────────────────────────────────
# source ~/.zshrc    (Mac zsh)
# source ~/.bashrc   (Linux / Mac bash)

# ─── Verify all variables are set ─────────────────────────────────────────────
# echo "BASE_URL=$BASE_URL"
# echo "TEST_EMAIL=$TEST_EMAIL"
# echo "TEST_PASSWORD=$TEST_PASSWORD"
# echo "POSTMAN_API_KEY=$POSTMAN_API_KEY"
