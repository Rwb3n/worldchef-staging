// backend/src/schemas/auth_schemas.ts
// Pattern: JSON Schema validation | Source: ADR-WCF-015 §XIV | ADR-WCF-015 compliance

export const signupSchema = {
  body: {
    type: 'object',
    required: ['email', 'password'],
    properties: {
      email: {
        type: 'string',
        format: 'email',
        description: 'User email address'
      },
      password: {
        type: 'string',
        minLength: 8,
        description: 'User password (minimum 8 characters)'
      },
      firstName: {
        type: 'string',
        maxLength: 50,
        description: 'User first name (optional)'
      },
      lastName: {
        type: 'string',
        maxLength: 50,
        description: 'User last name (optional)'
      }
    },
    additionalProperties: false
  },
  response: {
    200: {
      type: 'object',
      properties: {
        user: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            email: { type: 'string', format: 'email' },
            created_at: { type: 'string', format: 'date-time' }
          }
        },
        access_token: { type: 'string' },
        refresh_token: { type: 'string' }
      }
    },
    400: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    },
    422: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    }
  },
  tags: ['auth'],
  summary: 'Create new user account',
  description: 'Register a new user with email and password'
};

export const loginSchema = {
  body: {
    type: 'object',
    required: ['email', 'password'],
    properties: {
      email: {
        type: 'string',
        format: 'email',
        description: 'User email address'
      },
      password: {
        type: 'string',
        description: 'User password'
      }
    },
    additionalProperties: false
  },
  response: {
    200: {
      type: 'object',
      properties: {
        user: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            email: { type: 'string', format: 'email' },
            last_sign_in_at: { type: 'string', format: 'date-time' }
          }
        },
        access_token: { type: 'string' },
        refresh_token: { type: 'string' }
      }
    },
    400: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    },
    401: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    }
  },
  tags: ['auth'],
  summary: 'Authenticate user',
  description: 'Login with email and password to receive access tokens'
}; 