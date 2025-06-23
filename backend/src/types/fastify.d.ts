import { SupabaseClient } from '@supabase/supabase-js';

declare module 'fastify' {
  export interface FastifyInstance {
    supabase: SupabaseClient;
  }
} 