# TechShop API — Test Ideas

## GET /products
- Authentication: None required
- Happy path: GET /products with no query params → 200, returns array of Product objects
- Negative tests:
  - GET /products?category=nonexistent-category → 200 with empty array (verify it doesn't error or return unrelated products)
  - GET /products?category=<script>alert(1)</script> or other malformed/injection string → 200 with empty array, no server error, no reflected script

## GET /products/{id}
- Authentication: None required
- Happy path: GET /products/1 (existing ID) → 200, returns matching Product object
- Negative tests:
  - GET /products/99999 (non-existent ID) → 404 Product not found
  - GET /products/abc (non-integer ID) → 400 or 404, not a 500 server error

## GET /orders
- Authentication: Bearer JWT required
- Happy path: GET /orders with valid token → 200, returns array of Order objects for the current user
- Negative tests:
  - GET /orders with no Authorization header → 401 Unauthorized
  - GET /orders with an invalid/expired/malformed token → 401 Unauthorized

## POST /orders
- Authentication: Bearer JWT required
- Happy path: POST /orders with valid token and complete body (items, shipping, payment) → 201, returns created Order
- Negative tests:
  - POST /orders with missing required field (e.g. no `shipping` or empty `items` array) → 400 Validation error
  - POST /orders with invalid payment data (e.g. cardNumber not 16 digits, expiryDate in the past, malformed phone not matching `^\d{10}$`) → 400 Validation error
  - POST /orders with no Authorization header → 401 Unauthorized

## GET /cart
- Authentication: Bearer JWT required
- Happy path: GET /cart with valid token → 200, returns Cart object with items and total
- Negative tests:
  - GET /cart with no Authorization header → 401 Unauthorized
  - GET /cart with invalid/expired token → 401 Unauthorized

## POST /cart
- Authentication: Bearer JWT required
- Happy path: POST /cart with valid token, valid productId and quantity ≥ 1 → 201, item added
- Negative tests:
  - POST /cart with quantity = 0 or negative → 400 Invalid productId or quantity
  - POST /cart with non-existent productId → 404 Product not found
  - POST /cart with no Authorization header → 401 Unauthorized

## PUT /cart/{itemId}
- Authentication: Bearer JWT required
- Happy path: PUT /cart/1 with valid token and quantity ≥ 1 → 200, cart item updated
- Negative tests:
  - PUT /cart/{itemId} with quantity = 0 or negative → 400 Invalid quantity
  - PUT /cart/99999 (non-existent itemId) → 404 Cart item not found
  - PUT /cart/{itemId} with no Authorization header → 401 Unauthorized

## DELETE /cart/{itemId}
- Authentication: Bearer JWT required
- Happy path: DELETE /cart/1 with valid token → 200, item removed from cart
- Negative tests:
  - DELETE /cart/99999 (non-existent itemId) → 404 Cart item not found
  - DELETE /cart/{itemId} with no Authorization header → 401 Unauthorized

## POST /auth/login
- Authentication: None required (this endpoint issues the token)
- Happy path: POST /auth/login with valid email/password (e.g. demo@techshop.com / password123) → 200, returns JWT token and user object
- Negative tests:
  - POST /auth/login with missing email or password → 400 Missing email or password
  - POST /auth/login with incorrect password or unknown email → 401 Invalid credentials
