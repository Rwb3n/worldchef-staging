# Fastify Image Upload Endpoint – `/v1/images/upload`

Task: stg_t006_c004  
Event: g131

```ts
// src/routes/images.ts (stub)
fastify.post('/v1/images/upload', async (req, reply) => {
  const { file, path } = await req.saveRequestFiles(); // fastify-multer or similar
  const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!);
  const { error } = await supabase.storage.from('worldchef').upload(path, file);
  if (error) throw error;
  const publicURL = `${process.env.SUPABASE_URL}/storage/v1/object/public/worldchef/${path}`;
  reply.send({ url: publicURL });
});
```

• Accepts multipart/form-data file.  
• Generates canonical filename `<recipe_id>/hero.jpg` etc.  
• Returns public CDN URL.

Edge-function resize TBD (prod). 