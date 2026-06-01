# Section 7 — Python + pytest + requests

## Course reference
| Prompt | Used in clip |
|--------|-------------|
| Prompt 1 — Generate the Full Test Suite | **Section 7, Clip 2** — Cursor Writes the Test Suite |
| Prompt 2 — Add Parametrize for Boundary Values | **Section 7, Clip 4** — Fixtures, Parametrize, and How Cursor Structures the Code |
| Prompt 3 — Add pytest.ini Config | **Section 7, Clip 3** — Running pytest and Reading the Output |
| Prompt 4 — Check Coverage Against the Spec | **Section 7, Clip 4** — Fixtures, Parametrize, and How Cursor Structures the Code |

---

## Prompt 1: Generate the Full Test Suite
*Used in: Section 7, Clip 2 — "Cursor Writes the Test Suite"*

Make sure `swagger.json` is in your project folder and `.env` is set up (see `snippets/env-setup.md`).

```
Read swagger.json to understand all available endpoints, their request
schemas, required fields, authentication requirements, and documented
response codes.

Generate a pytest test suite in a file called test_techshop.py
using the requests library.

Requirements:
- At the top of the file, load environment variables using python-dotenv:
    from dotenv import load_dotenv
    load_dotenv()
- Set BASE_URL = os.getenv("BASE_URL", "http://localhost:3000")
- Write a pytest fixture called auth_token that:
    - reads credentials from environment variables:
        email = os.getenv("TEST_EMAIL")
        password = os.getenv("TEST_PASSWORD")
    - raises a clear error if either variable is not set
    - posts to the login endpoint with those credentials
    - asserts the response is 200
    - returns the token string from the response JSON
- For each endpoint in the spec, write test functions covering:
    - The happy path (valid inputs, correct auth where required)
    - Every documented 4xx response code listed in the spec
    - Any endpoint marked with bearerAuth security should also have
      a test with no Authorization header asserting 401
- Use the auth_token fixture in any test that requires authentication
- Name test functions descriptively, e.g.:
    test_login_valid_credentials
    test_login_wrong_password_returns_401
    test_get_product_not_found_returns_404
- Never hardcode credentials, tokens, or secrets anywhere in the test file
```

---

## Prompt 2: Add Parametrize for Boundary Values
*Used in: Section 7, Clip 4 — "Fixtures, Parametrize, and How Cursor Structures the Code"*

```
Read swagger.json and look at the minimum/maximum constraints defined
in the request schemas (e.g. quantity minimum: 1).

For any field with a minimum or maximum constraint, add a
@pytest.mark.parametrize test that runs the same negative test with
multiple boundary values (e.g. 0, -1, -100 for a field with minimum 1).
```

---

## Prompt 3: Add pytest.ini Config
*Used in: Section 7, Clip 3 — "Running pytest and Reading the Output"*

```
Create a pytest.ini file in the project root with:
- testpaths = .
- addopts = -v --html=pytest-report.html --self-contained-html

This ensures every pytest run automatically generates an HTML report.
```

---

## Prompt 4: Check Coverage Against the Spec
*Used in: Section 7, Clip 4 — "Fixtures, Parametrize, and How Cursor Structures the Code"*

```
Read swagger.json and compare its endpoints and documented response codes
against the test functions in test_techshop.py.

List any endpoints or response codes from the spec that are not yet
covered by a test, and generate the missing test functions.
```
