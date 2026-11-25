# OpenSEO skills (vendored)

These 12 skill folders are a pinned, unmodified copy of the OpenSEO agent skills.

- Source: https://github.com/every-app/open-seo, folder `plugins/openseo/skills/`
- Commit: `6f68494e92a695db17f4b22da25e84b9bf1e582c` (tag `v0.1.32`)
- License: MIT, Copyright (c) 2026 Ben Senescu. The full notice is in `LICENSE` beside this file and must stay with the copy.

Each `SKILL.md` is kept exactly as published. Don't edit them here: to update, copy the folders again from a newer
upstream commit, then change the commit above.

The skills call the OpenSEO MCP server's tools. `start-hermes.sh` lists this folder in `skills.external_dirs` and adds the
`openseo` MCP server only when `OPENSEO_API_KEY` is set, so without a key the agent sees neither.
