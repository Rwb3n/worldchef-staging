import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Image } from 'expo-image';
import { RecipeCard as RecipeCardType } from '../types';

interface RecipeCardProps {
  item: RecipeCardType;
  onPress: () => void;
}

const RecipeCard: React.FC<RecipeCardProps> = ({ item, onPress }) => {
  return (
    <TouchableOpacity style={styles.container} onPress={onPress}>
      <Image
        style={styles.image}
        source={{ uri: item.imageUrl }}
        placeholder={{ uri: 'https://placehold.co/600x400/png' }}
        contentFit="cover"
        transition={300}
      />
      <View style={styles.textContainer}>
        <Text style={styles.title}>{item.name}</Text>
        <Text style={styles.author}>{item.author}</Text>
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#fff',
    borderRadius: 8,
    overflow: 'hidden',
    marginBottom: 16,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
  },
  image: {
    width: '100%',
    height: 200,
  },
  textContainer: {
    padding: 12,
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  author: {
    fontSize: 14,
    color: '#666',
  },
});

export default RecipeCard; 