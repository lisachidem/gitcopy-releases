# GitCopy

A desktop app for sharing GitHub repos between two people — no server required. Each person signs in with their own GitHub PAT, selects repos to share in a workspace, and syncs via HTTPS.

## Download

**Mac (Apple Silicon):**
```bash
curl -sf https://raw.githubusercontent.com/lisachidem/gitcopy-releases/master/update-mac.sh | bash
```
Downloads, installs to /Applications, and clears Gatekeeper in one step.

**Windows:**
Download the `.exe` installer from the [latest release](https://github.com/lisachidem/gitcopy-releases/releases/latest).

## Features

- Shared workspace — each person picks which repos to expose to the other
- Clone, sync, push/pull via HTTPS + PAT (no SSH setup)
- Repo detail view: file explorer, changes, commit history, branches, pipelines
- Drag-and-drop file upload + commit from inside the app
- Auto-update on Windows; one-command update on Mac
