# WorldChef – Backend API Architecture (Fastify Plugin View)

> Cycle 4 Architectural Formalization – task af_t002_impl  
> Source: `backend/src/` structure, validated ADR-WCF-003, ADR-WCF-015.

```mermaid
%%{init: {"theme":"default"}}%%
graph TD
  subgraph "Fastify Instance"
    A["Server.ts"]:::code
    A -->|register| P1["security_headers_plugin.ts"]:::code
    A -->|register| P2["supabase_plugin.ts"]:::code
    A -->|register| P3["auth_plugin.ts"]:::code
    A -->|register prefix=/v1| R["routes/index.ts"]:::code
  end

  subgraph "Route Groups (/v1)"
    R --> AuthRoutes["auth/"]
    R --> RecipeRoutes["recipes/"]
    R --> PaymentRoutes["payments/"]
    R --> SearchRoutes["search/"]
  end

  Supabase[("Supabase<br/>Postgres + Auth")]:::external
  Stripe[(Stripe&nbsp;API)]:::external
  FCM[(FCM)]:::external
  EdgeFunc[(Nutrition&nbsp;Enrichment<br/>Edge&nbsp;Function)]:::external

  %% Data & control flow
  P2 --> Supabase
  AuthRoutes --> Supabase
  RecipeRoutes --> Supabase
  SearchRoutes --> Supabase
  PaymentRoutes --> Supabase
  PaymentRoutes --> Stripe
  PaymentRoutes --> EdgeFunc
  R -. emits .-> FCM

  %% Clickable nodes
  click A "../../backend/src/server.ts" "Fastify bootstrap"
  click P1 "../../backend/src/plugins/security_headers_plugin.ts" "Security headers plugin"
  click P2 "../../backend/src/plugins/supabase_plugin.ts" "Supabase plugin"
  click P3 "../../backend/src/plugins/auth_plugin.ts" "Auth plugin"
  click R "../../backend/src/routes/v1/index.ts" "Route index"
  click Supabase "https://app.supabase.com/project" "Supabase dashboard"
  click Stripe "https://stripe.com/docs" "Stripe docs"
  click FCM "https://firebase.google.com/docs/cloud-messaging" "FCM docs"
  click EdgeFunc "../../supabase/functions/nutrition_enrichment/index.ts" "Edge function source"

  classDef code fill:#cce5ff,stroke:#0366d6,color:#000;
  classDef external fill:#fff3cd,stroke:#d4ac0d,color:#000; 
```

### Notes
- **Plugins**: Modular concerns (security headers, Supabase client, JWT/auth).  
- **Routes**: Grouped under `/v1/` per ADR-WCF-015 versioning policy.  
- **External Calls**: Payment & notifications handled via Stripe and FCM; recipe nutrition via Edge Function.  
- Diagram intentionally abstracted (C4 Component level) for clarity; deeper sequence diagrams tracked elsewhere. 