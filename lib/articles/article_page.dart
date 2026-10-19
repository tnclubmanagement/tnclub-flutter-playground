import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../home/home_page.dart';
import '../home/nav_sidebar.dart';
import '../models/article.dart';
import '../models/layout_demo.dart';
import 'article_loader.dart';

class ArticlePage extends StatefulWidget {
  final String assetPath;

  const ArticlePage({super.key, required this.assetPath});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _selectedTags = {};
  final Set<String> _expandedSections = {
    'Demos',
    'Examples',
    'Patterns',
    'Cheat Sheet',
    'Môi trường & Công cụ',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(LayoutDemo demo) {
    final query = _query.trim().toLowerCase();
    return (query.isEmpty ||
            demo.title.toLowerCase().contains(query) ||
            demo.description.toLowerCase().contains(query) ||
            demo.tags.any((tag) => tag.toLowerCase().contains(query))) &&
        (_selectedTags.isEmpty || demo.tags.any(_selectedTags.contains));
  }

  List<LayoutDemo> _filter(List<LayoutDemo> demos) =>
      demos.where(_matches).toList();

  List<String> get _allTags {
    final tags = <String>{};
    for (final demo in [
      ...HomePage.demos,
      ...HomePage.examples,
      ...HomePage.patterns,
      ...HomePage.cheatSheets,
      ...HomePage.environmentTools,
    ]) {
      tags.addAll(demo.tags);
    }
    return tags.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final sidebar = NavSidebar(
      searchController: _searchController,
      onSearchChanged: (value) => setState(() => _query = value),
      allTags: _allTags,
      selectedTags: _selectedTags,
      onTagToggle: (tag) => setState(() {
        if (!_selectedTags.remove(tag)) _selectedTags.add(tag);
      }),
      expandedSections: _expandedSections,
      onSectionToggle: (section) => setState(() {
        if (!_expandedSections.remove(section)) _expandedSections.add(section);
      }),
      demos: _filter(HomePage.demos),
      examples: _filter(HomePage.examples),
      patterns: _filter(HomePage.patterns),
      cheatSheets: _filter(HomePage.cheatSheets),
      environmentTools: _filter(HomePage.environmentTools),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        return Scaffold(
          appBar: isWide
              ? null
              : AppBar(title: const Text('Bài viết'), toolbarHeight: 48),
          drawer: isWide ? null : sidebar,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide) SizedBox(width: 300, child: sidebar),
              Expanded(child: _ArticleBody(assetPath: widget.assetPath)),
            ],
          ),
        );
      },
    );
  }
}

class _ArticleBody extends StatelessWidget {
  final String assetPath;

  const _ArticleBody({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ArticleLoader.load(assetPath),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Không thể tải bài viết: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final article = snapshot.data!;
        return SelectionArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
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
        );
      },
    );
  }
}

String _resolveAssetPath(String directory, String imagePath) {
  if (imagePath.startsWith('/')) return imagePath.substring(1);
  if (imagePath.startsWith('assets/') || imagePath.startsWith('content/')) {
    return imagePath;
  }
  return '$directory$imagePath';
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
