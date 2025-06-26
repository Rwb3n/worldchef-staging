import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_back_button.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_menu_button.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_circular_image.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_metadata_item.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_button.dart';

enum ScreenState { loading, error, success }

/// RecipeDetailScreen - A placeholder implementation based on the UI spec.
class RecipeDetailScreen extends StatelessWidget {
  final ScreenState state;

  const RecipeDetailScreen({
    super.key,
    this.state = ScreenState.success,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const WorldChefBackButton(),
        title: Row(
          children: [
            WCCircularImage(
              imageUrl: 'https://placehold.co/48x48/E91E63/FFFFFF/png',
              size: 40,
              onTap: () {},
            ),
            const SizedBox(width: WorldChefSpacing.sm),
            Text('ChefSannikay', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        actions: [
          WCMenuButton(onPressed: () {}),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildBody(context),
      bottomNavigationBar:
          state == ScreenState.success ? _buildBottomNavBar(context) : null,
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (state) {
      case ScreenState.loading:
        return const Center(child: CircularProgressIndicator());
      case ScreenState.error:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 60),
              SizedBox(height: WorldChefSpacing.md),
              Text('Failed to load recipe details.'),
            ],
          ),
        );
      case ScreenState.success:
        return _buildSuccessView(context);
    }
  }

  Widget _buildSuccessView(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(WorldChefSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jollof rice', style: textTheme.headlineMedium),
          const SizedBox(height: WorldChefSpacing.md),
          const Row(
            children: [
              WCMetadataItem(icon: Icons.timer_outlined, label: '15 minutes'),
              SizedBox(width: WorldChefSpacing.lg),
              WCMetadataItem(icon: Icons.people_outline, label: '5 portions'),
            ],
          ),
          const SizedBox(height: WorldChefSpacing.lg),
          _buildSectionHeader(context, 'Nutrition facts', 'Full nutrition'),
          const SizedBox(height: WorldChefSpacing.md),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('Nutrition Info Placeholder'),
              ),
            ),
          ),
          const SizedBox(height: WorldChefSpacing.lg),
          _buildSectionHeader(context, 'Ingredients', '5 items'),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(WorldChefSpacing.md),
      child: WorldChefButton.primary(
        label: 'Start cooking',
        onPressed: () {},
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(
          onPressed: () {},
          child: Text(actionText),
        ),
      ],
    );
  }
} 