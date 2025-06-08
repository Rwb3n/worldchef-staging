import React, { createContext, useState, useEffect, useMemo } from 'react';
import { useColorScheme } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

type Theme = 'light' | 'dark' | 'system';

interface ThemeContextType {
  theme: Theme;
  setTheme: (theme: Theme) => void;
  colorScheme: 'light' | 'dark';
}

export const ThemeContext = createContext<ThemeContextType>({
  theme: 'system',
  setTheme: () => {},
  colorScheme: 'light',
});

export const ThemeProvider = ({ children }: { children: React.ReactNode }) => {
  const systemColorScheme = useColorScheme();
  const [theme, setTheme] = useState<Theme>('system');

  useEffect(() => {
    const loadTheme = async () => {
      const savedTheme = (await AsyncStorage.getItem('theme')) as Theme;
      if (savedTheme) {
        setTheme(savedTheme);
      }
    };
    loadTheme();
  }, []);

  const colorScheme = useMemo(() => {
    if (theme === 'system') {
      return systemColorScheme;
    }
    return theme;
  }, [theme, systemColorScheme]);

  const handleSetTheme = (newTheme: Theme) => {
    setTheme(newTheme);
    AsyncStorage.setItem('theme', newTheme);
  };

  return (
    <ThemeContext.Provider value={{ theme, setTheme: handleSetTheme, colorScheme }}>
      {children}
    </ThemeContext.Provider>
  );
}; 