# Staging Environment Secrets & Variables (Cycle 4)

> Artifact: staging_env_config | g110

| Variable | Value / Secret | Notes |
|----------|----------------|-------|
| SUPABASE_URL | https://worldchef-staging.supabase.co | Project ref `myqhpmeprpaukgagktbn` |
| SUPABASE_ANON_KEY | (secret) | Stored in Render secret files |
| DATABASE_URL | (secret) | Supabase service role connection string |
| USDA_API_KEY | NomPDEcHKIOOAKMd1bjRfOBTTeuNjSA8FogNkI7d | Provided 2025-06-13 by user, stored as secret `USDA_API_KEY` |
| OPENAI_API_KEY | (optional) | Only if GPT fallback enabled |

All secrets uploaded to Render → *staging* workspace under **Environment > Secret Files** on 2025-06-13 18:47 UTC. 