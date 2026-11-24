# luke-hermes-agent
Production wrapper for Nous Research Hermes Agent backend used by LUKE / ELP GPT

Hermes is installed from DNA Web's fork, [dnawebai/hermes-agent](https://github.com/dnawebai/hermes-agent), at the commit pinned in `HERMES_COMMIT`. The fork's main branch mirrors Nous Research's upstream. To move to a newer Hermes, sync the fork, then change `HERMES_COMMIT`; the build fails unless the fork at exactly that commit is installed.
