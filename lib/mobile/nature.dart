class Nature {
  Nature({
    required this.title,
    required this.tag,
    required this.description,
    required this.imagePath,
    this.isFavorite = false,
  });

  final String title;
  final String description;
  final List<String> tag;
  final String imagePath;
  bool isFavorite;
}
