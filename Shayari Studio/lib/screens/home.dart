
import 'package:flutter/material.dart';
import 'list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Hindi Shayari', 'file': 'assets/hindi_shayari.json'},
      {'title': 'Gujarati Shayari', 'file': 'assets/gujarati_shayari.json'},
      {'title': 'English Quotes', 'file': 'assets/english_quotes.json'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Shayari Studio')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final c = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ShayariListScreen(title: c['title']!, file: c['file']!)));
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [Colors.purple, Colors.deepPurple], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: Center(child: Text(c['title']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            ),
          );
        },
      ),
    );
  }
}
