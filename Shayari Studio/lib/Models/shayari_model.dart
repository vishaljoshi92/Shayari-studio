class Shayari {
  final String id;
  final String category;
  final String text;
  final String language;
  bool isFavorite;

  Shayari({
    required this.id,
    required this.category,
    required this.text,
    required this.language,
    this.isFavorite = false,
  });

  factory Shayari.fromJson(Map<String, dynamic> json, String language) {
    return Shayari(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      text: json['text'] ?? '',
      language: language,
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'text': text,
      'language': language,
      'isFavorite': isFavorite,
    };
  }
}

class Language {
  final String code;
  final String name;
  final String flag;

  Language({required this.code, required this.name, required this.flag});
}