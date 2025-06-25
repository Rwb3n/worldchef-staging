# Cookbook: Supabase Authentication Integration

**Pattern:** Supabase Auth for User Management (Client) & JWT Validation (Backend)
**Source:** ADR-WCF-005, PoC #2
**Validated in:** Cycle 4

This is the canonical pattern for user onboarding and session management.

### 1. Frontend: Flutter Client Authentication

The `supabase-flutter` package handles sign-up, sign-in, session persistence, and token refreshes automatically.

```dart
// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // Listen to auth state changes globally
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  User? get currentUser => _supabase.auth.currentUser;

  Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get the current valid JWT to send to the Fastify backend
  Future<String?> getJwt() async {
    return _supabase.auth.currentSession?.accessToken;
  }
}
```
### 2. Frontend: Flutter Auth State Management (Riverpod)
Listen to the authStateChanges stream to reactively build the UI.
```dart
// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provides the current auth state stream
final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

// Provides the current user, or null if logged out
final userProvider = Provider<User?>((ref) {
  final asyncAuthState = ref.watch(authStateProvider);
  return asyncAuthState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});
```
### 3. Backend: Fastify JWT Validation
The Fastify backend must validate the JWT from the client using Supabase's public JWKS URL. This avoids sharing secrets.

#### 4. Backend: OpenAPI Schema Integration (Recommended)
Integrate JSON schemas with your auth routes to enable automatic OpenAPI documentation, request validation, and type safety.

##### JSON Schemas
```typescript
// src/schemas/auth_schemas.ts
export const signupSchema = {
  summary: 'Create new user account',
  tags: ['auth'],
  description: 'Register a new user with email and password',
  body: {
    type: 'object',
    required: ['email', 'password'],
    properties: {
      email: { type: 'string', format: 'email' },
      password: { type: 'string', minLength: 8 }
    }
  },
  response: {
    201: {
      description: 'Successful signup',
      type: 'object',
      properties: {
        user: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            email: { type: 'string', format: 'email' }
          }
        },
        access_token: { type: 'string' },
        refresh_token: { type: 'string' }
      }
    },
    400: { /* ... error schema ... */ }
  }
};
// ... other schemas for login, etc.
```

##### Auth Routes with Schemas
```typescript
// src/routes/v1/auth/index.ts
import { FastifyInstance, FastifyPluginOptions } from 'fastify';
import { SupabaseClient } from '@supabase/supabase-js';
import { signupSchema, loginSchema } from '../../schemas/auth_schemas';

async function authRoutes(fastify: FastifyInstance, options: FastifyPluginOptions) {
  const supabase: SupabaseClient = fastify.supabase;

  // Apply schema to the route
  fastify.post('/signup', { schema: signupSchema }, async (request, reply) => {
    const { email, password } = request.body as any;
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
    });

    if (error) {
      return reply.status(400).send(error);
    }
    return reply.status(201).send(data);
  });

  fastify.post('/login', async (request, reply) => {
    const { email, password } = request.body as any;
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      return reply.status(401).send(error);
    }
    return reply.send(data);
  });
}

// ✅ Direct export for route registration (preserves prefix)
export default authRoutes;
```

#### Authentication Plugin (Global Decorator)
```typescript
// src/plugins/auth_plugin.ts
import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import fp from 'fastify-plugin';
import jwt from 'jsonwebtoken';
import jwksClient from 'jwks-rsa';

const client = jwksClient({
  jwksUri: `https://<YOUR-PROJECT-REF>.supabase.co/auth/v1/jwks`,
});

function getKey(header: any, callback: any) {
  client.getSigningKey(header.kid, (err, key) => {
    const signingKey = key.getPublicKey();
    callback(null, signingKey);
  });
}

async function authPlugin(fastify: FastifyInstance) {
  fastify.decorate('authenticate', async (req: FastifyRequest, reply: FastifyReply) => {
    try {
      const token = req.headers.authorization?.replace('Bearer ', '');
      if (!token) throw new Error('No token provided');

      const decoded = await new Promise((resolve, reject) => {
        jwt.verify(token, getKey, {}, (err, decoded) => {
          if (err) return reject(err);
          resolve(decoded);
        });
      });

      // Attach user info to the request for handlers to use
      (req as any).user = decoded;

    } catch (err) {
      reply.code(401).send({ error: 'Authentication failed' });
    }
  });
}

// ✅ Use fp() for global decorators
export default fp(authPlugin, {
  dependencies: ['supabase']
});
```

#### Server Registration
```typescript
// src/server.ts
import authPlugin from './plugins/auth_plugin';
import authRoutes from './routes/v1/auth';

// Register global auth plugin
await server.register(authPlugin);

// Register auth routes with prefix
await server.register(authRoutes, { prefix: '/v1/auth' });
// Routes available at: /v1/auth/signup, /v1/auth/login
```

**⚠️ Critical:** Never use `fp()` wrapper for route-defining plugins as it bypasses prefix configuration. See the [Fastify Plugin Registration Pattern](fastify_plugin_route_prefix_pattern.md) for details.

**🔗 Related Pattern:** For a full implementation, see the [Fastify OpenAPI/Swagger Integration Pattern](./fastify_openapi_swagger_integration_pattern.md).