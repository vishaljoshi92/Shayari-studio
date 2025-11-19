import 'package:flutter/material.dart';
import 'shayari_list_screen.dart';
import '../models/shayari_model.dart';
import '../services/shayari_service.dart';

class CategoryListScreen extends StatefulWidget {
  final Language language;

  const CategoryListScreen({super.key, required this.language});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<String> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final loadedCategories = await ShayariService.getCategories(widget.language.code);
    setState(() {
      categories = loadedCategories;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(
                      _getCategoryIcon(category),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      category,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('Tap to view ${category.toLowerCase()} shayari'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShayariListScreen(
                            language: widget.language,
                            category: category,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'love':
        return Icons.favorite;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'motivational':
        return Icons.rocket_launch;
      case 'friendship':
        return Icons.people;
      case 'attitude':
        return Icons.self_improvement;
      default:
        return Icons.text_snippet;
    }
  }
}