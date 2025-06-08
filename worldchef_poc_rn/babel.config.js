/* ANNOTATION_BLOCK_START
{
  "artifact_id": "rn_babel_config_flow_support_v2",
  "version_tag": "1.0.0-testing",
  "g_created": 23,
  "g_last_modified": 23,
  "description": "Babel configuration for React Native project with Flow syntax support to resolve Jest testing issues with React Native polyfills.",
  "artifact_type": "CONFIGURATION",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Enables Babel to properly parse Flow syntax in React Native dependencies during Jest test runs, resolving transformation errors.",
  "key_logic_points": [
    "Uses metro-react-native-babel-preset for React Native compatibility",
    "Includes @babel/preset-flow for Flow syntax parsing",
    "Configured specifically for Jest test environment",
    "Handles both JavaScript and TypeScript files"
  ],
  "dependencies": [
    "metro-react-native-babel-preset for React Native Babel configuration",
    "@babel/preset-flow for Flow syntax support in dependencies"
  ]
}
ANNOTATION_BLOCK_END */

module.exports = function(api) {
  api.cache(true);
  return {
    presets: [
      'babel-preset-expo',
      '@babel/preset-flow'  // Add Flow support for React Native polyfills
    ],
    plugins: []
  };
}; 