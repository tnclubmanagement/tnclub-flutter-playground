import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về ĐA NGÔN NGỮ (i18n/l10n): khai báo locale hỗ trợ, lấy
/// chuỗi dịch theo locale hiện tại, và format ngày/số theo từng vùng.
///
/// Flutter codegen (`flutter gen-l10n` từ file `.arb`) KHÔNG chạy được '
/// trong app demo này - preview mô phỏng bằng 1 `Map` dịch viết tay để
/// minh hoạ ĐÚNG khái niệm, code mẫu là cách làm thật trong project.
class I18nCheatsheet extends StatelessWidget {
  const I18nCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'Khai báo locale hỗ trợ (MaterialApp)',
      category: 'Khai báo & Localization',
      description:
          '`supportedLocales` liệt kê các ngôn ngữ app hỗ trợ. '
          '`localizationsDelegates` (bộ 3 delegate mặc định của Flutter, '
          'Material, Cupertino + delegate riêng do `flutter gen-l10n` '
          'sinh ra) cho Flutter biết CÁCH tải bản dịch tương ứng.',
      snippet: '''
MaterialApp(
  supportedLocales: const [Locale('vi'), Locale('en')],
  localizationsDelegates: const [
    AppLocalizations.delegate, // sinh ra từ file .arb qua `flutter gen-l10n`
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
)''',
      preview: (_) => const _SupportedLocalesDemo(),
    ),
    CheatsheetEntry(
      name: 'AppLocalizations.of(context) - lấy chuỗi theo locale',
      category: 'Khai báo & Localization',
      description:
          'Định nghĩa chuỗi trong file `.arb` (1 file/ngôn ngữ, dạng '
          'JSON có key chung), `flutter gen-l10n` tự SINH RA class '
          '`AppLocalizations` type-safe (gõ sai key -> lỗi lúc COMPILE, '
          'không phải runtime như dùng `Map<String,String>` thủ công).',
      snippet: '''
// lib/l10n/app_vi.arb
{ "welcomeMessage": "Xin chào, {name}!" }
// lib/l10n/app_en.arb
{ "welcomeMessage": "Hello, {name}!" }

// Dùng trong code - tự đổi theo locale hiện tại:
Text(AppLocalizations.of(context)!.welcomeMessage('Trí'))''',
      preview: (_) => const _TranslationMapDemo(),
    ),
    CheatsheetEntry(
      name: 'Format ngày/số theo vùng (package:intl)',
      category: 'Format theo vùng',
      description:
          'Không phải chỉ dịch CHỮ - số/ngày cũng hiển thị KHÁC NHAU theo '
          'vùng (vd 1,234.56 ở Mỹ vs 1.234,56 ở Việt Nam; 10/01/2026 '
          'nghĩa khác nhau ở Mỹ và VN). `package:intl` (cùng nhóm với '
          'gen-l10n, do team flutter.dev duy trì) cung cấp `NumberFormat`/'
          '`DateFormat` tự format đúng theo locale.',
      snippet: '''
final price = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(150000);
// -> "150.000 đ"

final date = DateFormat.yMMMMd('vi').format(DateTime.now());
// -> "10 tháng 1, 2026"''',
      preview: (_) => const _FormatDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'i18n (đa ngôn ngữ) cheat sheet',
      intro:
          'flutter gen-l10n/package:intl KHÔNG chạy trong app demo này - '
          'preview mô phỏng bằng Map dịch viết tay, code mẫu là cách làm '
          'thật trong project cần đa ngôn ngữ.',
      items: _items,
    );
  }
}

class _SupportedLocalesDemo extends StatelessWidget {
  const _SupportedLocalesDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: const [
        Chip(label: Text('🇻🇳 vi', style: TextStyle(fontSize: 11))),
        Chip(label: Text('🇬🇧 en', style: TextStyle(fontSize: 11))),
      ],
    );
  }
}

class _TranslationMapDemo extends StatefulWidget {
  const _TranslationMapDemo();

  @override
  State<_TranslationMapDemo> createState() => _TranslationMapDemoState();
}

class _TranslationMapDemoState extends State<_TranslationMapDemo> {
  static const _translations = {
    'vi': 'Xin chào, Trí!',
    'en': 'Hello, Trí!',
  };

  String _locale = 'vi';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_translations[_locale]!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ToggleButtons(
          isSelected: [_locale == 'vi', _locale == 'en'],
          onPressed: (i) => setState(() => _locale = i == 0 ? 'vi' : 'en'),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 28),
          children: const [Text('vi', style: TextStyle(fontSize: 11)), Text('en', style: TextStyle(fontSize: 11))],
        ),
      ],
    );
  }
}

class _FormatDemo extends StatefulWidget {
  const _FormatDemo();

  @override
  State<_FormatDemo> createState() => _FormatDemoState();
}

class _FormatDemoState extends State<_FormatDemo> {
  bool _vietnam = true;

  @override
  Widget build(BuildContext context) {
    final price = _vietnam ? '150.000 đ' : '\$6.25';
    final date = _vietnam ? '10/01/2026' : '01/10/2026';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Giá: $price', style: const TextStyle(fontSize: 12)),
        Text('Ngày: $date', style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('vi_VN', style: TextStyle(fontSize: 11)),
            Switch(value: !_vietnam, onChanged: (v) => setState(() => _vietnam = !v)),
            const Text('en_US', style: TextStyle(fontSize: 11)),
          ],
        ),
      ],
    );
  }
}
