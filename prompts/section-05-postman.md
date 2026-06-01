# Section 5 — Postman + Newman

## Course reference
| Prompt | Used in clip |
|--------|-------------|
| Prompt 1 — Create Postman Collection via MCP | **Section 5, Clip 3** — Cursor Creates the Collection via MCP |
| Prompt 2 — Export Collection for Newman | **Section 5, Clip 5** — Newman CLI |
| Prompt 3 — Fix a Failing Test | **Section 5, Clip 4** — Running the Collection and Reading Results |
| Prompt 4 — Set Up Postman MCP Config | **Section 5, Clip 2** — Setting Up the Postman MCP Server |
| Prompt 5 — Install Newman and Run Collection | **Section 5, Clip 5** — Newman CLI |

---

## Prompt 1: Create Postman Collection via MCP
*Used in: Section 5, Clip 3 — "Cursor Creates the Collection via MCP"*

Use this prompt after configuring the Postman MCP server (Prompt 4 below).
Make sure `swagger.json` is in your project folder.

```
Use the Postman MCP to create a new collection in my Postman workspace
called "TechShop API Tests".

Read swagger.json to understand all available endpoints, their request
schemas, required fields, authentication requirements, and documented
response codes.

Based on the spec:
- Create a folder for each tag (Auth, Products, Cart, Orders)
- For each endpoint, generate requests covering:
    - The happy path (valid inputs, correct auth)
    - Every documented error response code (4xx) from the spec
    - Any endpoint marked with bearerAuth security should also have
      a test with no Authorization header asserting 401
- Write pm.test assertions for each request checking the expected status code
- After the login request, save the token from the response body
  into a collection variable called authToken
- Use {{authToken}} in the Authorization header for all endpoints
  that require bearerAuth
- Use {{base_url}} as the base URL variable throughout
```

---

## Prompt 2: Export Collection for Newman
*Used in: Section 5, Clip 5 — "Newman CLI"*

After Cursor creates the collection via MCP, export it for CI use:

```
Export the TechShop API Tests collection from Postman as
techshop.postman_collection.json and save it to the project root.
```

---

## Prompt 3: Fix a Failing Test
*Used in: Section 5, Clip 4 — "Running the Collection and Reading Results"*

If a generated assertion does not match what the spec says:

```
The test for [endpoint] is failing with status [actual] but asserting [expected].
Read swagger.json and check what response code the spec defines for this scenario.
Update the pm.test assertion to match the spec.
```

---

## Prompt 4: Set Up Postman MCP Config
*Used in: Section 5, Clip 2 — "Setting Up the Postman MCP Server"*

Open the Cursor terminal and paste this prompt into the Cursor chat.
Have your Postman API key ready (Postman → Settings → API Keys → Generate).

```
Help me configure the Postman MCP server for Cursor so that Cursor can
create and manage Postman collections directly.

1. Ask me for my Postman API key (do not proceed until I provide it)

2. Detect which AI IDE I am using:
   - If Cursor: create or update ~/.cursor/mcp.json
   - If VS Code: create or update .vscode/mcp.json in the project root
   - If unsure: create ~/.cursor/mcp.json (Cursor default)

3. Write the MCP config with the key I provided:
   For Cursor (~/.cursor/mcp.json):
   {
     "mcpServers": {
       "postman": {
         "command": "npx",
         "args": ["-y", "@postman/mcp-server"],
         "env": {
           "POSTMAN_API_KEY": "<my key here>"
         }
       }
     }
   }

4. Confirm the file was written and show me the path

5. Tell me to fully restart Cursor/my IDE for the MCP server to activate

6. After I confirm I have restarted, tell me to verify in two ways:
   - Open Cursor Settings → Features → MCP and confirm the Postman server
     shows a green status indicator
   - In this chat, type: what MCP tools do you have available?
     and confirm the Postman tools appear in the response
```

---

## Prompt 5: Install Newman and Run Collection
*Used in: Section 5, Clip 5 — "Newman CLI"*

Make sure `techshop.postman_collection.json` is in the project root before running.

```
Help me install Newman and run the Postman collection from the terminal.
Run each step and wait for my confirmation before continuing.

1. Install Newman and the HTML reporter globally:
   npm install -g newman newman-reporter-html

2. Verify the install:
   newman --version

3. Run the collection against the local API:
   newman run techshop.postman_collection.json \
     --env-var base_url=http://localhost:3000 \
     --reporters cli,html \
     --reporter-html-export newman-report.html

4. Tell me how many tests passed and failed from the summary output

5. Confirm that newman-report.html was created in the project folder
```
