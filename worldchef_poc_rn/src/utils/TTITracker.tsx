import { useEffect } from 'react';

export const useTTITracker = (screenName: string) => {
  useEffect(() => {
    const startTime = Date.now();
    
    // Mark when screen is interactive (after React render cycle)
    const timer = setTimeout(() => {
      const ttiTime = Date.now() - startTime;
      console.log(`⚡ TTI for ${screenName}: ${ttiTime.toFixed(2)}ms`);
      
      // Store metric for analysis
      if (global.performanceMetrics) {
        global.performanceMetrics.tti = global.performanceMetrics.tti || {};
        global.performanceMetrics.tti[screenName] = ttiTime;
      }
    }, 100); // Allow for React render cycle and initial layout

    return () => clearTimeout(timer);
  }, [screenName]);
};

export const useMemoryTracker = (componentName: string) => {
  useEffect(() => {
    // Note: Memory tracking limited in React Native environment
    const startTime = Date.now();
    
    return () => {
      const endTime = Date.now();
      const duration = endTime - startTime;
      
      console.log(`🧠 Component ${componentName} active for: ${duration}ms`);
      
      if (global.performanceMetrics) {
        global.performanceMetrics.memory = global.performanceMetrics.memory || {};
        global.performanceMetrics.memory[componentName] = duration;
      }
    };
  }, [componentName]);
};

// Initialize global performance metrics storage
if (!global.performanceMetrics) {
  global.performanceMetrics = {
    tti: {},
    memory: {},
    navigation: {}
  };
} 