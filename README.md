# luke-hermes-agent
Production wrapper for Nous Research Hermes Agent backend used by LUKE / ELP GPT

Hermes is installed from DNA Web's fork, [dnawebai/hermes-agent](https://github.com/dnawebai/hermes-agent), at the commit pinned in `HERMES_COMMIT`. The fork's main branch mirrors Nous Research's upstream. To move to a newer Hermes, sync the fork, then change `HERMES_COMMIT`; the build fails unless the fork at exactly that commit is installed.

## OpenSEO (SEO research for every agent)

The image carries a pinned copy of the 12 [OpenSEO](https://github.com/every-app/open-seo) agent skills in
`skills/openseo/` (source commit and MIT license in `skills/openseo/NOTICE.md` and `LICENSE`). When the
`OPENSEO_API_KEY` variable is set, `start-hermes.sh` adds two things to the Hermes config at every start:

- the `openseo` MCP server at `https://app.openseo.so/mcp` (or `OPENSEO_MCP_URL`, for a self-hosted OpenSEO),
  sending `Authorization: Bearer ${OPENSEO_API_KEY}`. The config holds that reference, not the key; Hermes reads
  the value from the environment;
- `/opt/luke-hermes/skills/openseo` in `skills.external_dirs`, so the skills appear in every session.

Without the variable, Hermes starts exactly as before, with neither. Removing the variable and restarting turns
OpenSEO off again.

To turn it on:

1. Create an OpenSEO account, then an API key under **Settings -> API keys** at https://app.openseo.so/settings.
   The key is shown once and acts as you in the workspace that was active when you made it.
2. Set `OPENSEO_API_KEY` in the Railway service variables of `hermes-agent` (or in Coolify/Kamal for a
   self-hosted stack), then redeploy.

OpenSEO's data comes from DataForSEO, which is pay-as-you-go; the hosted app's own plan and credits apply to
every call the agents make. To update the skills, copy `plugins/openseo/skills/` again from a newer upstream
commit and change the commit in `NOTICE.md`.
