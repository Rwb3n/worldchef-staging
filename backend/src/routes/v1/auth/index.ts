import { createClient } from '@supabase/supabase-js';
import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';

// This would be initialized once in a real app, maybe in a plugin
const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!);

type AuthBody = {
  email?: string;
  password?: string;
}

async function authRoutes(fastify: FastifyInstance, options: any) {

  // SIGN UP
  fastify.post('/signup', async (request: FastifyRequest<{ Body: AuthBody }>, reply: FastifyReply) => {
    const { email, password } = request.body;

    if (!email || !password) {
      return reply.code(400).send({ error: 'Email and password are required' });
    }

    const { data, error } = await supabase.auth.signUp({
      email: email,
      password: password,
    });

    if (error) {
      return reply.code(error.status || 500).send({ error: error.message });
    }
    
    if (data.user && data.user.aud !== 'authenticated') {
      return reply.code(200).send({ message: 'Sign up successful, please check your email to confirm.' });
    }
    
    return reply.code(201).send(data);
  });

  // SIGN IN
  fastify.post('/login', async (request: FastifyRequest<{ Body: AuthBody }>, reply: FastifyReply) => {
    const { email, password } = request.body;

    if (!email || !password) {
      return reply.code(400).send({ error: 'Email and password are required' });
    }

    const { data, error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password,
    });

    if (error) {
      return reply.code(error.status || 401).send({ error: error.message });
    }

    return reply.code(200).send(data);
  });

  // Example of a protected route
  fastify.get('/me', { preHandler: [ (fastify as any).authenticate] }, async (request, reply) => {
    // The `authenticate` preHandler from our plugin runs first.
    // If the token is valid, `request.user` will be populated.
    return (request as any).user;
  });
}

export default authRoutes; 