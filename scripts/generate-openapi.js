const { build } = require('../backend/dist/server');
const fs = require('fs');
const path = require('path');
const http = require('http');

async function generateOpenApiSpec() {
  const server = await build({ logger: false }); // disable logger for cleaner output

  try {
    // Listen on a random available port
    await server.listen({ port: 0, host: '127.0.0.1' });
    const { port } = server.server.address();

    const specUrl = `http://127.0.0.1:${port}/v1/openapi.json`;
    console.log(`Fetching OpenAPI spec from: ${specUrl}`);

    const response = await new Promise((resolve, reject) => {
      http.get(specUrl, (res) => {
        let data = '';
        res.on('data', (chunk) => { data += chunk; });
        res.on('end', () => resolve(data));
      }).on('error', (err) => reject(err));
    });

    const openApiSpec = JSON.parse(response);
    const outputPath = path.resolve(__dirname, '../docs/api/openapi_v1.json');

    fs.writeFileSync(outputPath, JSON.stringify(openApiSpec, null, 2));
    console.log(`OpenAPI spec generated at: ${outputPath}`);

  } catch (err) {
    console.error('Failed to generate OpenAPI spec:', err);
    process.exit(1);
  } finally {
    await server.close();
  }
}

generateOpenApiSpec();
