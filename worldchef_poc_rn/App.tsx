import 'react-native-gesture-handler';
import React, { useContext } from 'react';
import { View, Button } from 'react-native';
import AppNavigator from './src/navigation';
import { ThemeProvider, ThemeContext } from './src/contexts/ThemeContext';
import { PerformanceMonitor } from './src/utils/PerformanceMonitor';

const AppContent = () => {
  const { theme, setTheme } = useContext(ThemeContext);

  const toggleTheme = () => {
    const newTheme = theme === 'light' ? 'dark' : 'light';
    setTheme(newTheme);
  };

  return (
    <View style={{ flex: 1 }}>
      <AppNavigator />
      <Button title={`Switch to ${theme === 'light' ? 'Dark' : 'Light'} Mode`} onPress={toggleTheme} />
    </View>
  );
};

export default function App() {
  return (
    <PerformanceMonitor>
      <ThemeProvider>
        <AppContent />
      </ThemeProvider>
    </PerformanceMonitor>
  );
} 