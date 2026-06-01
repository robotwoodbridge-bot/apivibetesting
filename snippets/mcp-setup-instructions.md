# Postman MCP Server — Setup Instructions

The Postman MCP server lets Cursor (and other AI IDEs) create and manage
Postman collections directly via the Postman API — no manual import needed.

**Security rule: the API key lives in `.env` only. It must never be written
into a config file that could be committed to Git.**

---

## Step 1 — Get Your Postman API Key

1. Open Postman desktop app
2. Click your profile icon (top right) → **Settings**
3. Go to **API Keys**
4. Click **Generate API Key**, give it a name (e.g. `cursor-mcp`)
5. Copy the key — you will only see it once

---

## Step 2 — Save the Key to .env

Add the key to your project `.env` file (not a config file):

```
POSTMAN_API_KEY=your-key-here
```

Confirm `.env` is in your `.gitignore`. It is included in `snippets/.gitignore`.

---

## Step 3 — Install dotenv-cli

`dotenv-cli` lets the MCP config load the key from `.env` at startup
without the key ever appearing in the config file itself:

```bash
npm install -g dotenv-cli
```

---

## Step 4 — Configure the MCP Server

### Cursor

Create or edit `~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (project):

```json
{
  "mcpServers": {
    "postman": {
      "command": "dotenv",
      "args": ["-e", ".env", "--", "npx", "-y", "@postman/mcp-server"]
    }
  }
}
```

The ready-to-use file is at `snippets/mcp-config-cursor.json`.

### VS Code + GitHub Copilot

Create `.vscode/mcp.json` in your project:

```json
{
  "servers": {
    "postman": {
      "type": "stdio",
      "command": "dotenv",
      "args": ["-e", ".env", "--", "npx", "-y", "@postman/mcp-server"]
    }
  }
}
```

The ready-to-use file is at `snippets/mcp-config-vscode.json`.

### Windsurf

Open **Windsurf Settings → MCP** and add a new server entry:
- Command: `dotenv`
- Args: `-e .env -- npx -y @postman/mcp-server`

### Antigravity

Open **Settings → Integrations → MCP Servers** and add:
- Name: `postman`
- Command: `dotenv -e .env -- npx -y @postman/mcp-server`

---

## Step 5 — Restart Your AI IDE

After saving the config, fully restart your AI IDE. Verify the MCP is connected:

1. **Cursor Settings → Features → MCP** — Postman server should show a green indicator
2. **In the chat**, type: `What MCP tools do you have available?` — Postman tools should be listed

---

## Available MCP Tools (after setup)

| Tool | What it does |
|------|-------------|
| `create_collection` | Creates a new collection in your workspace |
| `create_folder` | Adds a folder inside a collection |
| `create_request` | Adds a request (with tests) to a folder |
| `run_collection` | Runs a collection via the Postman API |
| `get_collections` | Lists all collections in your workspace |

---

## Troubleshooting

**"dotenv: not found"** — Run `npm install -g dotenv-cli` first.

**"npx: not found"** — Install Node.js from nodejs.org (includes npx).

**"Unauthorized"** — Your API key in `.env` is wrong or expired. Regenerate it in Postman Settings.

**MCP tools not appearing** — Make sure you fully restarted the IDE after editing the config file.
