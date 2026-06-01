# Section 3 — Setup

## Course reference
| Prompt | Used in clip |
|--------|-------------|
| Prompt 1 — SSH Setup and Clone | **Section 3, Clip 1** — Fork and Clone the Course Repo |

---

## Prompt 1: SSH Setup and Clone
*Used in: Section 3, Clip 1 — "Fork and Clone the Course Repo"*

Open Cursor with any empty folder. Open the terminal inside Cursor (Ctrl+` on Windows/Linux, Cmd+` on Mac) and paste this prompt into the Cursor chat:

```
I need to set up SSH authentication for GitHub and clone a course repository.
Help me do this step by step in the terminal.

1. Check if I already have an SSH key at ~/.ssh/id_ed25519.pub
2. If not, generate one with: ssh-keygen -t ed25519 -C "my-email"
3. Show me the command to copy my public key to the clipboard
   (use pbcopy on Mac, clip on Windows, xclip on Linux)
4. Remind me to add the key to GitHub at:
   github.com → Settings → SSH and GPG keys → New SSH key
5. Test the connection with: ssh -T git@github.com
6. Fork the course repo at https://github.com/homolamartin1-ai/apivibetesting
   then clone MY fork using SSH:
   git clone git@github.com:MY-USERNAME/apivibetesting.git
7. Open the cloned folder in Cursor

Run each step one at a time and wait for my confirmation before continuing.
```

The full command reference is also available at `snippets/ssh-github-setup.sh` if you prefer to follow along without the prompt.
