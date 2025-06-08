/**
 * Enhanced Error Handling for WorldChef React Native PoC
 * 
 * AI_ENHANCEMENT_NOTE: Created as part of Task RN-ENH-001 to address sophistication 
 * gap with Flutter implementation. Provides structured error types for better 
 * error classification and user experience.
 * 
 * Target: Move beyond generic Error instances to typed, actionable error objects
 * that can drive meaningful UI feedback and retry logic.
 */

// Base error interface for all custom errors
export interface BaseApiError {
  message: string;
  code: string;
  timestamp: Date;
  originalError?: Error;
  isRetryable?: boolean;
}

// Network-related errors (connection issues, timeouts)
export class NetworkError extends Error implements BaseApiError {
  public readonly code = 'NETWORK_ERROR';
  public readonly timestamp: Date;
  public readonly isRetryable = true;
  public readonly originalError?: Error;

  constructor(message: string, originalError?: Error) {
    super(message);
    this.name = 'NetworkError';
    this.timestamp = new Date();
    this.originalError = originalError;
    
    // Maintain proper stack trace for debugging
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, NetworkError);
    }
  }

  // Helper method for user-friendly error messages
  getUserMessage(): string {
    return 'Unable to connect to the server. Please check your internet connection and try again.';
  }
}

// API response errors (4xx, 5xx status codes)
export class ApiError extends Error implements BaseApiError {
  public readonly code = 'API_ERROR';
  public readonly timestamp: Date;
  public readonly statusCode: number;
  public readonly isRetryable: boolean;
  public readonly originalError?: Error;

  constructor(message: string, statusCode: number, originalError?: Error) {
    super(message);
    this.name = 'ApiError';
    this.timestamp = new Date();
    this.statusCode = statusCode;
    this.originalError = originalError;
    
    // 5xx errors are typically retryable, 4xx are not
    this.isRetryable = statusCode >= 500;
    
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, ApiError);
    }
  }

  getUserMessage(): string {
    if (this.statusCode >= 500) {
      return 'Server is temporarily unavailable. Please try again in a moment.';
    } else if (this.statusCode === 404) {
      return 'The requested content could not be found.';
    } else if (this.statusCode === 401) {
      return 'Authentication required. Please log in and try again.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}

// Resource not found errors (specific case of 404)
export class NotFoundError extends Error implements BaseApiError {
  public readonly code = 'NOT_FOUND_ERROR';
  public readonly timestamp: Date;
  public readonly isRetryable = false;
  public readonly resourceType: string;
  public readonly resourceId: string;
  public readonly originalError?: Error;

  constructor(resourceType: string, resourceId: string, originalError?: Error) {
    const message = `${resourceType} with ID ${resourceId} not found`;
    super(message);
    this.name = 'NotFoundError';
    this.timestamp = new Date();
    this.resourceType = resourceType;
    this.resourceId = resourceId;
    this.originalError = originalError;
    
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, NotFoundError);
    }
  }

  getUserMessage(): string {
    return `The ${this.resourceType.toLowerCase()} you're looking for couldn't be found. It may have been removed or the link may be incorrect.`;
  }
}

// Type union for all possible API errors
export type ApiErrorType = NetworkError | ApiError | NotFoundError;

// Error classification utility
export function classifyError(error: unknown): ApiErrorType {
  // Already classified errors
  if (error instanceof NetworkError || error instanceof ApiError || error instanceof NotFoundError) {
    return error;
  }

  // Standard Error objects
  if (error instanceof Error) {
    // Check if it's a fetch network error
    if (error.message.includes('fetch') || error.message.includes('network') || error.message.includes('Failed to fetch')) {
      return new NetworkError('Network request failed', error);
    }
    
    // Default to generic API error
    return new ApiError(error.message, 500, error);
  }

  // Unknown error types
  const errorMessage = typeof error === 'string' ? error : 'An unknown error occurred';
  return new ApiError(errorMessage, 500);
}

// Retry configuration interface
export interface RetryConfig {
  maxRetries: number;
  baseDelay: number; // milliseconds
  maxDelay: number; // milliseconds
  backoffMultiplier: number;
}

// Default retry configuration
export const DEFAULT_RETRY_CONFIG: RetryConfig = {
  maxRetries: 2,
  baseDelay: 1000, // 1 second
  maxDelay: 5000,  // 5 seconds max
  backoffMultiplier: 2
};

// Utility function to calculate delay for exponential backoff
export function calculateRetryDelay(attempt: number, config: RetryConfig = DEFAULT_RETRY_CONFIG): number {
  const delay = config.baseDelay * Math.pow(config.backoffMultiplier, attempt - 1);
  return Math.min(delay, config.maxDelay);
}

// Utility function to check if error should be retried
export function shouldRetryError(error: ApiErrorType, attempt: number, config: RetryConfig = DEFAULT_RETRY_CONFIG): boolean {
  return error.isRetryable && attempt <= config.maxRetries;
} 