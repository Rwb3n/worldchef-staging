const express = require('express');
const app = express();
const PORT = process.env.PORT || 10000;

// Health check endpoint - this is what Render will ping
app.get('/healthz', (req, res) => {
  res.status(200).json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    message: 'WorldChef staging API is running'
  });
});

// Basic API endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({ 
    status: 'ok', 
    service: 'worldchef-api',
    environment: 'staging'
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.status(200).json({ 
    message: 'WorldChef Staging API',
    version: '1.0.0',
    health: '/healthz'
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Health check available at /healthz`);
}); 