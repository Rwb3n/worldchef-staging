# WorldChef PoC Mock Data Server

Mock API server providing consistent recipe data for both Flutter and React Native PoC implementations.

## Overview

This server provides RESTful API endpoints serving identical JSON data to both mobile application PoCs, enabling fair performance and development experience comparison.

## Quick Start

```bash
# Install dependencies
npm install

# Start the server
npm start

# Start with auto-reload (development)
npm run dev
```

## Server Configuration

### Base URL
- **Production**: `http://localhost:3000`
- **Development**: `http://localhost:3000`

### Default Port
- **Port**: `3000` (configurable via `PORT` environment variable)

### Response Time Configuration
- **Simulated Latency**: 80-150ms (randomized)
- **Purpose**: Realistic network conditions for performance testing

## API Endpoints

### Health Check
```
GET /health
```
Returns server status and available endpoints.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-06T19:30:00.000Z",
  "version": "1.0.0",
  "endpoints": {
    "recipes": "/recipes",
    "recipe_by_id": "/recipes/:id"
  }
}
```

### Get All Recipes
```
GET /recipes
```
Returns array of all recipe objects.

**Query Parameters:**
- `_limit`: Limit number of results (e.g., `?_limit=10`)
- `_page`: Page number for pagination (e.g., `?_page=2`)
- `category`: Filter by category (e.g., `?category=Italian`)
- `difficulty`: Filter by difficulty (e.g., `?difficulty=Easy`)

**Response:** Array of recipe objects (see Data Schema below)

### Get Recipe by ID
```
GET /recipes/:id
```
Returns single recipe object by ID.

**Parameters:**
- `id`: Recipe ID (integer)

**Response:** Single recipe object or 404 if not found

## Data Schema

### Recipe Object Structure
```json
{
  "id": 1,
  "schema_version": 1,
  "title": "Classic Margherita Pizza",
  "description": "Traditional Italian pizza with tomato sauce, mozzarella, and fresh basil",
  "cookTime": 25,
  "prepTime": 15,
  "servings": 4,
  "difficulty": "Easy|Medium|Hard",
  "category": "Italian",
  "ingredients": ["Pizza dough", "Tomato sauce", "Mozzarella cheese"],
  "imageUrl": "https://example.com/images/margherita-pizza.jpg",
  "rating": 4.7,
  "reviewCount": 1245,
  "createdAt": "2024-01-15T10:30:00Z"
}
```

### Schema Version
- **Current Version**: `1`
- **Purpose**: Track data compatibility across PoC iterations
- **Location**: `schema_version` field in each recipe object

### Data Set Details
- **Total Recipes**: 50
- **Categories**: Italian, Asian, Mexican, American, Desserts, Salads, Seafood, etc.
- **Difficulty Levels**: Easy, Medium, Hard
- **Rating Range**: 4.1 - 4.9 stars
- **Review Counts**: 345 - 2456 reviews

## CORS Configuration

CORS is enabled for the following origins:
- `http://localhost:3000` (server itself)
- `http://localhost:19006` (Expo web)
- `http://localhost:19000` (Expo dev server)
- `exp://localhost:19000` (Expo app protocol)
- `http://10.0.2.2:3000` (Android emulator)
- `http://127.0.0.1:3000` (iOS simulator)

## Mobile App Integration

### Flutter Integration
```dart
// Example HTTP request
final response = await http.get(
  Uri.parse('http://localhost:3000/recipes'),
);
```

### React Native Integration
```javascript
// Example axios request
const response = await axios.get('http://localhost:3000/recipes');
```

### Network Configuration Notes
- **Android Emulator**: Use `10.0.2.2:3000` instead of `localhost:3000`
- **iOS Simulator**: Can use `localhost:3000` or `127.0.0.1:3000`
- **Physical Devices**: Use your machine's IP address instead of localhost

## Development Features

### Request Logging
All requests are logged with timestamp and method:
```
2024-01-06T19:30:15.123Z - GET /recipes
2024-01-06T19:30:16.456Z - GET /recipes/1
```

### Error Handling
- **404**: Recipe not found
- **500**: Server errors
- **CORS**: Cross-origin request handling

## Performance Testing

### Response Time Simulation
- **Range**: 80-150 milliseconds
- **Distribution**: Random uniform distribution
- **Purpose**: Simulate realistic API response times

### Monitoring
Monitor response times using:
```bash
curl -w "@curl-format.txt" -o /dev/null -s "http://localhost:3000/recipes"
```

## Troubleshooting

### Common Issues

**Port Already in Use**
```bash
# Find process using port 3000
lsof -ti:3000

# Kill process (macOS/Linux)
kill -9 $(lsof -ti:3000)
```

**CORS Issues**
- Verify your app's origin is in the CORS configuration
- Check browser developer tools for CORS errors
- For new origins, add them to `corsOptions.origin` array

**Connection Refused**
- Ensure server is running: `npm start`
- Check firewall settings
- Verify correct IP address for physical devices

**Empty Response**
- Check if recipes.json file exists and has valid JSON
- Verify file path in server.js

## Version History

### v1.0.0 (Stage 1 Setup)
- Initial server setup with 50 recipes
- CORS configuration for mobile apps
- Response time middleware
- Health check endpoint
- Schema versioning implementation

## Support

For issues related to the mock server:
1. Check server logs for error messages
2. Verify network connectivity and CORS configuration
3. Test endpoints using curl or Postman
4. Review mobile app network configuration

---

*Last Updated: Stage 1 Setup Phase*  
*Server Version: 1.0.0*  
*Maintained by: PoC Team* 