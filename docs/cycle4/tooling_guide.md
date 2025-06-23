# WorldChef Tooling Guide — Cycle 4

> Artifact: cycle4_tooling_guide   |   Generated at g99

This guide enumerates the essential tools & extensions required for productive Cycle-4 development across *dev* and *staging* environments.

---

## 1. Command-line Tooling

| Tool | Min Version | Purpose | Install |
|------|-------------|---------|---------|
| Node.js | 18.x | Build & runtime | https://nodejs.org |
| Deno | 1.43+ | Edge function development & testing | https://deno.com |
| npm | 9.x | Package management | Bundled with Node |
| Docker | 24.x | (Optional) custom image builds | https://docs.docker.com |
| Render CLI | latest | Deploy, secret management | `npm i -g @render/cli` |
| Supabase CLI | 1.0+ | DB migrations & edge functions | `brew` / `npm i -g supabase` |
| Stripe CLI | 1.16+ | Payments webhook testing | https://stripe.com/cli |
| k6 | 0.48+ | Load & perf testing | `brew install k6` / `choco` |
| gh (GitHub CLI) | 2.47+ | Release tags, workflow dispatch | https://cli.github.com |

> Render handles clusters, TLS, autoscaling, health-checks, so tools like `kubectl`, `kustomize`, and `gcloud` are no longer required.

## 2. VS Code Extensions

• ESLint — live linting  
• Prettier — opinionated formatting  
• **Render** — manage services & view logs  
• GitHub Actions — workflow logs inline  
• Supabase — query explorer & SQL snippets  

## 3. Pre-commit Hooks

```bash
npx husky install
npx husky add .husky/pre-commit "npm run lint && npm run test:ci"
```

## 4. Linting & Formatting

• `npm run lint` — ESLint + TypeScript  
• `npm run format` — Prettier write  
• `npm run typecheck` — `tsc --noEmit`

## 5. Local Preview

```bash
npm run dev        # Next.js + Fastify API + edge funcs (reload)
render services logs <service>  # Tail logs from Render (optional)
```

## 6. Deploy Shortcuts

```bash
# First deploy (creates service)
render deploy --from=.

# Trigger redeploy after push
gh workflow run render-deploy.yml -f sha=$(git rev-parse HEAD)
```

---
Happy hacking ― now lighter & faster with Render! 🚀 