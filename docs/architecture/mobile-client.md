# WorldChef – Mobile Client Architecture (Flutter Layered View)

> Cycle 4 Architectural Formalization – task af_t003_impl  
> Reflects validated patterns from ADR-WCF-004, ADR-WCF-025.

```mermaid
%%{init: {"theme":"default"}}%%
graph TD
  UI["UI Layer<br/><sub>ConsumerWidget & Widgets</sub>"]:::ui
  State["State Layer<br/><sub>Riverpod Providers</sub>"]:::state
  Services["Service Layer<br/><sub>API / Cache Services</sub>"]:::service
  Data["Data Sources<br/><sub>Supabase REST | Storage | Hive</sub>"]:::data

  UI -->|ref.watch| State
  State -->|async actions| Services
  Services -->|HTTP / gRPC| Backend[(Fastify API)]:::external
  Services -->|Edge&nbsp;Function&nbsp;HTTP| EdgeFunc[(Nutrition&nbsp;Enrichment)]:::external
  Services --> Hive[(Hive&nbsp;Local&nbsp;DB)]:::external
  Backend --> Supabase[(Supabase&nbsp;Postgres)]:::external

  %% Clickable links
  click UI "../../mobile/lib/screens" "Widget screens"
  click State "../../mobile/lib/providers" "Providers directory"
  click Services "../../mobile/lib/services" "Service layer"
  click Hive "https://pub.dev/packages/hive" "Hive package"
  click Backend "../../backend/README.md" "Backend README"
  click EdgeFunc "../../supabase/functions/nutrition_enrichment/index.ts" "Edge function"

  classDef ui fill:#dfefff,stroke:#007acc,color:#000;
  classDef state fill:#e9ffe9,stroke:#28a745,color:#000;
  classDef service fill:#fff6d5,stroke:#d4ac0d,color:#000;
  classDef data fill:#fde7e9,stroke:#c21807,color:#000;
  classDef external fill:#f9f9f9,stroke:#999,color:#000;
```

### Layer Responsibilities
1. **UI Layer** – Flutter widgets driven by Riverpod; minimal logic.
2. **State Layer** – Riverpod Async/Notifier providers, optimistic updates.
3. **Service Layer** – Dio HTTP clients, retry logic, cache adapters.
4. **Data Sources** – Supabase REST endpoints, Hive offline store, Edge Functions. 