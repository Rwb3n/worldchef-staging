import { FastifyInstance, FastifyPluginOptions } from 'fastify';
import { SupabaseClient } from '@supabase/supabase-js';

export default async function (fastify: FastifyInstance, options: FastifyPluginOptions) {
  if (!fastify.supabase) {
    throw new Error('Supabase client not available. Make sure the auth_plugin is registered.');
  }
  const supabase: SupabaseClient = fastify.supabase;

  fastify.get('/health', async (request, reply) => {
    return reply.code(200).send({ status: 'ok' });
  });

  fastify.post('/signup', async (request, reply) => {
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