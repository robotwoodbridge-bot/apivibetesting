#!/bin/bash
# Section 8 — Robot Framework Commands

# ─── Basic run ────────────────────────────────────────────────────────────────

robot techshop.robot

# ─── With custom output directory ─────────────────────────────────────────────

robot --outputdir robot-results techshop.robot

# ─── Override BASE_URL ────────────────────────────────────────────────────────

robot --variable BASE_URL:http://staging.techshop.com \
      --outputdir robot-results \
      techshop.robot

# ─── Run a single test by name ────────────────────────────────────────────────

robot --test "Login With Wrong Password" techshop.robot

# ─── Run tests matching a tag ─────────────────────────────────────────────────

robot --include auth techshop.robot

# ─── View the report ──────────────────────────────────────────────────────────
# After running, open these files in your browser:
#   robot-results/report.html   ← summary report
#   robot-results/log.html      ← full execution log with request/response detail
