/**
 * Error Display Components for WorldChef React Native PoC
 * 
 * AI_ENHANCEMENT_NOTE: Created as part of Task RN-ENH-001 to replace console.error
 * with user-visible error feedback. Provides contextual error messages based on
 * error type and retry capabilities.
 * 
 * Target: Move from developer-focused console logging to user-friendly error UI
 * that provides actionable feedback and retry options where appropriate.
 */

import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { ApiErrorType, NetworkError, ApiError, NotFoundError } from '../types/errors';

// Props for the main error display component
export interface ErrorDisplayProps {
  error: ApiErrorType;
  onRetry?: () => void;
  onDismiss?: () => void;
  style?: any;
  showDetails?: boolean;
}

// Main error display component - can be used as banner or card
export const ErrorDisplay: React.FC<ErrorDisplayProps> = ({
  error,
  onRetry,
  onDismiss,
  style,
  showDetails = false
}) => {
  const getErrorIcon = () => {
    if (error instanceof NetworkError) return '📡';
    if (error instanceof NotFoundError) return '🔍';
    return '⚠️';
  };

  const getErrorColor = () => {
    if (error instanceof NetworkError) return '#FF6B35'; // Orange for network issues
    if (error instanceof NotFoundError) return '#4A90E2'; // Blue for not found
    return '#E53E3E'; // Red for other API errors
  };

  const showErrorDetails = () => {
    Alert.alert(
      'Error Details',
      `Type: ${error.constructor.name}\nMessage: ${error.message}\nCode: ${error.code}\nTime: ${error.timestamp.toLocaleTimeString()}`,
      [{ text: 'OK' }]
    );
  };

  return (
    <View style={[styles.container, { borderLeftColor: getErrorColor() }, style]}>
      <View style={styles.header}>
        <Text style={styles.icon}>{getErrorIcon()}</Text>
        <View style={styles.messageContainer}>
          <Text style={styles.userMessage}>{error.getUserMessage()}</Text>
          {showDetails && (
            <Text style={styles.technicalMessage}>{error.message}</Text>
          )}
        </View>
      </View>
      
      <View style={styles.actions}>
        {error.isRetryable && onRetry && (
          <TouchableOpacity style={styles.retryButton} onPress={onRetry}>
            <Text style={styles.retryButtonText}>Try Again</Text>
          </TouchableOpacity>
        )}
        
        {showDetails && (
          <TouchableOpacity style={styles.detailsButton} onPress={showErrorDetails}>
            <Text style={styles.detailsButtonText}>Details</Text>
          </TouchableOpacity>
        )}
        
        {onDismiss && (
          <TouchableOpacity style={styles.dismissButton} onPress={onDismiss}>
            <Text style={styles.dismissButtonText}>×</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
};

// Banner-style error display for top of screen
export interface ErrorBannerProps {
  error: ApiErrorType;
  onRetry?: () => void;
  onDismiss?: () => void;
}

export const ErrorBanner: React.FC<ErrorBannerProps> = ({ error, onRetry, onDismiss }) => {
  return (
    <ErrorDisplay
      error={error}
      onRetry={onRetry}
      onDismiss={onDismiss}
      style={styles.banner}
    />
  );
};

// Card-style error display for inline use
export interface ErrorCardProps {
  error: ApiErrorType;
  onRetry?: () => void;
  title?: string;
  showDetails?: boolean;
}

export const ErrorCard: React.FC<ErrorCardProps> = ({ 
  error, 
  onRetry, 
  title = 'Something went wrong',
  showDetails = true 
}) => {
  return (
    <View style={styles.card}>
      <Text style={styles.cardTitle}>{title}</Text>
      <ErrorDisplay
        error={error}
        onRetry={onRetry}
        style={styles.cardError}
        showDetails={showDetails}
      />
    </View>
  );
};

// Hook for managing error state in components
export interface UseErrorStateResult {
  error: ApiErrorType | null;
  setError: (error: ApiErrorType | null) => void;
  clearError: () => void;
  showError: (error: ApiErrorType) => void;
}

export const useErrorState = (): UseErrorStateResult => {
  const [error, setError] = React.useState<ApiErrorType | null>(null);

  const clearError = React.useCallback(() => {
    setError(null);
  }, []);

  const showError = React.useCallback((newError: ApiErrorType) => {
    setError(newError);
  }, []);

  return {
    error,
    setError,
    clearError,
    showError
  };
};

// Styles
const styles = StyleSheet.create({
  container: {
    backgroundColor: '#FFF5F5',
    borderLeftWidth: 4,
    borderRadius: 8,
    padding: 16,
    marginVertical: 8,
    flexDirection: 'column',
  },
  banner: {
    marginVertical: 0,
    borderRadius: 0,
    borderLeftWidth: 0,
    borderBottomWidth: 2,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 8,
  },
  icon: {
    fontSize: 24,
    marginRight: 12,
  },
  messageContainer: {
    flex: 1,
  },
  userMessage: {
    fontSize: 16,
    fontWeight: '500',
    color: '#2D3748',
    marginBottom: 4,
  },
  technicalMessage: {
    fontSize: 14,
    color: '#718096',
    fontStyle: 'italic',
  },
  actions: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
    gap: 12,
  },
  retryButton: {
    backgroundColor: '#4299E1',
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 6,
  },
  retryButtonText: {
    color: 'white',
    fontWeight: '600',
    fontSize: 14,
  },
  detailsButton: {
    backgroundColor: 'transparent',
    paddingHorizontal: 8,
    paddingVertical: 8,
  },
  detailsButtonText: {
    color: '#4299E1',
    fontSize: 14,
    textDecorationLine: 'underline',
  },
  dismissButton: {
    backgroundColor: 'transparent',
    paddingHorizontal: 8,
    paddingVertical: 4,
  },
  dismissButtonText: {
    color: '#A0AEC0',
    fontSize: 20,
    fontWeight: 'bold',
  },
  card: {
    backgroundColor: 'white',
    borderRadius: 8,
    padding: 16,
    margin: 16,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#2D3748',
    marginBottom: 12,
  },
  cardError: {
    marginVertical: 0,
    backgroundColor: 'transparent',
    padding: 0,
  },
}); 