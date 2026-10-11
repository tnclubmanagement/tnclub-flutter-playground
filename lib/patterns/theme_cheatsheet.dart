import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về THEME & DARK MODE: `ThemeData`/`ColorScheme.fromSeed`,
/// cách đọc màu/style qua `Theme.of(context)` (đã dùng RẤT nhiều trong các
/// cheat sheet khác của app này), và cách tự chuyển light/dark.
class ThemeCheatsheet extends StatelessWidget {
  const ThemeCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'ColorScheme.fromSeed - tạo bộ màu từ 1 màu gốc',
      category: 'ThemeData',
      description:
          'Thay vì tự chọn TỪNG màu (primary, background, error...) - '
          'đưa 1 màu "gốc" (`seedColor`) cho `ColorScheme.fromSeed`, '
          'Flutter tự sinh ra TOÀN BỘ bảng màu hài hoà (Material 3) kèm '
          'cả bản tương phản tốt cho dark mode. Chính app này dùng '
          'cách này (xem `MyApp` trong `main.dart`).',
      snippet: '''
final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF5B4FE9),
  brightness: Brightness.light, // đổi sang Brightness.dark cho bản tối
);

MaterialApp(
  theme: ThemeData(colorScheme: colorScheme, useMaterial3: true),
)''',
      preview: (_) => const _SeedColorDemo(),
    ),
    CheatsheetEntry(
      name: 'Theme.of(context) - đọc màu/style theo theme',
      category: 'ThemeData',
      description:
          'KHÔNG hardcode `Colors.deepPurple`/`Colors.grey` trực tiếp - '
          'đọc qua `Theme.of(context).colorScheme...` để màu tự đổi theo '
          'theme (light/dark) đang active. Toàn bộ cheat sheet trong app '
          'này đều áp dụng đúng nguyên tắc này (vd `colorScheme.outlineVariant` '
          'cho viền, `colorScheme.onSurfaceVariant` cho chữ phụ).',
      snippet: '''
// SAI: cứng màu, không đổi theo theme/dark mode
Container(color: Colors.deepPurple.shade50)

// ĐÚNG: tự đổi đúng theo theme đang active
Container(color: Theme.of(context).colorScheme.primaryContainer)''',
      preview: (_) => const _ThemeOfDemo(),
    ),
    CheatsheetEntry(
      name: 'Tự chuyển Light/Dark (ThemeMode)',
      category: 'Dark mode',
      description:
          '`MaterialApp` nhận CẢ 2 theme (`theme` cho light, `darkTheme` '
          'cho dark) + `themeMode` để chọn dùng theme nào. '
          '`ThemeMode.system` (mặc định hay dùng) tự theo cài đặt hệ '
          'điều hành; `ThemeMode.light`/`.dark` ép cố định; muốn cho '
          'NGƯỜI DÙNG tự chọn thì lưu lựa chọn đó (xem Local Storage '
          'cheat sheet - `shared_preferences`) rồi set lại `themeMode`.',
      snippet: '''
MaterialApp(
  theme: ThemeData(colorScheme: lightScheme),
  darkTheme: ThemeData(colorScheme: darkScheme),
  themeMode: _useDark ? ThemeMode.dark : ThemeMode.light, // hoặc .system
)

// Đổi lựa chọn (thường gọi từ 1 Switch trong Settings):
setState(() => _useDark = !_useDark);''',
      preview: (_) => const _ThemeModeDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'Theme & Dark Mode cheat sheet',
      intro:
          'Demo bên dưới tạo 1 Theme CỤC BỘ riêng cho preview (không đổi '
          'theme của cả app) để bạn thấy trực quan sự khác biệt light/dark '
          'mà không ảnh hưởng các trang khác.',
      items: _items,
    );
  }
}

class _SeedColorDemo extends StatefulWidget {
  const _SeedColorDemo();

  @override
  State<_SeedColorDemo> createState() => _SeedColorDemoState();
}

class _SeedColorDemoState extends State<_SeedColorDemo> {
  Color _seed = Colors.indigo;

  static const _seeds = [Colors.indigo, Colors.teal, Colors.deepOrange, Colors.pink];

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: _seed);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 6,
          children: [
            _swatch('primary', scheme.primary),
            _swatch('secondaryContainer', scheme.secondaryContainer),
            _swatch('surface', scheme.surface),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: [
            for (final s in _seeds)
              GestureDetector(
                onTap: () => setState(() => _seed = s),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: s,
                    shape: BoxShape.circle,
                    border: _seed == s ? Border.all(color: Colors.black, width: 2) : null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _swatch(String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 24,
          decoration: BoxDecoration(color: color, border: Border.all(color: Colors.black12)),
        ),
        Text(label, style: const TextStyle(fontSize: 8)),
      ],
    );
  }
}

class _ThemeOfDemo extends StatelessWidget {
  const _ThemeOfDemo();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
      child: Text(
        'Theme.of(context).colorScheme.primaryContainer',
        style: TextStyle(fontSize: 11, color: scheme.onPrimaryContainer),
      ),
    );
  }
}

class _ThemeModeDemo extends StatefulWidget {
  const _ThemeModeDemo();

  @override
  State<_ThemeModeDemo> createState() => _ThemeModeDemoState();
}

class _ThemeModeDemoState extends State<_ThemeModeDemo> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5B4FE9),
      brightness: _dark ? Brightness.dark : Brightness.light,
    );
    return Theme(
      data: ThemeData(colorScheme: scheme, useMaterial3: true),
      child: Builder(
        builder: (context) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _dark ? 'ThemeMode.dark' : 'ThemeMode.light',
                style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: () => setState(() => _dark = !_dark),
                child: const Text('Đổi theme', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
