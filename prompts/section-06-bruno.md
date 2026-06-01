# Section 6 — Bruno

## Course reference
| Prompt | Used in clip |
|--------|-------------|
| Prompt 1 — Generate Bruno Collection | **Section 6, Clip 2** — Cursor Writes .bru Files Directly |
| Prompt 2 — Add a Missing Test | **Section 6, Clip 3** — Running Bruno Tests and Reading Results |
| Prompt 3 — Fix a .bru Assertion | **Section 6, Clip 3** — Running Bruno Tests and Reading Results |

---

## Prompt 1: Generate Bruno Collection
*Used in: Section 6, Clip 2 — "Cursor Writes .bru Files Directly"*

Use this prompt with your project folder open in Cursor and `swagger.json` present.

```
Read swagger.json to understand all available endpoints, their request
schemas, required fields, authentication requirements, and documented
response codes.

Generate a Bruno collection as .bru files based on the spec.

Create the folder structure:
  techshop-bruno/
    auth/
    products/
    cart/
    orders/
    environments/

In the environments folder, create a file called local.bru that sets:
  baseUrl = http://localhost:3000
  authToken = (empty — will be populated after login)

For each endpoint in the spec, generate one .bru file per test scenario:
- The happy path (valid inputs, correct auth where required)
- Every documented error response code (4xx) listed in the spec
- Any endpoint with bearerAuth security should also have a separate
  .bru file with no Authorization header, asserting 401

Use {{baseUrl}} for the base URL and {{authToken}} for auth headers.

In the login happy-path .bru file, add a post-request script that
reads the token from the response body and sets it as the authToken
environment variable so subsequent requests can use it automatically.

Name each file descriptively, e.g. login-valid.bru, login-wrong-password.bru,
get-product-not-found.bru.
```

---

## Prompt 2: Add a Missing Test
*Used in: Section 6, Clip 3 — "Running Bruno Tests and Reading Results"*

```
Read swagger.json and check if there are any endpoints or documented
error responses that do not yet have a corresponding .bru file in the
techshop-bruno folder. Generate the missing .bru files.
```

---

## Prompt 3: Fix a .bru Assertion
*Used in: Section 6, Clip 3 — "Running Bruno Tests and Reading Results"*

```
The file [filename].bru has a failing assertion. Read swagger.json to check
what status code and response shape the spec defines for this scenario,
then rewrite the test block in the .bru file to match the spec exactly.
```
