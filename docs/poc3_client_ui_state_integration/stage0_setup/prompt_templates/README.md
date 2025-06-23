# AI Prompt Templates (Stage 0)

This folder stores reusable prompt templates that accelerate Riverpod provider/mutation code generation.

## How to Use
1. Copy the desired template into your prompt editor.
2. Replace PLACEHOLDER sections (e.g., <ProviderName>, <Endpoint>, <CacheInvalidations>). 
3. Execute with your AI tool; review output for compile errors.

## Template List
- `async_notifier_provider.prompt.txt` – Fetch providers with loading/error states.
- `mutation_provider_optimistic.prompt.txt` – Pattern for optimistic mutation with rollback.
- `notifier_ui_store.prompt.txt` – Synchronous UI state store.

Add new templates using snake_case naming; update this README accordingly.

---
*Template generated: 2025-06-13* 