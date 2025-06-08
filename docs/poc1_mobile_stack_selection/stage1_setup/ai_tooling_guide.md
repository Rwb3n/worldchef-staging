/* ANNOTATION_BLOCK_START
{
  "artifact_id": "worldchef_poc_ai_tooling_guide",
  "version_tag": "1.0.0-setup",
  "g_created": 8,
  "g_last_modified": 8,
  "description": "Comprehensive guide for AI tooling setup, secure API key management, and prompting strategies for consistent code generation across both Flutter and React Native PoCs.",
  "artifact_type": "DOCUMENTATION",
  "status_in_lifecycle": "PRODUCTION",
  "purpose_statement": "Ensures consistent AI code generation approach with secure credential handling and optimized prompting strategies for both PoC implementations.",
  "key_logic_points": [
    "Secure OpenAI API key storage and management procedures",
    "Standardized prompting strategies for code generation consistency",
    "Platform-specific AI assistance configurations for Flutter and React Native",
    "Quality metrics and evaluation criteria for AI-generated code",
    "Integration with development workflows and CI/CD pipelines",
    "Cost optimization and usage monitoring guidelines"
  ],
  "interfaces_provided": [
    {
      "name": "AI Setup Procedures",
      "interface_type": "DOCUMENTATION",
      "details": "Step-by-step instructions for configuring AI tooling and secure credential management",
      "notes": "Includes verification steps and best practices for consistent results"
    }
  ],
  "requisites": [
    { "description": "OpenAI API account with GPT-4 access", "type": "SERVICE_ACCOUNT" },
    { "description": "GitHub account for secrets management", "type": "SERVICE_ACCOUNT" },
    { "description": "Development environment with secure credential storage", "type": "DEVELOPMENT_ENVIRONMENT" }
  ],
  "external_dependencies": [
    { "name": "OpenAI API", "version": "latest", "reason": "Primary AI code generation service" }
  ],
  "internal_dependencies": [],
  "dependents": ["worldchef_poc_flutter", "worldchef_poc_rn"],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "N/A - Documentation",
    "manual_review_comment": "Comprehensive AI tooling guide created with secure credential management, standardized prompting strategies, and quality evaluation procedures."
  }
}
ANNOTATION_BLOCK_END */

# WorldChef PoC - AI Tooling Setup & Configuration Guide

> **📋 Navigation**: This document is part of the WorldChef PoC documentation suite. See [Stage 1 Onboarding Guide](./stage1_onboarding_guide.md) for complete project overview and navigation.

Comprehensive guide for AI tooling setup, secure API key management, and prompting strategies for consistent code generation across both Flutter and React Native PoCs.

## Overview

This guide establishes standardized AI-assisted development practices to ensure fair comparison between Flutter and React Native implementations while maintaining security and consistency.

## Prerequisites

### Required Services
- **OpenAI API Account**: GPT-4 access with sufficient quota
- **GitHub Account**: For secure secrets management
- **Development Environment**: Secure credential storage capability

### Recommended Tools
- **Cursor IDE**: AI-powered code editor
- **GitHub Copilot**: AI pair programming assistant
- **Postman/Insomnia**: API testing for verification

## OpenAI API Configuration

