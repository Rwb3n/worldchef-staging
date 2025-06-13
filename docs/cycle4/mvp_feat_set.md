MVP Feature Set & User Flows
Feature Set:
User Onboarding – Sign-up, login/logout, password reset
Recipe Feed – Paginated list of public recipes with filtering (cuisine, dietary tags)
Recipe Detail – View ingredients, steps, nutritional info; like/favorite
Recipe Creation – Form-based recipe submission with image upload and JSONB ingredient modeling
Payments – One-time purchase checkout flow via Stripe stub
Search – Full-text search over titles and ingredients with typo tolerance
Push Notifications – Opt-in prompt, token registration, deep-linking to recipe detail
User Flows:
Onboarding Flow: Launch app → Sign-up/login screen → Email verification → Home feed
Discovery Flow: Home feed → Search input → Filter application → Recipe detail → Like/favorite
Creation Flow: Tap “Create” → Recipe form → Preview → Submit → Confirmation screen
Purchase Flow: Recipe behind paywall → Tap “Buy” → Checkout screen → Confirmation → Access granted
Engagement Flow: Grant push permission → Receive notification → Tap notification → Navigate to recipe detail

MVP Feature to API Endpoint Mapping:
Feature
API Endpoint
Method
Notes
User Onboarding
POST /v1/auth/signup
POST
Creates user account


POST /v1/auth/login
POST
Returns JWT


POST /v1/auth/logout
POST
Invalidates token
Recipe Feed
GET /v1/recipes
GET
Supports pagination & filters
Recipe Detail
GET /v1/recipes/{recipeId}
GET
Includes nutritional info & stats
Recipe Creation
POST /v1/recipes
POST
Accepts JSONB payload + multipart
Payments
POST /v1/payments/checkout
POST
Stripe checkout-session stub
Search
GET /v1/search?query={q}
GET
Full-text search with typo tolerance
Push Notifications
POST /v1/users/me/device-tokens
POST
Registers device token


POST /v1/notifications
POST
Sends test notification


Staging Environment Definition:
Infrastructure: Dedicated staging namespace/clusters matching production architecture (Fastify servers, Supabase Postgres, edge-functions, search-index nodes)
Configuration: Uses staging-specific environment variables, feature-flag toggles disabled by default, payment hooks pointed to Stripe test mode
Data: Synthetic dataset seeded daily reflecting representative user and recipe data; scrubbed PII
Access Control: VPN or SSO-restricted access; separate credentials from production
CI/CD Integration: Automatic deployment from staging branch on merge; rollback strategy via GitHub Actions
Monitoring & Alerts: Resource usage, error rates, and performance metrics sent to dashboard; critical alerts routed to on-call Slack channel
Domain & SSL: staging.worldchef.example.com with trusted TLS certificates managed by DevOps

