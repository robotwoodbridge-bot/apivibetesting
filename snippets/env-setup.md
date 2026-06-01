# Credentials Setup — Keep Secrets Out of Your Code

All test suites in this course read credentials from environment variables.
Never hardcode usernames, passwords, or tokens in test files, prompts, or commits.

---

## Local development — .env file

1. Copy `.env.example` to a new file called `.env` in your project root:

```bash
cp snippets/.env.example .env
```

2. Open `.env` and fill in your values:

```
BASE_URL=http://localhost:3000
TEST_EMAIL=demo@techshop.com
TEST_PASSWORD=password123
```

3. Confirm `.env` is in your `.gitignore` (it is included in `snippets/.gitignore`).
   This prevents credentials from ever being committed to Git.

---

## How each tool reads the .env file

### Python (pytest)

Install python-dotenv:

```bash
pip install python-dotenv
```

At the top of `test_techshop.py`:

```python
import os
from dotenv import load_dotenv

load_dotenv()

BASE_URL = os.getenv("BASE_URL", "http://localhost:3000")
```

In fixtures:

```python
@pytest.fixture
def auth_token():
    email = os.getenv("TEST_EMAIL")
    password = os.getenv("TEST_PASSWORD")
    if not email or not password:
        raise ValueError("TEST_EMAIL and TEST_PASSWORD must be set in .env")
    ...
```

### Robot Framework

Robot Framework reads environment variables with `%{VAR_NAME}`:

```robot
*** Variables ***
${BASE_URL}    %{BASE_URL}
${EMAIL}       %{TEST_EMAIL}
${PASSWORD}    %{TEST_PASSWORD}
```

Load the `.env` file before running:

```bash
# Mac / Linux — export variables from .env before running robot
export $(cat .env | xargs) && robot techshop.robot

# Or use the dotenv CLI tool:
pip install dotenv-cli
dotenv run -- robot techshop.robot
```

### Bruno

Bruno reads environment variables from its environment files (`local.bru`).
Set `authToken` via the post-request script after login — never put it directly
in the environment file.

For the base URL, use the `local.bru` environment file (not tracked in Git
if you add `techshop-bruno/environments/local.bru` to `.gitignore`):

```
vars {
  baseUrl: http://localhost:3000
  authToken:
}
```

### Postman

In Postman, credentials live in environment variables set via the GUI —
never in the collection JSON that gets committed to Git.

Create a Postman environment called `Local` with variables:
- `base_url` = `http://localhost:3000`

The `authToken` variable is set automatically by the login request's
post-request script — it is never stored in a committed file.

---

## CI — GitHub Actions Secrets

In GitHub Actions, credentials come from repository secrets, not from `.env`.

1. Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret** and add:
   - `TEST_EMAIL`
   - `TEST_PASSWORD`

3. Reference them in your workflow file:

```yaml
env:
  BASE_URL: http://localhost:3000
  TEST_EMAIL: ${{ secrets.TEST_EMAIL }}
  TEST_PASSWORD: ${{ secrets.TEST_PASSWORD }}
```

The `.env` file is never used in CI. Secrets are injected at runtime by GitHub
and are never visible in logs or artifacts.
