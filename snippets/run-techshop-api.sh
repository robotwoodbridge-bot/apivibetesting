#!/bin/bash
# Section 4 — Run TechShop API locally

# ─── Broken app (use during testing sections 5–8) ─────────────────────────────

cd techshop-api/broken-app
npm install
npm start

# API available at:
#   http://localhost:3000
#   http://localhost:3000/health     ← health check
#   http://localhost:3000/docs       ← Swagger UI
#   http://localhost:3000/swagger.json ← raw OpenAPI spec

# ─── Fixed app (use during verification) ──────────────────────────────────────

# cd techshop-api/fixed-app
# npm install
# npm start

# ─── Run on a different port ──────────────────────────────────────────────────

# PORT=3001 npm start
