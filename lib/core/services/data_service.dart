import 'package:wallpaper_studio/mobile/category.dart';
import 'package:wallpaper_studio/mobile/nature.dart';
import 'package:wallpaper_studio/mobile/section_heading.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final List<String> pages = [
    "Home",
    "Browse",
    "Favourite",
    "Settings",
  ];

  final List<SectionHeading> sectionHeadings = [
    const SectionHeading(
        title: 'Discover Beautiful Wallpapers',
        description:
            'Discovered curated collections of stunning wallpapers. Browse by category, preview in full-screen, and set your favorites'),
    const SectionHeading(
        title: 'Browse Categories',
        description: 'Explore our curated collections of stunning wallpapers'),
    const SectionHeading(
        title: 'Saved Wallpapers',
        description: 'Your saved wallpapers collection'),
    const SectionHeading(
        title: 'Settings',
        description: 'Customize your Wallpaper studio experience'),
  ];

  final List<Category> categories = [
    const Category(
      title: 'Nature',
      description: 'Mountains, Forest and Landscapes',
      tag: '3 wallpapers',
      image: 'assets/categories/category_1.jpg',
    ),
    const Category(
      title: 'Abstract',
      description: 'Modern Geomentric and artistic designs',
      tag: '4 wallpapers',
      image: 'assets/categories/category_2.jpg',
    ),
    const Category(
      title: 'Urban',
      description: 'Cities, architecture and Street',
      tag: '6 wallpapers',
      image: 'assets/categories/category_3.jpg',
    ),
    const Category(
      title: 'Space',
      description: 'Cosmos, planets, and galaxies',
      tag: '3 wallpapers',
      image: 'assets/categories/category_4.jpg',
    ),
    const Category(
      title: 'Minimalist',
      description: 'Clean, simple and elegant',
      tag: '6 wallpapers',
      image: 'assets/categories/category_5.jpg',
    ),
    const Category(
      title: 'Animals',
      description: 'WildLife and nature photography',
      tag: '4 wallpapers',
      image: 'assets/categories/category_6.jpg',
    ),
  ];

  final List<Nature> natures = [
    Nature(
      title: 'Nature 1',
      tag: ['Nature', 'Ambience', 'Flower'],
      description:
          "Discover the pure beauty of 'Natural Essense' - Your gateway to authentic, nature-inspired experiences. Let this unique collection elevate your senses and connect you with the Unrefined elements.",
      imagePath: 'assets/nature/nature_1.jpg',
    ),
    Nature(
      title: 'Nature 2',
      tag: ['Nature', 'Ambience', 'Flower'],
      description:
          "Discover the pure beauty of 'Natural Essense' - Your gateway to authentic, nature-inspired experiences. Let this unique collection elevate your senses and connect you with the Unrefined elements.",
      imagePath: 'assets/nature/nature_2.jpg',
    ),
    Nature(
      title: 'Nature 3',
      tag: ['Nature', 'Ambience', 'Flower'],
      description:
          "Discover the pure beauty of 'Natural Essense' - Your gateway to authentic, nature-inspired experiences. Let this unique collection elevate your senses and connect you with the Unrefined elements.",
      imagePath: 'assets/nature/nature_3.jpg',
    ),
    Nature(
      title: 'Nature 4',
      tag: ['Nature', 'Ambience', 'Flower'],
      description:
          "Discover the pure beauty of 'Natural Essense' - Your gateway to authentic, nature-inspired experiences. Let this unique collection elevate your senses and connect you with the Unrefined elements.",
      imagePath: 'assets/nature/nature_4.jpg',
    ),
    Nature(
      title: 'Nature 5',
      tag: ['Nature', 'Ambience', 'Flower'],
      description:
          "Discover the pure beauty of 'Natural Essense' - Your gateway to authentic, nature-inspired experiences. Let this unique collection elevate your senses and connect you with the Unrefined elements.",
      imagePath: 'assets/nature/nature_5.jpg',
    ),
    Nature(
      title: 'Nature 6',
      tag: ['Nature', 'Ambience', 'Flower'],
      description:
          "Discover the pure beauty of 'Natural Essense' - Your gateway to authentic, nature-inspired experiences. Let this unique collection elevate your senses and connect you with the Unrefined elements.",
      imagePath: 'assets/nature/nature_6.jpg',
    ),
  ];

  // Helper method to get categories by type
  List<Category> getCategoriesByType(String type) {
    return categories.where((category) => category.title == type).toList();
  }

  // Helper method to get natures by tags
  List<Nature> getNaturesByTag(String tag) {
    return natures.where((nature) => nature.tag.contains(tag)).toList();
  }
}
