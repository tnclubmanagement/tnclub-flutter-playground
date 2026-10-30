import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

import '../models/article.dart';

class ArticleLoader {
  const ArticleLoader._();

  static Future<Article> load(String assetPath) async {
    final source = await rootBundle.loadString(assetPath);
    final parts = source.split(RegExp(r'^---\s*$', multiLine: true));
    if (parts.length < 3) {
      throw FormatException('Article thiếu front matter: $assetPath');
    }

    final frontMatter = loadYaml(parts[1]);
    if (frontMatter is! YamlMap) {
      throw FormatException('Front matter không hợp lệ: $assetPath');
    }

    final metadata = Map<String, dynamic>.from(frontMatter);
    final directory = assetPath.substring(0, assetPath.lastIndexOf('/') + 1);

    return Article(
      id: _requiredString(metadata, 'id', assetPath),
      title: _requiredString(metadata, 'title', assetPath),
      subtitle: _optionalString(metadata['subtitle']),
      chapter: _requiredInt(metadata, 'chapter', assetPath),
      lesson: _requiredInt(metadata, 'lesson', assetPath),
      language: _optionalString(metadata['language']) ?? 'vi',
      publishedAt: _requiredDate(metadata, 'publishedAt', assetPath),
      updatedAt: _optionalDate(metadata['updatedAt']),
      flutterVersion: _optionalString(metadata['flutterVersion']),
      dartVersion: _optionalString(metadata['dartVersion']),
      content: parts.sublist(2).join('---').trim(),
      assetDirectory: directory,
    );
  }

  static String _requiredString(
    Map<String, dynamic> metadata,
    String key,
    String path,
  ) {
    final value = _optionalString(metadata[key]);
    if (value == null || value.isEmpty) {
      throw FormatException('Thiếu "$key" trong $path');
    }
    return value;
  }

  static String? _optionalString(Object? value) => value?.toString();

  static int _requiredInt(
    Map<String, dynamic> metadata,
    String key,
    String path,
  ) {
    final value = metadata[key];
    if (value is int) return value;
    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed == null) {
      throw FormatException('"$key" phải là số trong $path');
    }
    return parsed;
  }

  static DateTime _requiredDate(
    Map<String, dynamic> metadata,
    String key,
    String path,
  ) {
    final date = _optionalDate(metadata[key]);
    if (date == null) {
      throw FormatException('"$key" không hợp lệ trong $path');
    }
    return date;
  }

  static DateTime? _optionalDate(Object? value) {
    if (value is DateTime) return value;
    return value == null ? null : DateTime.tryParse(value.toString());
  }
}
