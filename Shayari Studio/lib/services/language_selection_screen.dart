import 'package:flutter/material.dart';
import 'category_list_screen.dart';
import '../models/shayari_model.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  final List<Language> languages = const [
    Language(code: 'hindi', name: 'Hindi Shayari', flag: '🇮🇳'),
    Language(code: 'gujarati', name: 'Gujarati Shayari', flag: '🇮🇳'),
    Language(code: 'english', name: 'English Quotes', flag: '🇺🇸'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Text(
                language.flag,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(
                language.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryListScreen(language: language),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}