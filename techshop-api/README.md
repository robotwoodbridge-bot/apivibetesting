# TechShop API

REST API for the TechShop e-commerce store. Used in the **Vibetesting in 2026: API Testing with AI Tools** course.

Two versions ship with this repo:
- `broken-app/` — contains 5 deliberately planted bugs for students to find through testing
- `fixed-app/` — all bugs resolved, used for the verification section

---

## Running the API

```bash
# Install dependencies (same for both versions)
cd broken-app   # or fixed-app
npm install
npm start
```

The API runs on **http://localhost:3000**

| URL | Description |
|-----|-------------|
| http://localhost:3000/docs | Swagger UI — interactive API docs |
| http://localhost:3000/swagger.json | Raw OpenAPI spec |
| http://localhost:3000/health | Health check |

---

## Endpoints

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | /auth/login | — | Login, returns JWT token |
| GET | /products | — | List all products |
| GET | /products/:id | — | Get single product |
| GET | /cart | Bearer | Get current user's cart |
| POST | /cart | Bearer | Add item to cart |
| PUT | /cart/:itemId | Bearer | Update cart item quantity |
| DELETE | /cart/:itemId | Bearer | Remove item from cart |
| GET | /orders | Bearer | List user's orders |
| POST | /orders | Bearer | Place an order (checkout) |

---

## Test Credentials

| Email | Password |
|-------|----------|
| demo@techshop.com | password123 |
| admin@techshop.com | admin123 |

---

## Planted Bugs (broken-app only)

> **Instructor reference — do not share with students before the testing section.**

| ID | Endpoint | Bug | Expected behaviour |
|----|----------|-----|--------------------|
| B1 | POST /auth/login | Returns 200 + token even when password is wrong | Should return 401 for invalid credentials |
| B2 | POST /cart | Accepts negative quantities (e.g. -5) | Should return 400 if quantity < 1 |
| B3 | GET /products/:id | Returns 500 (unhandled TypeError) for non-existent product | Should return 404 |
| B4 | DELETE /cart/:itemId | No auth token required — endpoint is publicly accessible | Should return 401 without a valid Bearer token |
| B5 | POST /orders | Accepts expired card expiry dates (e.g. 01/20) | Should return 400 with "Card has expired" |

---

## Tech Stack

- Node.js + Express.js
- JWT authentication (jsonwebtoken)
- OpenAPI 3.0 spec via swagger-jsdoc
- In-memory data store (no database — resets on server restart)
