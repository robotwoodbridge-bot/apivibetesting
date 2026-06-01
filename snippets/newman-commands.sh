#!/bin/bash
# Section 5 — Newman CLI Commands

# ─── Basic run ────────────────────────────────────────────────────────────────

newman run techshop.postman_collection.json \
  --env-var base_url=http://localhost:3000

# ─── With HTML report ─────────────────────────────────────────────────────────

newman run techshop.postman_collection.json \
  --env-var base_url=http://localhost:3000 \
  --reporters cli,html \
  --reporter-html-export newman-report.html

# ─── Run against a different environment ──────────────────────────────────────

newman run techshop.postman_collection.json \
  --env-var base_url=http://staging.techshop.com

# ─── Exit code behaviour ──────────────────────────────────────────────────────
# Newman exits with code 1 when any test fails.
# GitHub Actions reads this exit code to fail the pipeline step.
