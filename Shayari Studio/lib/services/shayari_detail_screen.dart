import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import '../models/shayari_model.dart';
import '../services/favorite_service.dart';

class ShayariDetailScreen extends StatefulWidget {
  final Shayari shayari;

  const ShayariDetailScreen({super.key, required this.shayari});

  @override
  State<ShayariDetailScreen> createState() => _ShayariDetailScreenState();
}

class _ShayariDetailScreenState extends State<ShayariDetailScreen> {
  late Shayari shayari;
  final ScreenshotController screenshotController = ScreenshotController();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    shayari = widget.shayari;
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final favorite = await FavoriteService.isFavorite(shayari);
    setState(() {
      isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    await FavoriteService.toggleFavorite(shayari);
    setState(() {
      isFavorite = !isFavorite;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: shayari.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  Future<void> _shareAsText() async {
    await Share.share(shayari.text);
  }

  Future<void> _shareAsImage() async {
    try {
      final image = await screenshotController.capture();
      if (image == null) return;

      final tempDir = Directory.systemTemp;
      final file = await File('${tempDir.path}/shayari_${shayari.id}.png').create();
      await file.writeAsBytes(image);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sharing image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shayari.category),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.format_quote,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      shayari.text,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '- ${shayari.category} -',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.content_copy,
                  label: 'Copy',
                  onPressed: _copyToClipboard,
                ),
                _buildActionButton(
                  icon: Icons.share,
                  label: 'Share Text',
                  onPressed: _shareAsText,
                ),
                _buildActionButton(
                  icon: Icons.image,
                  label: 'Share Image',
                  onPressed: _shareAsImage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}