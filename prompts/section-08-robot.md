# Section 8 — Robot Framework

## Course reference
| Prompt | Used in clip |
|--------|-------------|
| Prompt 1 — Generate the Full Test Suite | **Section 8, Clip 2** — Cursor Generates the Test Suite |
| Prompt 2 — Override BASE_URL from Command Line | **Section 8, Clip 3** — Running Robot Framework and Reading the Report |
| Prompt 3 — Extract Keywords to a Resource File | **Section 8, Clip 4** — When Robot Framework Fits and When It Does Not |
| Prompt 4 — Check Coverage Against the Spec | **Section 8, Clip 2** — Cursor Generates the Test Suite |

---

## Prompt 1: Generate the Full Robot Framework Test Suite
*Used in: Section 8, Clip 2 — "Cursor Generates the Test Suite"*

Make sure `swagger.json` is in your project folder and `.env` is set up (see `snippets/env-setup.md`).

```
Read swagger.json to understand all available endpoints, their request
schemas, required fields, authentication requirements, and documented
response codes.

Generate a Robot Framework test suite in a file called techshop.robot
using RequestsLibrary.

Requirements:
- Settings section: import RequestsLibrary, Collections, and OperatingSystem
- Variables section (no default credential values — read from environment):
    ${BASE_URL}    %{BASE_URL}
    ${EMAIL}       %{TEST_EMAIL}
    ${PASSWORD}    %{TEST_PASSWORD}
- Keywords section: define a keyword called Get Auth Token that:
    - POSTs to the login endpoint with ${EMAIL} and ${PASSWORD}
    - Asserts status is 200
    - Returns the token value from the response JSON body
- Test Cases section: for each endpoint in the spec, write test cases covering:
    - The happy path (valid inputs, correct auth where required)
    - Every documented 4xx response code listed in the spec
    - Any endpoint marked with bearerAuth security should also have a
      test case with no Authorization header asserting status 401
- Use Suite Setup to create the HTTP session once before all tests
- Use Suite Teardown to delete the session after all tests
- Name test cases in plain readable English, e.g.:
    Login With Valid Credentials Returns Token
    Login With Wrong Password Returns 401
    Get Product With Unknown ID Returns 404
- Never hardcode credentials or secrets inside the .robot file
```

---

## Prompt 2: Override BASE_URL from Command Line
*Used in: Section 8, Clip 3 — "Running Robot Framework and Reading the Report"*

```
Modify techshop.robot so that BASE_URL can be overridden from the
command line using --variable BASE_URL:http://staging.techshop.com
without changing the file itself.
```

---

## Prompt 3: Extract Keywords to a Resource File
*Used in: Section 8, Clip 4 — "When Robot Framework Fits and When It Does Not"*

```
Refactor techshop.robot to move the Get Auth Token keyword and the
session setup/teardown into a separate resource file called
techshop_keywords.robot. Import it in techshop.robot with:
  Resource    techshop_keywords.robot
Keep the Test Cases section in techshop.robot unchanged.
```

---

## Prompt 4: Check Coverage Against the Spec
*Used in: Section 8, Clip 2 — "Cursor Generates the Test Suite"*

```
Read swagger.json and compare its endpoints and documented response codes
against the test cases in techshop.robot.

List any endpoints or response codes from the spec that are not yet
covered by a test case, and generate the missing test cases.
```
