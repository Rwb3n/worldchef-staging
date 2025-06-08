import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import RecipeListScreen from '../screens/RecipeListScreen';
import RecipeDetailScreen from '../screens/RecipeDetailScreen';

export type RootStackParamList = {
  RecipeList: undefined;
  RecipeDetail: { recipeId: number };
};

const Stack = createStackNavigator<RootStackParamList>();

const AppNavigator = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="RecipeList">
        <Stack.Screen name="RecipeList" component={RecipeListScreen} options={{ title: 'Recipes' }} />
        <Stack.Screen name="RecipeDetail" component={RecipeDetailScreen} options={{ title: 'Recipe Details' }} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default AppNavigator; 