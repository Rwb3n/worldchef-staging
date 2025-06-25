// backend/scripts/export-openapi.ts
// Pattern: OpenAPI export script | Source: ADR-WCF-015 §XIV | ADR-WCF-015 compliance

import * as fs from 'fs';
import * as path from 'path';
import Fastify from 'fastify';
import swaggerPlugin from '../src/plugins/swagger_plugin';
import { signupSchema, loginSchema } from '../src/schemas/auth_schemas';

async function exportOpenAPI() {
  try {
    console.log('Building minimal Fastify server for OpenAPI export...');
    
    // Create minimal server without Supabase dependencies
    const app = Fastify({ logger: false });
    
    // Register only swagger plugin
    await app.register(swaggerPlugin);
    
    // Register minimal auth routes with schemas for OpenAPI generation
    await app.register(async function (fastify) {
      fastify.post('/v1/auth/signup', { schema: signupSchema }, async (request, reply) => {
        return { message: 'OpenAPI export - endpoint not implemented' };
      });
      
      fastify.post('/v1/auth/login', { schema: loginSchema }, async (request, reply) => {
        return { message: 'OpenAPI export - endpoint not implemented' };
      });
    });
    
    await app.ready();
    
    console.log('Generating OpenAPI specification...');
    const spec = app.swagger();
    
    // Create docs/api directory
    const apiDir = path.join(__dirname, '../../docs/api');
    fs.mkdirSync(apiDir, { recursive: true });
    
    // Write OpenAPI spec to file
    const specPath = path.join(apiDir, 'openapi_v1.json');
    fs.writeFileSync(specPath, JSON.stringify(spec, null, 2));
    
    console.log(`OpenAPI spec exported to: ${specPath}`);
    console.log('Export completed successfully!');
    
    await app.close();
    process.exit(0);
  } catch (error) {
    console.error('Error exporting OpenAPI spec:', error);
    process.exit(1);
  }
}

exportOpenAPI(); 