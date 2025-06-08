import React, { useEffect, useState, useMemo } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, TextInput } from 'react-native';
import { FlashList } from '@shopify/flash-list';
import { getRecipes } from '../services/api';
import { Recipe } from '../types';
import RecipeCard from '../components/RecipeCard';
import { useNavigation } from '@react-navigation/native';
import { StackNavigationProp } from '@react-navigation/stack';
import { ErrorBanner, useErrorState } from '../components/ErrorDisplay';
import { ApiErrorType, ApiError } from '../types/errors';
import { useTTITracker, useMemoryTracker } from '../utils/TTITracker';

// Navigation types - defined locally since navigation folder is empty
type RootStackParamList = {
  RecipeList: undefined;
  RecipeDetail: { recipeId: number };
};

type RecipeListScreenNavigationProp = StackNavigationProp<
  RootStackParamList,
  'RecipeList'
>;

const RecipeListScreen = () => {
  const navigation = useNavigation<RecipeListScreenNavigationProp>();
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  
  // Enhanced error state management
  const { error, showError, clearError } = useErrorState();
  
  // Performance monitoring
  useTTITracker('RecipeList');
  useMemoryTracker('RecipeListScreen');

  const fetchRecipes = async () => {
    try {
      setLoading(true);
      clearError(); // Clear any previous errors
      const data = await getRecipes();
      setRecipes(data);
    } catch (e) {
      // Handle the enhanced error types from our API service
      if (e && typeof e === 'object' && 'getUserMessage' in e) {
        showError(e as ApiErrorType);
             } else {
         // Fallback for unexpected error types (should not happen with enhanced API)
         console.warn('Unexpected error type in RecipeListScreen:', e);
         showError(new ApiError('An unexpected error occurred', 500));
       }
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchRecipes();
  }, []);

  const handleRetry = () => {
    fetchRecipes();
  };

  const filteredRecipes = useMemo(() => {
    return recipes.filter((recipe) =>
      recipe.title.toLowerCase().includes(searchQuery.toLowerCase())
    );
  }, [recipes, searchQuery]);

  if (loading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" />
        <Text style={styles.loadingText}>Loading recipes...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {/* Enhanced error display */}
      {error && (
        <ErrorBanner
          error={error}
          onRetry={error.isRetryable ? handleRetry : undefined}
          onDismiss={clearError}
        />
      )}
      
      <TextInput
        style={styles.searchInput}
        placeholder="Search for a recipe..."
        value={searchQuery}
        onChangeText={setSearchQuery}
      />
      
      {/* Show content only if we have recipes or no error */}
      {!error && (
        <FlashList
          data={filteredRecipes}
          renderItem={({ item }) => (
            <RecipeCard
              item={item}
              onPress={() => navigation.navigate('RecipeDetail', { recipeId: item.id })}
            />
          )}
          estimatedItemSize={280}
          keyExtractor={(item) => item.id.toString()}
          ListEmptyComponent={
            <View style={styles.center}>
              <Text style={styles.emptyText}>No recipes found.</Text>
              {searchQuery.length > 0 && (
                <Text style={styles.emptySubtext}>
                  Try adjusting your search terms
                </Text>
              )}
            </View>
          }
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f2f2f2',
  },
  center: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  searchInput: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 10,
    margin: 10,
    backgroundColor: '#fff',
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#666',
  },
  emptyText: {
    fontSize: 18,
    color: '#666',
    textAlign: 'center',
  },
  emptySubtext: {
    fontSize: 14,
    color: '#999',
    textAlign: 'center',
    marginTop: 8,
  },
});

export default RecipeListScreen; 