### 1. API Key Acquisition
1. Visit [OpenAI Platform](https://platform.openai.com)
2. Navigate to API Keys section
3. Create new API key with descriptive name: `WorldChef-PoC-Development`
4. Copy key immediately (shown only once)
5. Set usage limits if desired for cost control

### 2. Secure API Key Storage

#### Local Development (.env)
```bash
# Create .env file in project root (ensure gitignored)
OPENAI_API_KEY=sk-your-actual-api-key-here

# Verify .env is in .gitignore
echo ".env" >> .gitignore
```

#### GitHub Actions Secrets
```bash
# Repository Settings > Secrets and variables > Actions
# Add new repository secret:
# Name: OPENAI_API_KEY
# Value: sk-your-actual-api-key-here
```

#### Environment Variable Verification
```bash
# Test local environment loading
# Flutter
flutter test --dart-define=OPENAI_API_KEY=$OPENAI_API_KEY

# React Native (Expo)
npx expo start --dev-client
```

### 3. Usage Monitoring Setup
- **OpenAI Dashboard**: Monitor token usage and costs
- **Rate Limits**: Configure appropriate limits for development
- **Budget Alerts**: Set up spending notifications
- **Usage Tracking**: Log API calls in development logs

## Prompting Strategy Framework

### Core Prompting Principles

#### 1. Role-Based Prompting
```
You are an expert [Flutter/React Native] developer building a mobile recipe app. 
Focus on performance, maintainability, and platform best practices.
```

#### 2. Context-Rich Instructions
```
Context: WorldChef PoC comparing Flutter vs React Native
Goal: Implement [specific component] with [specific requirements]
Constraints: [list any limitations or preferences]
Expected Output: [detailed description of desired result]
```

#### 3. Consistent Output Format
```
Provide:
1. Complete, runnable code
2. Imports and dependencies
3. Error handling
4. Performance considerations
5. Brief explanation of approach
```

### Platform-Specific Prompting

#### Flutter Prompting Template
```markdown
Create a Flutter [component type] that:
- Uses Material Design 3 principles
- Implements proper state management with [chosen solution]
- Includes error handling and loading states
- Follows Flutter performance best practices
- Uses cached_network_image for image loading
- Implements proper accessibility features

Requirements:
[Specific requirements here]

Provide complete code with imports, error handling, and comments.
```

#### React Native Prompting Template
```markdown
Create a React Native [component type] that:
- Uses React Native best practices and hooks
- Implements state management with Zustand
- Includes error handling and loading states
- Uses @shopify/flash-list for performant lists
- Follows React Navigation patterns
- Implements proper accessibility features

Requirements:
[Specific requirements here]

Provide complete code with imports, TypeScript types, and comments.
```

### Quality Evaluation Criteria

#### Code Quality Metrics
1. **Completeness**: All imports, exports, and dependencies included
2. **Functionality**: Code runs without errors
3. **Best Practices**: Follows platform conventions
4. **Performance**: Optimized rendering and memory usage
5. **Maintainability**: Clear structure and documentation
6. **Accessibility**: WCAG compliance where applicable

#### Platform-Specific Criteria

##### Flutter Quality Checklist
- [ ] Uses proper Widget lifecycle methods
- [ ] Implements efficient build methods
- [ ] Uses const constructors where possible
- [ ] Follows Flutter naming conventions
- [ ] Includes proper error boundaries
- [ ] Uses appropriate Flutter packages

##### React Native Quality Checklist
- [ ] Uses functional components with hooks
- [ ] Implements proper useEffect cleanup
- [ ] Uses TypeScript types correctly
- [ ] Follows React Native performance patterns
- [ ] Includes proper error boundaries
- [ ] Uses platform-specific code where needed

## AI Development Workflow

### 1. Pre-Development Phase
```bash
# Define component requirements
# Review existing codebase for patterns
# Prepare comprehensive prompt
# Set quality expectations
```

### 2. Code Generation Phase
```bash
# Initial AI prompt with full context
# Review generated code for completeness
# Test code in development environment
# Iterate prompt if needed (max 3 iterations)
```

### 3. Post-Generation Phase
```bash
# Code review for quality and best practices
# Integration testing with existing codebase
# Performance validation
# Documentation updates
```

### 4. Quality Assurance
```bash
# Automated testing (unit/integration)
# Manual testing on target devices
# Performance profiling
# Accessibility testing
```

## AI Integration with Development Tools

### Cursor IDE Configuration
```json
{
  "ai.model": "gpt-4",
  "ai.temperature": 0.1,
  "ai.maxTokens": 2000,
  "ai.contextWindow": 8000,
  "ai.systemPrompt": "You are an expert mobile developer. Provide complete, production-ready code with proper error handling and documentation."
}
```

### GitHub Copilot Settings
```json
{
  "github.copilot.enable": {
    "*": true,
    "dart": true,
    "javascript": true,
    "typescript": true
  },
  "github.copilot.advanced": {
    "length": 500,
    "temperature": 0.1
  }
}
```

### VS Code AI Extensions
- **GitHub Copilot**: Code completion and suggestions
- **Tabnine**: AI code completion
- **CodeT5**: Code understanding and generation
- **AI Commit**: Automated commit message generation

## Cost Optimization Strategies

### Token Usage Optimization
1. **Prompt Efficiency**: Clear, concise prompts
2. **Context Management**: Include only relevant context
3. **Response Length**: Request appropriate output length
4. **Batching**: Combine related requests when possible

### Usage Monitoring
```javascript
// Example usage tracking
const trackAIUsage = {
  timestamp: new Date(),
  model: 'gpt-4',
  prompt_tokens: 150,
  completion_tokens: 300,
  total_cost: 0.02,
  task_id: 'task_poc1_s1_component_x'
};
```

### Budget Management
- **Daily Limits**: Set per-day spending limits
- **Project Allocation**: Track costs per PoC implementation
- **Efficiency Metrics**: Monitor cost per feature implemented
- **Regular Review**: Weekly cost and usage analysis

## Testing AI-Generated Code

### Automated Testing Framework
```bash
# Flutter testing
flutter test
flutter test --coverage

# React Native testing
npm test
npm run test:coverage
```

### Manual Testing Procedures
1. **Functionality Testing**: Verify all features work as expected
2. **Performance Testing**: Profile memory and CPU usage
3. **Accessibility Testing**: Verify screen reader compatibility
4. **Platform Testing**: Test on both iOS and Android
5. **Network Testing**: Verify API integration

### Quality Gates
```yaml
# AI-generated code must pass:
- Linting: 100% compliance
- Unit Tests: >80% coverage
- Integration Tests: All pass
- Performance: Meet baseline metrics
- Accessibility: WCAG AA compliance
```

## Documentation Standards

### Code Documentation
```dart
/// AI-Generated Component: RecipeCard
/// Generated: 2024-01-15
/// Model: GPT-4
/// Prompt Hash: abc123
/// 
/// Displays recipe information with image, title, and rating.
/// Implements efficient caching and error handling.
class RecipeCard extends StatelessWidget {
  // Implementation...
}
```

### AI Usage Logging
```markdown
## AI Development Log

### Component: RecipeListScreen
- **Date**: 2024-01-15
- **AI Model**: GPT-4
- **Prompt Iterations**: 2
- **Token Usage**: 450 tokens
- **Cost**: $0.03
- **Quality Score**: 9/10
- **Time Saved**: ~2 hours

### Issues Encountered:
- Initial prompt lacked scroll optimization details
- Required refinement for accessibility features

### Final Result:
- Fully functional component
- Meets all quality criteria
- Integrated successfully
```

## Security Considerations

### API Key Security
- **Never commit keys**: Use .env and .gitignore
- **Rotate regularly**: Change keys monthly
- **Limit scope**: Use least-privilege access
- **Monitor usage**: Watch for unexpected usage patterns

### Code Review Process
1. **AI-generated flag**: Mark all AI-generated code
2. **Security review**: Check for vulnerabilities
3. **Logic validation**: Verify business logic correctness
4. **Performance review**: Ensure optimal implementation

### Sensitive Data Handling
- **No PII in prompts**: Avoid personal information
- **Sanitize examples**: Use generic sample data
- **Secure transmission**: Use HTTPS for all API calls
- **Audit trails**: Log all AI interactions

## Troubleshooting

### Common Issues

#### API Key Authentication Errors
```bash
# Verify key format
echo $OPENAI_API_KEY | grep "sk-"

# Test API connection
curl -H "Authorization: Bearer $OPENAI_API_KEY" \
     https://api.openai.com/v1/models
```

#### Rate Limiting
```bash
# Monitor rate limits
# Implement exponential backoff
# Use request queuing
# Consider API key rotation
```

#### Quality Issues
```bash
# Refine prompts for better results
# Add more specific context
# Include examples in prompts
# Iterate with feedback
```

#### Console Encoding Issues (Windows PowerShell)
```bash
# Problem: System.Text.EncoderFallbackException with Unicode characters (\uD83D emoji sequences)
# affecting Flutter build_runner execution observation

# Symptoms:
# - PowerShell PSReadLine fails when handling CLI output with emojis
# - build_runner commands fail to complete observable output
# - Console display issues with Unicode characters

# Workarounds:
# 1. Use output redirection to bypass console display
flutter pub run build_runner build --delete-conflicting-outputs *> build_output.log 2>&1

# 2. Try alternative terminals (Windows Terminal, Git Bash)
# 3. Set console code page (may help)
chcp 65001

# 4. For PoC development: Implement manual JSON serialization as functional equivalent
# 5. Report upstream to PowerShell PSReadLine team

# Note: This is an environment-specific issue that doesn't affect Flutter/Dart functionality
# Manual workarounds enable continued development without blocking PoC progress
```

### Performance Optimization

#### Prompt Optimization
- Keep prompts focused and specific
- Include relevant code examples
- Specify exact requirements
- Use consistent terminology

#### Response Processing
- Parse and validate AI responses
- Implement fallback mechanisms
- Cache common responses
- Monitor response quality

## Best Practices Summary

### Do's
✅ Use specific, detailed prompts  
✅ Include context and requirements  
✅ Test all AI-generated code thoroughly  
✅ Document AI usage and decisions  
✅ Monitor costs and usage patterns  
✅ Implement proper security measures  
✅ Follow platform-specific guidelines  
✅ Maintain consistent code quality standards  

### Don'ts
❌ Share API keys in code or commits  
❌ Accept AI code without testing  
❌ Skip security and performance reviews  
❌ Use AI for sensitive or critical security code  
❌ Ignore platform best practices  
❌ Forget to track usage and costs  
❌ Skip documentation of AI assistance  
❌ Use outdated or deprecated patterns  

## Integration Checklist

### Setup Verification
- [ ] OpenAI API key configured and tested
- [ ] GitHub secrets properly configured
- [ ] Local environment variables working
- [ ] AI development tools installed and configured
- [ ] Usage monitoring dashboard accessible
- [ ] Cost limits and alerts configured

### Process Verification
- [ ] Prompting templates documented and tested
- [ ] Quality evaluation criteria established
- [ ] Testing procedures defined and validated
- [ ] Documentation standards implemented
- [ ] Security measures in place and verified
- [ ] Team training completed

---

## Summary

This AI tooling guide establishes a secure, efficient, and consistent approach to AI-assisted development for the WorldChef PoC. Key components include:

1. **Secure API Management**: Proper credential storage and monitoring
2. **Standardized Prompting**: Consistent, platform-specific prompt templates  
3. **Quality Assurance**: Comprehensive testing and evaluation procedures
4. **Cost Optimization**: Usage monitoring and budget management
5. **Security Practices**: Secure development and code review processes

**Next Steps**: After completing AI tooling setup, proceed with time tracking setup (Task 006), then perform integration smoke testing (Task 008) to validate the complete development environment.

---

*Last Updated: Stage 1 Setup Phase*  
*AI Tooling Guide Version: 1.0.0*  
*Maintained by: PoC Team* 