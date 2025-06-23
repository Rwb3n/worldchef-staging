// backend/__tests__/integration/auth.test.ts

import { FastifyInstance } from 'fastify';
import { jest } from '@jest/globals';
import { build } from '../../src/server';

// Mock the entire module
jest.mock('@supabase/supabase-js', () => {
  const mockAuth = {
    signUp: jest.fn(),
    signInWithPassword: jest.fn(),
  };
  return {
    createClient: jest.fn(() => ({
      auth: mockAuth,
    })),
    AuthError: class MockAuthError extends Error {
      status: number;
      constructor(message: string) {
        super(message);
        this.name = 'AuthError';
        this.status = 400;
      }
    },
  };
});

// We need a reference to the mocked functions
const { createClient, AuthError } = require('@supabase/supabase-js');
const supabase = createClient('mock', 'mock');
const mockSignUp = supabase.auth.signUp;
const mockSignIn = supabase.auth.signInWithPassword;


describe('Auth Routes', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = await build({ logger: false });
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  beforeEach(() => {
    // Reset mocks before each test
    mockSignUp.mockClear();
    mockSignIn.mockClear();
  });

  describe('POST /v1/auth/signup', () => {
    it('should sign up a user successfully', async () => {
      const mockUserData = { 
        user: { id: '123', aud: 'authenticated' }, 
        session: {} 
      };
      mockSignUp.mockResolvedValue({ data: mockUserData, error: null });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/auth/signup',
        payload: { email: 'test@example.com', password: 'password123' },
      });

      expect(response.statusCode).toBe(201);
      expect(JSON.parse(response.payload)).toEqual(mockUserData);
      expect(mockSignUp).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
      });
    });

    it('should return an error if signup fails', async () => {
      const mockError = new AuthError('User already registered');
      mockError.status = 400;
      mockSignUp.mockResolvedValue({ data: { user: null, session: null }, error: mockError });
        
      const response = await app.inject({
        method: 'POST',
        url: '/v1/auth/signup',
        payload: { email: 'test@example.com', password: 'password123' },
      });

      expect(response.statusCode).toBe(400);
      expect(JSON.parse(response.payload)).toEqual({ error: 'User already registered' });
    });
  });

  describe('POST /v1/auth/login', () => {
    it('should log in a user successfully', async () => {
      const mockLoginData = { 
        user: { id: '123', aud: 'authenticated' }, 
        session: { access_token: 'fake-jwt' } 
      };
      mockSignIn.mockResolvedValue({ data: mockLoginData, error: null });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/auth/login',
        payload: { email: 'test@example.com', password: 'password123' },
      });

      expect(response.statusCode).toBe(200);
      expect(JSON.parse(response.payload)).toEqual(mockLoginData);
    });

    it('should return an error for invalid credentials', async () => {
      const mockError = new AuthError('Invalid login credentials');
      mockError.status = 401;
      mockSignIn.mockResolvedValue({ data: { user: null, session: null }, error: mockError });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/auth/login',
        payload: { email: 'test@example.com', password: 'wrong-password' },
      });

      expect(response.statusCode).toBe(401);
      expect(JSON.parse(response.payload)).toEqual({ error: 'Invalid login credentials' });
    });
  });
  
  // Note: Testing the protected '/me' route would require a more complex mock
  // of the jwks-rsa and jsonwebtoken libraries, which is beyond the scope
  // of this initial scaffolding but would be a next step for full coverage.
}); 