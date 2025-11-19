import 'package:flutter/material.dart';
import 'shayari_detail_screen.dart';
import '../models/shayari_model.dart';
import '../services/shayari_service.dart';

class ShayariListScreen extends StatefulWidget {
  final Language language;
  final String category;

  const ShayariListScreen({
    super.key,
    required this.language,
    required this.category,
  });

  @override
  State<ShayariListScreen> createState() => _ShayariListScreenState();
}

class _ShayariListScreenState extends State<ShayariListScreen> {
  List<Shayari> shayaris = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShayaris();
  }

  Future<void> _loadShayaris() async {
    final loadedShayaris = await ShayariService.getShayariByCategory(
      widget.language.code,
      widget.category,
    );
    setState(() {
      shayaris = loadedShayaris;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} - ${widget.language.name}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : shayaris.isEmpty
              ? const Center(
                  child: Text(
                    'No shayari found for this category',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: shayaris.length,
                  itemBuilder: (context, index) {
                    final shayari = shayaris[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          shayari.text.length > 100
                              ? '${shayari.text.substring(0, 100)}...'
                              : shayari.text,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShayariDetailScreen(shayari: shayari),
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