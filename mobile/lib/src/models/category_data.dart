class CategoryData {
  final String name;
  final String? id;
  final String? imageUrl;
  final bool isCreateButton;

  CategoryData({
    required this.name,
    this.id,
    this.imageUrl,
    this.isCreateButton = false,
  });
}
