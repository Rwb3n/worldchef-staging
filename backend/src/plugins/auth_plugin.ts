import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import fp from 'fastify-plugin';
import jwt from 'jsonwebtoken';
import jwksClient from 'jwks-rsa';

const client = jwksClient({
  jwksUri: `${process.env.SUPABASE_URL}/auth/v1/jwks`,
});

function getKey(header: any, callback: any) {
  client.getSigningKey(header.kid, (err, key) => {
    if (err || !key) {
      return callback(err || new Error('Signing key not found.'));
    }
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
      const message = err instanceof Error ? err.message : 'An unknown error occurred';
      reply.code(401).send({ error: 'Authentication failed', details: message });
    }
  });
}

export default fp(authPlugin);