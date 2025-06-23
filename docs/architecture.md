# WorldChef Validated Architecture (Cycle 4)

**Source of Truth:** This diagram is generated from the validated decisions in `aiconfig.json`.

```mermaid
graph TD
    subgraph "Mobile Client (Flutter)"
        FlutterApp[📱 WorldChef Flutter App<br><b>Stack:</b> Flutter/Riverpod]
    end

    subgraph "Backend Services"
        FastifyAPI[⚙️ Fastify API Server<br><b>Stack:</b> Node.js/TypeScript]
        SupabaseBaaS[☁️ Supabase BaaS]
    end

    subgraph "Third-Party Integrations"
        Stripe[💳 Stripe]
        FCM[🔥 Firebase Cloud Messaging]
    end

    subgraph "Database & BaaS (Supabase)"
        PostgresDB[(🐘 PostgreSQL)]
        Auth[🔐 Supabase Auth]
        Storage[📦 Supabase Storage]
        EdgeFunctions[⚡ Edge Functions]
    end

    %% Data Flows
    FlutterApp -->|HTTPS/REST<br><i>(per ADR-015)</i>| FastifyAPI
    FlutterApp -->|Client SDK<br><i>(per ADR-005, 001d)</i>| Auth
    FlutterApp -->|Client SDK<br><i>(per ADR-001d)</i>| Storage

    FastifyAPI -->|JWT Validation<br><i>(per ADR-005)</i>| Auth
    FastifyAPI -->|SQL via supabase-js<br><i>(per ADR-003)</i>| PostgresDB
    FastifyAPI -->|Invokes| EdgeFunctions
    FastifyAPI -->|API Calls<br><i>(Needs PoC #4)</i>| Stripe
    FastifyAPI -->|API Calls<br><i>(Needs PoC #4)</i>| FCM

    EdgeFunctions -->|SQL via Deno Lib| PostgresDB