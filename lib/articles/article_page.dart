import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
          onOpenLink: (url) async {
            final uri = Uri.tryParse(url);
            if (uri != null && await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
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
  final Future<void> Function(String url) onOpenLink;
  final ValueChanged<int> onSelectSection;

  const _ArticleScaffold({
    required this.article,
    required this.selectedSection,
    required this.onOpenLink,
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
          onOpenLink: onOpenLink,
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
  final Future<void> Function(String url) onOpenLink;

  const _ArticleBody({
    required this.article,
    required this.markdown,
    required this.onOpenLink,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imagePath = _firstImagePath(article.content);
    final accent = theme.colorScheme.primary;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    Color.alphaBlend(
                      accent.withValues(alpha: 0.18),
                      theme.colorScheme.surface,
                    ),
                    Color.alphaBlend(
                      theme.colorScheme.tertiary.withValues(alpha: 0.10),
                      theme.colorScheme.surface,
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: accent.withValues(alpha: 0.20)),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHAPTER ${article.chapter.toString().padLeft(2, '0')}  /  LESSON ${article.lesson.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  if (article.subtitle != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      article.subtitle!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _ArticleMetadata(article: article),
                  if (imagePath != null) ...[
                    const SizedBox(height: 22),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        _resolveAssetPath(article.assetDirectory, imagePath),
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 30),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: MarkdownBody(
                data: markdown,
                selectable: true,
                onTapLink: (text, href, title) {
                  if (href != null) onOpenLink(href);
                },
                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.7,
                    color: theme.colorScheme.onSurface,
                  ),
                  a: TextStyle(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  h2: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  h3: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  code: TextStyle(
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onSurface,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  blockquoteDecoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.08),
                    border: Border(left: BorderSide(color: accent, width: 4)),
                  ),
                  blockquotePadding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                ),
                imageBuilder: (uri, title, alt) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Image.asset(
                    _resolveAssetPath(article.assetDirectory, uri.toString()),
                    errorBuilder: (context, error, stackTrace) =>
                        Text('Không thể tải hình ảnh: $uri'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

String? _firstImagePath(String markdown) {
  final match = RegExp(r'!\[[^\]]*\]\(([^)]+)\)').firstMatch(markdown);
  return match?.group(1);
}
