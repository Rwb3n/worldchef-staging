import { FastifyInstance, FastifyPluginOptions } from 'fastify';
import { SupabaseClient } from '@supabase/supabase-js';
import fp from 'fastify-plugin';

async function authRoutes(fastify: FastifyInstance, options: FastifyPluginOptions) {
  const supabase: SupabaseClient = fastify.supabase;

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

export default fp(authRoutes, {
  dependencies: ['supabase']
}); 