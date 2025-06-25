# WorldChef – System Architecture Overview (C4 Level 2)

> Part of Cycle 4 Architectural Formalization (task af_t001_impl).  
> Source of truth: validated ADR library & `aiconfig.json`.

```mermaid
%%{init: {"theme":"default"}}%%
graph LR
  subgraph "Client Tier"
    A["Flutter Mobile&nbsp;App<br/><sub>worldchef_mobile</sub>"]
  end

  subgraph "Backend Tier"
    B["Fastify&nbsp;API&nbsp;Server<br/><sub>backend/</sub>"]
    C[("Supabase&nbsp;Postgres<br/><sub>RLS&nbsp;+&nbsp;Auth</sub>")]
    D[["Edge&nbsp;Functions<br/><sub>nutrition_enrichment·cleanup_jobs</sub>"]]
  end

  subgraph "External Services"
    E["Stripe&nbsp;Hosted&nbsp;Checkout"]
    F["Firebase&nbsp;Cloud&nbsp;Messaging"]
    G["USDA&nbsp;FDC&nbsp;API"]
  end

  A -- "REST / JWT" --> B
  B -- "PostgREST / pg
tcp" --> C
  B -- "Invoke" --> D
  B -- "Webhook" --> E
  B -- "Push" --> F
  D -- "Fetch" --> G

  %% Clickables
  click A "../../mobile/README.md" "Flutter mobile codebase"
  click B "../../backend/README.md" "Fastify backend README"
  click D "../../supabase/functions/nutrition_enrichment/index.ts" "Edge function source"
  click C "https://app.supabase.com/project" "Supabase dashboard"
  click E "https://stripe.com" "Stripe documentation"
  click F "https://firebase.google.com/docs/cloud-messaging" "FCM documentation"
```

This diagram illustrates the primary runtime containers for the MVP:

1. **Flutter Mobile App** – worldchef_* package in the repository
2. **Fastify API Server** – `backend/` project, deployed on Render
3. **Supabase Postgres** – managed relational store with RLS, Auth, Storage
4. **Supabase Edge Functions** – serverless functions for nutrition enrichment & background jobs
5. **External Services** – Stripe, FCM, and USDA API integrations

Links to detailed component views will reside in subsequent diagrams (`backend-api.md`, `mobile-client.md`). 

### Diagram Notes
- **Clickable nodes** (hover & click) take you directly to source code or external docs.
- Aligns with ADR-WCF-003 (Backend), ADR-WCF-001d (Database/BaaS), ADR-WCF-007 (Payments), ADR-WCF-009 (Push).
- This refined diagram improves readability and traceability for technical due-diligence reviewers. 