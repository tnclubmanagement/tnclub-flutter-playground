import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../models/article.dart';
import 'article_loader.dart';

class ArticlePage extends StatelessWidget {
  final String assetPath;

  const ArticlePage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ArticleLoader.load(assetPath),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Article')),
            body: Center(
              child: Text('Không thể tải bài viết: ${snapshot.error}'),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final article = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Chapter ${article.chapter} · Lesson ${article.lesson}',
            ),
          ),
          body: SelectionArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                if (article.subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    article.subtitle!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
                const SizedBox(height: 12),
                _ArticleMetadata(article: article),
                const SizedBox(height: 24),
                MarkdownBody(
                  data: article.content,
                  selectable: true,
                  imageBuilder: (uri, title, alt) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Image.asset(
                      _resolveAssetPath(article.assetDirectory, uri.toString()),
                      errorBuilder: (context, error, stackTrace) =>
                          Text('Không thể tải hình ảnh: $uri'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _resolveAssetPath(String directory, String imagePath) {
    if (imagePath.startsWith('/')) return imagePath.substring(1);
    if (imagePath.startsWith('assets/') || imagePath.startsWith('content/')) {
      return imagePath;
    }
    return '$directory$imagePath';
  }
}

class _ArticleMetadata extends StatelessWidget {
  final Article article;

  const _ArticleMetadata({required this.article});

  @override
  Widget build(BuildContext context) {
    final details = <String>[
      'Tiếng Việt',
      'Đăng ${_formatDate(article.publishedAt)}',
      if (article.updatedAt != null)
        'Cập nhật ${_formatDate(article.updatedAt!)}',
      if (article.flutterVersion != null) 'Flutter ${article.flutterVersion}',
      if (article.dartVersion != null) 'Dart ${article.dartVersion}',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: details
          .map(
            (detail) =>
                Chip(label: Text(detail), visualDensity: VisualDensity.compact),
          )
          .toList(),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
