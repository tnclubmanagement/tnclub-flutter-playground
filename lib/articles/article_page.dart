import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../models/article.dart';
import 'article_loader.dart';

class ArticlePage extends StatefulWidget {
  final String assetPath;

  const ArticlePage({super.key, required this.assetPath});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  int _selectedSection = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Article>(
      future: ArticleLoader.load(widget.assetPath),
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

        return _ArticleScaffold(
          article: snapshot.data!,
          selectedSection: _selectedSection,
          onSelectSection: (index) {
            setState(() => _selectedSection = index);
          },
        );
      },
    );
  }
}

class _ArticleScaffold extends StatelessWidget {
  final Article article;
  final int selectedSection;
  final ValueChanged<int> onSelectSection;

  const _ArticleScaffold({
    required this.article,
    required this.selectedSection,
    required this.onSelectSection,
  });

  @override
  Widget build(BuildContext context) {
    final sections = _articleSections(article.content);
    final labels = ['Tất cả', ...sections.map((section) => section.title)];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        final nav = _ArticleSectionNav(
          labels: labels,
          selectedIndex: selectedSection,
          onSelect: onSelectSection,
          isWide: isWide,
        );
        final body = _ArticleBody(
          article: article,
          markdown: selectedSection == 0
              ? _removeDocumentTitle(article.content)
              : sections[selectedSection - 1].markdown,
        );

        return Scaffold(
          appBar: AppBar(title: Text(article.title)),
          drawer: isWide ? null : Drawer(child: nav),
          body: SelectionArea(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(width: 220, child: nav),
                      const VerticalDivider(width: 1),
                      Expanded(child: body),
                    ],
                  )
                : body,
          ),
        );
      },
    );
  }
}

class _ArticleSectionNav extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool isWide;

  const _ArticleSectionNav({
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return ListTile(
            selected: selected,
            selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
            title: Row(
              children: [
                Text(
                  '${(index + 1).toString().padLeft(2, '0')} ·',
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    labels[index],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              onSelect(index);
              if (!isWide) Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class _ArticleBody extends StatelessWidget {
  final Article article;
  final String markdown;

  const _ArticleBody({required this.article, required this.markdown});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
          data: markdown,
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
    );
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

class _ArticleSection {
  final String title;
  final String markdown;

  const _ArticleSection({required this.title, required this.markdown});
}

List<_ArticleSection> _articleSections(String content) {
  final lines = content.split('\n');
  final sections = <_ArticleSection>[];
  String? title;
  final body = <String>[];

  void addSection() {
    final sectionTitle = title;
    if (sectionTitle != null) {
      sections.add(
        _ArticleSection(
          title: sectionTitle,
          markdown: '## $sectionTitle\n\n${body.join('\n').trim()}',
        ),
      );
    }
    body.clear();
  }

  for (final line in lines) {
    if (line.startsWith('## ')) {
      addSection();
      title = line.substring(3).trim();
    } else if (title != null) {
      body.add(line);
    }
  }
  addSection();
  return sections;
}

String _removeDocumentTitle(String content) =>
    content.replaceFirst(RegExp(r'^# .*\n*', multiLine: true), '').trim();

String _resolveAssetPath(String directory, String imagePath) {
  if (imagePath.startsWith('/')) return imagePath.substring(1);
  if (imagePath.startsWith('assets/') || imagePath.startsWith('content/')) {
    return imagePath;
  }
  return '$directory$imagePath';
}
