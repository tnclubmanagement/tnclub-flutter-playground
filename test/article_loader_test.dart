import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_layout_playground/articles/article_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads article metadata and markdown content from an asset', () async {
    final article = await ArticleLoader.load(
      'content/articles/chapter-01-getting-started/01-requirements.vi.md',
    );

    expect(article.id, 'requirements');
    expect(article.chapter, 1);
    expect(article.lesson, 1);
    expect(article.language, 'vi');
    expect(article.flutterVersion, '3.29+');
    expect(article.content, contains('## Kiến thức nền tảng'));
  });
}
