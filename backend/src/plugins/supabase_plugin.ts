import { FastifyInstance, FastifyPluginOptions } from 'fastify';
import { createClient, SupabaseClient } from '@supabase/supabase-js';
import fp from 'fastify-plugin';

async function supabasePlugin(fastify: FastifyInstance, options: FastifyPluginOptions) {
  const supabaseUrl = process.env.SUPABASE_URL;
  const supabaseServiceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!supabaseUrl || !supabaseServiceRoleKey) {
    fastify.log.error('Supabase URL and Service Role Key must be provided in environment variables.');
    throw new Error('Supabase URL and Service Role Key must be provided.');
  }

  const supabase = createClient(supabaseUrl, supabaseServiceRoleKey);

  fastify.decorate('supabase', supabase);
}

export default fp(supabasePlugin, { name: 'supabase' }); 