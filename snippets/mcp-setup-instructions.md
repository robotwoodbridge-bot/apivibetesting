# Postman MCP Server — Setup Instructions

The Postman MCP server lets Cursor (and other AI IDEs) create and manage
Postman collections directly via the Postman API — no manual import needed.

---

## Step 1 — Get Your Postman API Key

1. Open Postman desktop app
2. Click your profile icon (top right) → **Settings**
3. Go to **API Keys**
4. Click **Generate API Key**, give it a name (e.g. `cursor-mcp`)
5. Copy the key — you will only see it once

---

## Step 2 — Configure the MCP Server

### Cursor

Create or edit the file `~/.cursor/mcp.json` (global config) or
`.cursor/mcp.json` in your project root (project-level config):

```json
{
  "mcpServers": {
    "postman": {
      "command": "npx",
      "args": ["-y", "@postman/mcp-server"],
      "env": {
        "POSTMAN_API_KEY": "YOUR_KEY_HERE"
      }
    }
  }
}
```

The ready-to-edit file is at `snippets/mcp-config-cursor.json` — paste your
key and copy it to the correct location.

### VS Code + GitHub Copilot

Create `.vscode/mcp.json` in your project:

```json
{
  "servers": {
    "postman": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@postman/mcp-server"],
      "env": {
        "POSTMAN_API_KEY": "YOUR_KEY_HERE"
      }
    }
  }
}
```

The ready-to-edit file is at `snippets/mcp-config-vscode.json`.

### Windsurf

Open **Windsurf Settings → MCP** and add a new server entry:
- Command: `npx`
- Args: `-y @postman/mcp-server`
- Environment variable: `POSTMAN_API_KEY=YOUR_KEY_HERE`

### Antigravity

Open **Settings → Integrations → MCP Servers** and add:
- Name: `postman`
- Command: `npx -y @postman/mcp-server`
- Env: `POSTMAN_API_KEY=YOUR_KEY_HERE`

---

## Step 3 — Restart Your AI IDE

After saving the config, fully restart your AI IDE. The Postman MCP tools
should now appear in the chat — you can verify by typing:
`What Postman MCP tools do you have available?`

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

**"npx: not found"** — Install Node.js from nodejs.org (includes npx)

**"Unauthorized"** — Your API key is wrong or expired. Regenerate it in Postman Settings.

**MCP tools not appearing** — Make sure you fully restarted the IDE after editing the config file.
