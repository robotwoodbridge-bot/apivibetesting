#!/bin/bash
# Section 6 — Bruno CLI Commands

# ─── Run full collection ──────────────────────────────────────────────────────

bru run techshop-bruno/ --env local

# ─── Run a single subfolder ───────────────────────────────────────────────────

bru run techshop-bruno/auth/ --env local
bru run techshop-bruno/products/ --env local
bru run techshop-bruno/cart/ --env local
bru run techshop-bruno/orders/ --env local

# ─── Run against a different base URL ────────────────────────────────────────

bru run techshop-bruno/ --env local \
  --env-var baseUrl=http://staging.techshop.com

# ─── Exit code behaviour ─────────────────────────────────────────────────────
# Bruno CLI exits with code 1 when any test fails.
