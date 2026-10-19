class Article {
  final String id;
  final String title;
  final String? subtitle;
  final int chapter;
  final int lesson;
  final String language;
  final DateTime publishedAt;
  final DateTime? updatedAt;
  final String? flutterVersion;
  final String? dartVersion;
  final String content;
  final String assetDirectory;

  const Article({
    required this.id,
    required this.title,
    this.subtitle,
    required this.chapter,
    required this.lesson,
    required this.language,
    required this.publishedAt,
    this.updatedAt,
    this.flutterVersion,
    this.dartVersion,
    required this.content,
    required this.assetDirectory,
  });
}
