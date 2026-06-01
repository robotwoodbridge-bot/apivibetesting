# Section 5 — Postman + Newman

## Course reference
| Prompt | Used in clip |
|--------|-------------|
| Prompt 1 — Create Postman Collection via MCP | **Section 5, Clip 3** — Cursor Creates the Collection via MCP |
| Prompt 2 — Export Collection for Newman | **Section 5, Clip 5** — Newman CLI (before running Newman) |
| Prompt 3 — Fix a Failing Test | **Section 5, Clip 4** — Running the Collection and Reading Results |

---

## Prompt 1: Create Postman Collection via MCP
*Used in: Section 5, Clip 3 — "Cursor Creates the Collection via MCP"*

Use this prompt after configuring the Postman MCP server (see `snippets/mcp-setup-instructions.md`).
Make sure `swagger.json` is in your project folder (download it from `http://localhost:3000/swagger.json`).

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
*Used in: Section 5, Clip 5 — "Newman CLI" (before running Newman)*

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
