import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về CÔNG CỤ DÒNG LỆNH của Dart/Flutter (khác "Dart syntax
/// cheat sheet" - cheat sheet đó là CÚ PHÁP ngôn ngữ, trang này là CÔNG CỤ
/// chạy trong terminal để quản lý package/kiểm tra/định dạng code).
class DartToolingCheatsheet extends StatelessWidget {
  const DartToolingCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'dart pub add / get - quản lý dependency',
      category: 'Quản lý package',
      description:
          '`pub add` thêm 1 package vào `pubspec.yaml` (tự tìm version '
          'phù hợp) RỒI tự tải về luôn - gọn hơn tự sửa tay '
          '`pubspec.yaml` rồi chạy `pub get` riêng. `pub get` dùng khi '
          'chỉ cần tải lại package đã khai báo sẵn (vd sau khi clone '
          'project/pull code mới).',
      snippet: '''
flutter pub add http          # thêm package http vào pubspec.yaml + tải về
flutter pub add dev:mockito   # thêm vào dev_dependencies (prefix "dev:")

flutter pub get               # chỉ tải lại theo pubspec.yaml đã có
flutter pub upgrade           # nâng cấp package lên version mới nhất (theo constraint)''',
      preview: (_) => const _PubAddDemo(),
    ),
    CheatsheetEntry(
      name: 'dart format - tự format code',
      category: 'Chất lượng code',
      description:
          'Tự format lại TOÀN BỘ file theo chuẩn style chính thức của '
          'Dart (thụt lề, xuống dòng, khoảng cách...) - không cần tranh '
          'luận "style nào đúng" trong team, vì format tự động giống '
          'nhau cho mọi người. Nên bật `formatOnSave` (xem Dev Environment '
          'cheat sheet) để không cần tự nhớ chạy.',
      snippet: '''
dart format .                 # format toàn bộ project
dart format lib/main.dart     # format 1 file cụ thể
dart format --set-exit-if-changed .  # dùng trong CI: fail nếu có file CHƯA format''',
      preview: (_) => const _FormatDemo(),
    ),
    CheatsheetEntry(
      name: 'dart analyze - tìm lỗi/warning tĩnh',
      category: 'Chất lượng code',
      description:
          'Quét TOÀN BỘ project tìm lỗi cú pháp, type sai, warning (biến '
          'không dùng, import thừa...) - KHÔNG cần chạy app. Đây CHÍNH LÀ '
          'lệnh `flutter analyze` đã dùng rất nhiều lần trong suốt app '
          'này để kiểm tra code trước khi xem demo.',
      snippet: '''
flutter analyze

# Output sạch:
# Analyzing my_project...
# No issues found!

# Output có lỗi: chỉ ra đúng file + dòng + loại lỗi để sửa''',
      preview: (_) => const _AnalyzeDemo(),
    ),
    CheatsheetEntry(
      name: 'dart fix --apply - tự sửa lỗi có thể tự sửa',
      category: 'Chất lượng code',
      description:
          'Nhiều warning/lint có cách sửa "chuẩn, không mơ hồ" (vd thêm '
          '`const` còn thiếu, đổi cú pháp cũ sang cú pháp mới) - '
          '`dart fix --apply` tự sửa luôn các lỗi loại này, không cần sửa '
          'tay từng chỗ. Luôn `dart fix --dry-run` trước để xem SẼ đổi gì, '
          'rồi mới `--apply` thật.',
      snippet: '''
dart fix --dry-run    # xem trước sẽ sửa gì, CHƯA đổi file nào
dart fix --apply      # áp dụng thật các fix tự động được''',
      preview: (_) => const _FixApplyDemo(),
    ),
    CheatsheetEntry(
      name: 'dart compile exe/js - build ra file thực thi',
      category: 'Build & compile',
      description:
          '`dart compile exe` biên dịch 1 script Dart THUẦN (không phải '
          'Flutter app) thành file thực thi độc lập (không cần cài Dart '
          'SDK để chạy) - hay dùng cho CLI tool viết bằng Dart. Khác với '
          '`flutter build` (build APP Flutter cho Android/iOS/web).',
      snippet: '''
dart compile exe bin/my_tool.dart -o my_tool   # ra file thực thi native
dart compile js bin/my_tool.dart -o my_tool.js # ra JavaScript (chạy trên web)

# Khác với build 1 APP FLUTTER:
flutter build apk      # ra file .apk cho Android
flutter build web      # ra thư mục web tĩnh (HTML/JS/CanvasKit)''',
      preview: (_) => const _CompileDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'Dart Tooling cheat sheet',
      intro:
          'Các lệnh CLI hay gõ mỗi ngày khi làm Flutter/Dart - khác "Dart '
          'syntax cheat sheet" (cú pháp ngôn ngữ). Trang này không chạy '
          'lệnh thật (cần terminal) - preview minh hoạ lại output.',
      items: _items,
    );
  }
}

class _PubAddDemo extends StatelessWidget {
  const _PubAddDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6)),
      child: const Text(
        '\$ flutter pub add http\nResolving dependencies...\n+ http 1.2.0\nChanged 1 dependency!',
        style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.greenAccent),
      ),
    );
  }
}

class _FormatDemo extends StatelessWidget {
  const _FormatDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('void main(){print("hi");}', style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.red)),
          ],
        ),
        Icon(Icons.arrow_downward, size: 14, color: Theme.of(context).colorScheme.primary),
        const Text(
          'void main() {\n  print("hi");\n}',
          style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.green),
        ),
      ],
    );
  }
}

class _AnalyzeDemo extends StatefulWidget {
  const _AnalyzeDemo();

  @override
  State<_AnalyzeDemo> createState() => _AnalyzeDemoState();
}

class _AnalyzeDemoState extends State<_AnalyzeDemo> {
  bool _clean = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6)),
          child: Text(
            _clean ? 'Analyzing...\nNo issues found!' : "Analyzing...\nerror - unused_import at main.dart:3",
            style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: _clean ? Colors.greenAccent : Colors.redAccent),
          ),
        ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: () => setState(() => _clean = !_clean),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: const Text('Giả lập có lỗi/hết lỗi', style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}

class _FixApplyDemo extends StatelessWidget {
  const _FixApplyDemo();

  @override
  Widget build(BuildContext context) {
    return const _FlowSteps(steps: ['dart fix --dry-run (xem trước)', 'Kiểm tra OK', 'dart fix --apply (sửa thật)']);
  }
}

class _CompileDemo extends StatelessWidget {
  const _CompileDemo();

  @override
  Widget build(BuildContext context) {
    return const _FlowSteps(steps: ['my_tool.dart', 'dart compile exe', 'my_tool (file chạy được)']);
  }
}

class _FlowSteps extends StatelessWidget {
  final List<String> steps;

  const _FlowSteps({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: Colors.indigo.shade100, borderRadius: BorderRadius.circular(6)),
            child: Text(steps[i], style: const TextStyle(fontSize: 10)),
          ),
          if (i != steps.length - 1)
            Icon(Icons.arrow_forward, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ],
      ],
    );
  }
}
