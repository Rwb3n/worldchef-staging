import React, { useEffect, useRef } from 'react';
import { View } from 'react-native';

interface PerformanceMetrics {
  fps: number;
  timestamp: number;
}

export const PerformanceMonitor: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const frameCount = useRef(0);
  const startTime = useRef(Date.now());
  const metrics = useRef<PerformanceMetrics[]>([]);

  useEffect(() => {
    const timer = setInterval(() => {
      frameCount.current++;
      const currentTime = Date.now();
      const elapsed = currentTime - startTime.current;
      
      if (elapsed >= 1000) { // Every second
        const fps = frameCount.current / (elapsed / 1000);
        const metric: PerformanceMetrics = {
          fps: fps,
          timestamp: currentTime
        };
        
        metrics.current.push(metric);
        console.log(`🎯 FPS: ${fps.toFixed(2)} | Avg: ${getAverageFPS().toFixed(2)}`);
        
        frameCount.current = 0;
        startTime.current = currentTime;
      }
    }, 16); // 60fps = ~16.67ms per frame

    return () => {
      clearInterval(timer);
      logPerformanceSummary();
    };
  }, []);

  const getAverageFPS = () => {
    if (metrics.current.length === 0) return 0;
    const sum = metrics.current.reduce((acc, metric) => acc + metric.fps, 0);
    return sum / metrics.current.length;
  };

  const logPerformanceSummary = () => {
    if (metrics.current.length > 0) {
      const avgFPS = getAverageFPS();
      const minFPS = Math.min(...metrics.current.map(m => m.fps));
      const maxFPS = Math.max(...metrics.current.map(m => m.fps));
      
      console.log('📊 Performance Summary:');
      console.log(`   Average FPS: ${avgFPS.toFixed(2)}`);
      console.log(`   Min FPS: ${minFPS.toFixed(2)}`);
      console.log(`   Max FPS: ${maxFPS.toFixed(2)}`);
      console.log(`   Total samples: ${metrics.current.length}`);
    }
  };

  return <View style={{ flex: 1 }}>{children}</View>;
}; 