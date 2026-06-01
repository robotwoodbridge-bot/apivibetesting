#!/bin/bash
# Section 7 — pytest Commands

# ─── Basic run ────────────────────────────────────────────────────────────────

pytest test_techshop.py -v

# ─── With HTML report ─────────────────────────────────────────────────────────

pytest test_techshop.py -v \
  --html=pytest-report.html \
  --self-contained-html

# ─── Run against a different environment ─────────────────────────────────────

BASE_URL=http://staging.techshop.com pytest test_techshop.py -v

# ─── Run a single test ────────────────────────────────────────────────────────

pytest test_techshop.py::test_login_wrong_password -v

# ─── Run tests matching a keyword ─────────────────────────────────────────────

pytest test_techshop.py -k "login" -v
pytest test_techshop.py -k "cart" -v

# ─── Stop on first failure ────────────────────────────────────────────────────

pytest test_techshop.py -v -x
