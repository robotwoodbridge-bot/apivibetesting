# Section 4 — Map the API Spec to Test Ideas

## Course reference
| Prompt | Used in clip |
|--------|-------------|
| Prompt 1 — Map Endpoints to Test Ideas | **Section 4, Clip 3** — Using Cursor to Map the Spec to Test Ideas |

---

## Prompt 1: Map Endpoints to Test Ideas
*Used in: Section 4, Clip 3 — "Using Cursor to Map the Spec to Test Ideas"*

Use this prompt after adding `swagger.json` to your project folder.

```
Read the swagger.json file in this project. List all the API endpoints and for each one identify:
- The happy path test
- At least two negative tests
- Any authentication requirements

Format it as a plain test ideas list, one endpoint per block.
```

### Expected output structure

```
POST /auth/login
  Happy path: valid email and password → 200 with token
  Negative: wrong password → 401
  Negative: missing email field → 400
  Auth: none required

GET /products
  Happy path: returns 200 with array of products
  Negative: invalid category filter → 200 with empty array (or 400)
  Auth: none required

GET /products/{id}
  Happy path: valid ID → 200 with product object
  Negative: non-existent ID (e.g. 999) → 404
  Auth: none required

POST /cart
  Happy path: valid token + productId + quantity → 201
  Negative: negative quantity → 400
  Negative: no token → 401
  Negative: out-of-stock product → 400
  Auth: Bearer token required

PUT /cart/{itemId}
  Happy path: valid token + valid itemId + quantity → 200
  Negative: quantity less than 1 → 400
  Negative: non-existent itemId → 404
  Auth: Bearer token required

DELETE /cart/{itemId}
  Happy path: valid token + valid itemId → 200
  Negative: no token → 401
  Negative: non-existent itemId → 404
  Auth: Bearer token required

POST /orders
  Happy path: valid token + items + shipping + payment → 201
  Negative: expired card expiry date → 400
  Negative: invalid card number (not 16 digits) → 400
  Negative: missing shipping fields → 400
  Auth: Bearer token required
```
