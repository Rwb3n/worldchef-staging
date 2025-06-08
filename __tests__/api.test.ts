import { getRecipes, getRecipeById } from '../src/services/api';
import { Recipe } from '../src/types';

global.fetch = jest.fn();

const mockRecipes: Recipe[] = [
  {
    id: '1',
    name: 'Test Recipe 1',
    description: 'Test Description 1',
    author: 'Test Author 1',
    imageUrl: 'test1.jpg',
    ingredients: ['Test Ingredient 1'],
    steps: ['Test Step 1'],
  },
  {
    id: '2',
    name: 'Test Recipe 2',
    description: 'Test Description 2',
    author: 'Test Author 2',
    imageUrl: 'test2.jpg',
    ingredients: ['Test Ingredient 2'],
    steps: ['Test Step 2'],
  },
];

describe('API Service', () => {
  beforeEach(() => {
    (fetch as jest.Mock).mockClear();
  });

  it('should fetch recipes successfully', async () => {
    (fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      json: async () => mockRecipes,
    });

    const recipes = await getRecipes();

    expect(recipes).toEqual(mockRecipes);
    expect(fetch).toHaveBeenCalledWith('http://localhost:3000/recipes');
  });

  it('should fetch a recipe by id successfully', async () => {
    (fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      json: async () => mockRecipes[0],
    });

    const recipe = await getRecipeById('1');

    expect(recipe).toEqual(mockRecipes[0]);
    expect(fetch).toHaveBeenCalledWith('http://localhost:3000/recipes/1');
  });

  it('should throw an error if fetching recipes fails', async () => {
    (fetch as jest.Mock).mockResolvedValueOnce({
      ok: false,
    });

    await expect(getRecipes()).rejects.toThrow('Failed to fetch recipes');
  });

  it('should throw an error if fetching a recipe by id fails', async () => {
    (fetch as jest.Mock).mockResolvedValueOnce({
      ok: false,
    });

    await expect(getRecipeById('1')).rejects.toThrow(
      'Failed to fetch recipe with id 1'
    );
  });
}); 