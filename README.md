# Vibetesting in 2026: API Testing with AI Tools — Course Repository

Resources for the Udemy course. Everything you need to follow along is in this repo.

---

## What's in here

```
course-repo/
├── techshop-api/          ← The API under test (Node.js + Express)
│   ├── broken-app/        ← Broken version — 5 bugs planted for testing
│   └── fixed-app/         ← Fixed version — used in the verification section
│
├── prompts/               ← All Cursor prompts used in the course, by section
│   ├── section-04-map-spec.md
│   ├── section-05-postman.md
│   ├── section-06-bruno.md
│   ├── section-07-python.md
│   ├── section-08-robot.md
│   ├── section-10-github-actions.md
│   └── section-11-bug-reports.md
│
└── snippets/              ← Setup configs, CLI commands, ready-to-use files
    ├── mcp-setup-instructions.md     ← How to configure the Postman MCP server
    ├── mcp-config-cursor.json        ← Paste your API key and drop into ~/.cursor/
    ├── mcp-config-vscode.json        ← VS Code + Copilot version of the same
    ├── setup-commands.sh             ← All install commands for Section 3
    ├── run-techshop-api.sh           ← How to start the API locally
    ├── newman-commands.sh            ← Newman CLI reference (Section 5)
    ├── bruno-commands.sh             ← Bruno CLI reference (Section 6)
    ├── pytest-commands.sh            ← pytest CLI reference (Section 7)
    ├── pytest.ini                    ← Drop into your project root (Section 7)
    ├── robot-commands.sh             ← Robot Framework CLI reference (Section 8)
    └── github-actions.yml            ← Full working CI workflow (Section 10)
```

---

## Running the TechShop API

```bash
cd techshop-api/broken-app
npm install
npm start
```

| URL | What it is |
|-----|-----------|
| http://localhost:3000/health | Health check |
| http://localhost:3000/docs | Swagger UI — browse and call endpoints |
| http://localhost:3000/swagger.json | Raw OpenAPI spec — feed this to Cursor |

**Test credentials:** `demo@techshop.com` / `password123`

---

## The 5 Bugs (broken-app only)

| ID | Endpoint | What's wrong |
|----|----------|-------------|
| B1 | POST /auth/login | Returns 200 + token even for wrong password |
| B2 | POST /cart | Accepts negative quantities |
| B3 | GET /products/:id | Returns 500 instead of 404 for missing product |
| B4 | DELETE /cart/:itemId | No auth required — should be protected |
| B5 | POST /orders | Accepts expired card expiry dates |

---

## Credentials — keep secrets out of your code

All test suites read credentials from environment variables. Never hardcode
usernames, passwords, or tokens in test files, prompts, or commits.

**Local:** copy `snippets/.env.example` to `.env`, fill in your values.
`.env` is gitignored — it never gets committed.

**CI (GitHub Actions):** add `TEST_EMAIL` and `TEST_PASSWORD` as repository secrets.
See `snippets/env-setup.md` for full instructions covering Python, Robot Framework,
Bruno, Postman, and GitHub Actions.

---

## Postman MCP Setup

See `snippets/mcp-setup-instructions.md` for full instructions.

Quick version:
1. Generate a Postman API key in Postman → Settings → API Keys
2. Copy `snippets/mcp-config-cursor.json` to `~/.cursor/mcp.json`
3. Paste your API key into the file
4. Restart Cursor

---

## How to use the prompts

Each file in `prompts/` maps to a course section and contains ready-to-use
Cursor prompts. Copy the prompt, paste it into Cursor's chat, and follow along
with the video.

The prompts are designed to be used with `swagger.json` in your project folder.
Copy it from here:

```bash
curl http://localhost:3000/swagger.json -o swagger.json
```

---

## Course sections and what to find here

| Section | What to grab |
|---------|-------------|
| 3 — Setup | `snippets/ssh-github-setup.sh`, `prompts/section-03-setup.md`, `snippets/setup-commands.sh` |
| 4 — Meet the API | `snippets/run-techshop-api.sh`, `prompts/section-04-map-spec.md` |
| 5 — Postman | `snippets/mcp-setup-instructions.md`, `prompts/section-05-postman.md`, `snippets/newman-commands.sh` |
| 6 — Bruno | `prompts/section-06-bruno.md`, `snippets/bruno-commands.sh` |
| 7 — Python | `prompts/section-07-python.md`, `snippets/pytest-commands.sh`, `snippets/pytest.ini` |
| 8 — Robot Framework | `prompts/section-08-robot.md`, `snippets/robot-commands.sh` |
| 10 — GitHub Actions | `prompts/section-10-github-actions.md`, `snippets/github-actions.yml` |
| 11 — Bug Reports | `prompts/section-11-bug-reports.md` |
