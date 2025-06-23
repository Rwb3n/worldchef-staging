const fastify = require('fastify')({ logger: true });

fastify.get('/ping', async (request, reply) => {
  return { ok: true, ts: Date.now() };
});

fastify.post('/echo', async (request, reply) => {
  return { body: request.body };
});

const start = async () => {
  try {
    const addr = await fastify.listen({ port: process.env.PORT || 3333, host: '0.0.0.0' });
    console.log(`Fastify server running at ${addr}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start(); 