/* ANNOTATION_BLOCK_START
{
  "artifact_id": "rn_jest_config_custom_v1",
  "version_tag": "1.0.0-custom",
  "g_created": 30,
  "g_last_modified": 30,
  "description": "Custom Jest configuration for React Native PoC that bypasses jest-expo preset issues by using a minimal setup focused on API service testing.",
  "artifact_type": "CONFIGURATION",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides working Jest test infrastructure for React Native PoC using custom configuration to avoid jest-expo Object.defineProperty errors while maintaining comprehensive API service test coverage.",
  "key_logic_points": [
    "Bypasses jest-expo preset to avoid Object.defineProperty runtime errors",
    "Uses custom transform patterns for TypeScript and JavaScript",
    "Includes minimal React Native mocking for API service tests",
    "Configured specifically for API service and utility function testing",
    "Avoids complex React Native component testing that requires expo preset"
  ],
  "dependencies": [
    "jest for test runner",
    "@testing-library/jest-native for test utilities",
    "babel-jest for TypeScript transformation"
  ]
}
ANNOTATION_BLOCK_END */

module.exports = {
  // Use default jest preset instead of jest-expo to avoid Object.defineProperty issues
  preset: undefined,
  
  // Test environment
  testEnvironment: 'node',
  
  // Module file extensions
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json'],
  
  // Transform files
  transform: {
    '^.+\\.(ts|tsx)$': 'babel-jest',
    '^.+\\.(js|jsx)$': 'babel-jest',
  },
  
  // Test match patterns
  testMatch: [
    '**/__tests__/**/*.(ts|tsx|js)',
    '**/*.(test|spec).(ts|tsx|js)'
  ],
  
  // Setup files
  setupFilesAfterEnv: ['<rootDir>/jest-setup.js'],
  
  // Module name mapping for React Native modules
  moduleNameMapper: {
    '^react-native$': 'react-native',
    '^@react-native/(.*)$': '@react-native/$1',
  },
  
  // Transform ignore patterns - allow transformation of node_modules we need
  transformIgnorePatterns: [
    'node_modules/(?!(react-native|@react-native|expo|axios)/)'
  ],
  
  // Coverage settings
  collectCoverageFrom: [
    'src/**/*.{ts,tsx,js,jsx}',
    '!src/**/*.d.ts',
    '!src/**/*.stories.{ts,tsx,js,jsx}',
  ],
  
  // Verbose output for debugging
  verbose: true,
  
  // Clear mocks between tests
  clearMocks: true,
}; 