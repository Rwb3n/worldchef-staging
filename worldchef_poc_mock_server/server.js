const express = require('express');
const cors = require('cors');
const jsonServer = require('json-server');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// CORS configuration for development - allow all localhost origins
const corsOptions = {
  origin: function (origin, callback) {
    // Allow requests with no origin (like mobile apps or Postman)
    if (!origin) return callback(null, true);
    
    // Allow all localhost and 127.0.0.1 origins for development
    if (origin.startsWith('http://localhost:') || 
        origin.startsWith('http://127.0.0.1:') ||
        origin.startsWith('https://localhost:') ||
        origin.startsWith('https://127.0.0.1:')) {
      return callback(null, true);
    }
    
    // Allow specific mobile app origins
    const allowedOrigins = [
      'http://localhost:19006', // Expo web default
      'http://localhost:19000', // Expo dev server
      'exp://localhost:19000',  // Expo app protocol
      'http://10.0.2.2:3000',   // Android emulator localhost
    ];
    
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    
    return callback(new Error('Not allowed by CORS'));
  },
  credentials: true,
  optionsSuccessStatus: 200
};

app.use(cors(corsOptions));

// Response time middleware (80-150ms simulation)
app.use((req, res, next) => {
  const delay = Math.floor(Math.random() * 70) + 80; // 80-150ms
  setTimeout(next, delay);
});

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Create JSON Server router
const router = jsonServer.router(path.join(__dirname, 'data', 'recipes.json'));
const middlewares = jsonServer.defaults();

// Use default middlewares (logger, static, cors and no-cache)
app.use(middlewares);

// Add custom routes before JSON Server router
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    endpoints: {
      recipes: '/recipes',
      recipe_by_id: '/recipes/:id'
    }
  });
});

// Use default router
app.use(router);

app.listen(PORT, () => {
  console.log(`WorldChef Mock Server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`Recipes endpoint: http://localhost:${PORT}/recipes`);
  console.log(`Recipe by ID: http://localhost:${PORT}/recipes/:id`);
}); 