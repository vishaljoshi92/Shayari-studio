
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle, Clipboard, ClipboardData;
import 'package:share_plus/share_plus.dart';

class ShayariListScreen extends StatefulWidget {
  final String title;
  final String file;
  const ShayariListScreen({super.key, required this.title, required this.file});
  @override State<ShayariListScreen> createState() => _ShayariListScreenState();
}

class _ShayariListScreenState extends State<ShayariListScreen> {
  List items = [];
  @override void initState(){ super.initState(); loadShayari(); }
  Future<void> loadShayari() async {
    final data = await rootBundle.loadString(widget.file);
    setState((){ items = json.decode(data); });
  }
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: (){ Share.share('Check out Shayari Studio - beautiful Hindi & Gujarati shayari!'); },
        child: const Icon(Icons.share),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, index) {
          final s = items[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s['text'] ?? '', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(icon: const Icon(Icons.copy), onPressed: (){ Clipboard.setData(ClipboardData(text: s['text'] ?? '')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard'))); }),
                  IconButton(icon: const Icon(Icons.share), onPressed: (){ Share.share(s['text'] ?? ''); }),
                ]),
              ]),
            ),
          );
        },
      ),
    );
  }
}
