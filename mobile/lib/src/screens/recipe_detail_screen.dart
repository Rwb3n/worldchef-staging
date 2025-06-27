import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldchef_mobile/src/core/providers/like_provider.dart';
import 'package:worldchef_mobile/src/core/utils/frame_timing_logger.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_creator_info_row.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_bottom_navigation.dart';
import 'package:worldchef_mobile/src/models/creator_data.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, this.deepLink});

  final String? deepLink; // e.g., app://recipe/123

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    FrameTimingLogger.init();

    // Simple deep-link parsing for logging
    if (widget.deepLink != null) {
      final uri = Uri.tryParse(widget.deepLink!);
      if (uri != null) {
        // ignore: avoid_print
        print('[DeepLink] Opened via path: ${uri.path}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = ref.watch(likeProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const WCBottomNavigation(currentIndex: 0, onTap: _noop),
      body: CustomScrollView(
        slivers: [
          // HERO IMAGE HEADER -------------------------------------------------
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: WorldChefDimensions.recipeHeroHeight,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://example.com/hero.jpg',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: WorldChefSpacing.md,
                    left: WorldChefSpacing.md,
                    child: _HeaderIconButton(
                      icon: Icons.arrow_back,
                      semantic: 'Back',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  Positioned(
                    top: WorldChefSpacing.md,
                    right: WorldChefSpacing.md,
                    child: _HeaderIconButton(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      semantic: 'Toggle favorite',
                      onPressed: () => ref.read(likeProvider.notifier).toggle(),
                      active: isLiked,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BODY CONTENT -----------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: WorldChefSpacing.md,
                vertical: WorldChefSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Classic Margherita Pizza',
                      style: WorldChefTextStyles.headlineMedium),
                  const SizedBox(height: WorldChefSpacing.sm),
                  WCCreatorInfoRow(
                    creator: CreatorData(
                      name: 'Chef Luigi',
                      avatarUrl: 'https://example.com/chef-luigi.jpg',
                    ),
                  ),
                  const SizedBox(height: WorldChefSpacing.md),
                  Row(
                    children: const [
                      _InfoChip(icon: Icons.schedule, label: '45 min'),
                      SizedBox(width: WorldChefDimensions.recipeInfoChipGap),
                      _InfoChip(icon: Icons.restaurant, label: '4 servings'),
                    ],
                  ),
                  const SizedBox(height: WorldChefSpacing.xl),
                  Text('Nutrition Facts',
                      style: WorldChefTextStyles.headlineSmall),
                  const SizedBox(height: WorldChefSpacing.md),
                  _PlaceholderCard(height: 114),
                  const SizedBox(height: WorldChefSpacing.xl),
                  Text('Ingredients',
                      style: WorldChefTextStyles.headlineSmall),
                  const SizedBox(height: WorldChefSpacing.md),
                  _IngredientRow(),
                  _IngredientRow(),
                  _IngredientRow(),
                  const SizedBox(height: WorldChefDimensions.bottomScrollSpacer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _noop(int _) {}
}

// ---------------------------------------------------------------------------
// Helper widgets
// ---------------------------------------------------------------------------

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton(
      {required this.icon, required this.semantic, required this.onPressed, this.active = false});

  final IconData icon;
  final String semantic;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semantic,
      button: true,
      child: Material(
        color: Colors.black45,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: active ? Colors.redAccent : Colors.white),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(label, style: WorldChefTextStyles.labelMedium),
      ],
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(WorldChefDimensions.radiusMedium),
      ),
      alignment: Alignment.center,
      child: const Text('Placeholder', style: TextStyle(color: Colors.grey)),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: WorldChefSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(WorldChefDimensions.radiusMedium),
            child: Image.network(
              'https://example.com/tomato.jpg',
              width: WorldChefDimensions.ingredientImageSize,
              height: WorldChefDimensions.ingredientImageSize,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Text('Cherry Tomatoes', maxLines: 2)),
          const SizedBox(width: 12),
          const Text('200 g'),
        ],
      ),
    );
  }
}
