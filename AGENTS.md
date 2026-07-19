# AGENTS.md

## Cursor Cloud specific instructions

This repository is a dependency-free static web app (a Korean to-do list, "하루목록") consisting only of `index.html`, `style.css`, and `app.js`. There is no `package.json`, no build step, no lint config, and no automated test suite. State is persisted in the browser via `localStorage` (key `haru-todolist`).

### Running

- Serve the static files rather than opening `index.html` via `file://`, so relative asset paths and `localStorage` behave consistently. From the repo root: `python3 -m http.server 8000`, then open `http://localhost:8000/`.
- The `.bat` files (`설치하기.bat`, `제거하기.bat`) are Windows-only install/uninstall helpers and are irrelevant in this Linux VM.

### Lint / test / build

- None configured. There is nothing to build, no linter, and no test runner. "Testing" means manually exercising add / check / delete in the browser.
