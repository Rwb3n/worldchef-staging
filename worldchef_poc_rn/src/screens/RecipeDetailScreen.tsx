import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ScrollView, ActivityIndicator } from 'react-native';
import { Image } from 'expo-image';
import { getRecipeById } from '../services/api';
import { Recipe } from '../types';
import { ErrorCard, useErrorState } from '../components/ErrorDisplay';
import { ApiErrorType, ApiError } from '../types/errors';
import { useTTITracker, useMemoryTracker } from '../utils/TTITracker';

interface RecipeDetailScreenProps {
  route: {
    params: {
      recipeId: number;
    };
  };
}

const RecipeDetailScreen = ({ route }: RecipeDetailScreenProps) => {
  const { recipeId } = route.params;
  const [recipe, setRecipe] = useState<Recipe | null>(null);
  const [loading, setLoading] = useState(true);
  
  // Enhanced error state management
  const { error, showError, clearError } = useErrorState();
  
  // Performance monitoring
  useTTITracker('RecipeDetail');
  useMemoryTracker('RecipeDetailScreen');

  const fetchRecipe = async () => {
    try {
      setLoading(true);
      clearError(); // Clear any previous errors
      const data = await getRecipeById(recipeId);
      setRecipe(data);
    } catch (e) {
      // Handle the enhanced error types from our API service
      if (e && typeof e === 'object' && 'getUserMessage' in e) {
        showError(e as ApiErrorType);
      } else {
        // Fallback for unexpected error types
        console.warn('Unexpected error type in RecipeDetailScreen:', e);
        showError(new ApiError('Failed to load recipe details', 500));
      }
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchRecipe();
  }, [recipeId]);

  const handleRetry = () => {
    fetchRecipe();
  };

  if (loading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" />
        <Text style={styles.loadingText}>Loading recipe details...</Text>
      </View>
    );
  }

  if (error) {
    return (
      <View style={styles.center}>
        <ErrorCard
          error={error}
          onRetry={error.isRetryable ? handleRetry : undefined}
          title="Unable to Load Recipe"
          showDetails={true}
        />
      </View>
    );
  }

  if (!recipe) {
    return (
      <View style={styles.center}>
        <Text style={styles.notFoundText}>Recipe not found.</Text>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      <Image
        style={styles.image}
        source={{ uri: recipe.imageUrl }}
        contentFit="cover"
      />
      <View style={styles.contentContainer}>
        <Text style={styles.title}>{recipe.title}</Text>
        <View style={styles.metaContainer}>
          <Text style={styles.metaText}>⏱️ Prep: {recipe.prepTime}min | Cook: {recipe.cookTime}min</Text>
          <Text style={styles.metaText}>👥 Serves: {recipe.servings} | 📊 {recipe.difficulty}</Text>
          <Text style={styles.metaText}>⭐ {recipe.rating} ({recipe.reviewCount} reviews)</Text>
          <Text style={styles.metaText}>🏷️ {recipe.category}</Text>
        </View>
        <Text style={styles.description}>{recipe.description}</Text>

        <Text style={styles.sectionTitle}>Ingredients</Text>
        {recipe.ingredients.map((ingredient, index) => (
          <Text key={index} style={styles.listItem}>
            • {ingredient}
          </Text>
        ))}
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  center: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  image: {
    width: '100%',
    height: 300,
  },
  contentContainer: {
    padding: 16,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  metaContainer: {
    marginBottom: 16,
    padding: 12,
    backgroundColor: '#f8f8f8',
    borderRadius: 8,
  },
  metaText: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  description: {
    fontSize: 16,
    marginBottom: 16,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 8,
    marginTop: 16,
  },
  listItem: {
    fontSize: 16,
    marginBottom: 4,
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#666',
  },
  notFoundText: {
    fontSize: 18,
    color: '#666',
    textAlign: 'center',
  },
});

export default RecipeDetailScreen; 