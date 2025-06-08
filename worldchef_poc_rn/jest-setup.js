/* ANNOTATION_BLOCK_START
{
  "artifact_id": "rn_jest_setup_custom",
  "version_tag": "1.0.0",
  "g_created": 30,
  "g_last_modified": 30,
  "description": "Custom Jest setup file for React Native PoC that provides minimal mocking and setup for API service testing without expo dependencies.",
  "artifact_type": "CONFIGURATION",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides essential Jest setup and mocking for React Native API service tests while avoiding expo-specific dependencies that cause runtime errors.",
  "key_logic_points": [
    "Minimal React Native module mocking for API service tests",
    "Sets up testing library jest-native matchers",
    "Provides basic console and timer mocking",
    "Avoids expo-specific setup that causes Object.defineProperty errors"
  ]
}
ANNOTATION_BLOCK_END */

// Import jest-native matchers
import '@testing-library/jest-native/extend-expect';

// Mock React Native modules that might be imported
jest.mock('react-native', () => ({
  Platform: {
    OS: 'ios',
    select: jest.fn((obj) => obj.ios),
  },
  Dimensions: {
    get: jest.fn(() => ({ width: 375, height: 667 })),
  },
  Alert: {
    alert: jest.fn(),
  },
}));

// Mock AsyncStorage if used
jest.mock('@react-native-async-storage/async-storage', () => ({
  getItem: jest.fn(),
  setItem: jest.fn(),
  removeItem: jest.fn(),
  clear: jest.fn(),
}));

// Mock console methods for cleaner test output
global.console = {
  ...console,
  log: jest.fn(),
  debug: jest.fn(),
  info: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
};

// Use real timers for API tests to avoid timeout issues
jest.useRealTimers();

// Mock global fetch for API tests
global.fetch = jest.fn();

// Global test timeout
jest.setTimeout(10000); 