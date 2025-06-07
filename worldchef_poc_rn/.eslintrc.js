module.exports = {
  extends: [
    'expo',
    '@react-native-community',
  ],
  rules: {
    // Customize rules for PoC consistency
    'no-console': 'warn',
    'react-native/no-unused-styles': 'error',
    'react-native/split-platform-components': 'error',
    'react-native/no-inline-styles': 'warn',
    'react-native/no-color-literals': 'warn',
    'react-hooks/exhaustive-deps': 'warn',
  },
  env: {
    'react-native/react-native': true,
  },
}; 