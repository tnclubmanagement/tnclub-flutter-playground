import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về CÀI ĐẶT MÔI TRƯỜNG: IDE nên dùng, extension hữu ích,
/// `flutter doctor`, và vì sao nên dùng FVM để quản lý version Flutter
/// theo từng project.
class DevEnvironmentCheatsheet extends StatelessWidget {
  const DevEnvironmentCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'Chọn IDE: VS Code hay Android Studio?',
      category: 'IDE & extension',
      description:
          'VS Code: nhẹ, khởi động nhanh, extension "Flutter" (kèm theo '
          '"Dart") là đủ dùng - phù hợp đa số người mới. Android Studio/'
          'IntelliJ: nặng hơn nhưng có sẵn Android SDK Manager/AVD Manager '
          'tích hợp, debug native Android code tốt hơn - hợp khi cần đụng '
          'nhiều tới phần native Android.',
      snippet: '''
# VS Code: cài extension qua Command Palette hoặc:
code --install-extension Dart-Code.flutter

# Extension "Flutter" tự kéo theo extension "Dart" - không cần cài riêng.''',
      preview: (_) => const _IdeChoiceDemo(),
    ),
    CheatsheetEntry(
      name: 'Extension/setting hữu ích cho VS Code',
      category: 'IDE & extension',
      description:
          '"Error Lens" hiện lỗi NGAY trên dòng code (không cần mở tab '
          'Problems). "Awesome Flutter Snippets" gõ tắt (`stless`, '
          '`stful`...) ra khung widget. Bật `editor.formatOnSave` để tự '
          'format code đúng chuẩn Dart mỗi lần lưu - tránh commit code '
          'format lệch gây diff "bẩn".',
      snippet: '''
// .vscode/settings.json (đặt trong từng project)
{
  "editor.formatOnSave": true,
  "[dart]": {
    "editor.rulers": [80], // gợi ý giới hạn 80 cột, không bắt buộc
    "editor.selectionHighlight": false
  },
  "dart.previewFlutterUiGuides": true // hiện đường kẻ cây widget trong editor
}''',
      preview: (_) => const _VscodeSettingsDemo(),
    ),
    CheatsheetEntry(
      name: 'flutter doctor - kiểm tra môi trường',
      category: 'Công cụ CLI',
      description:
          'Chạy ĐẦU TIÊN khi mới cài Flutter hoặc khi gặp lỗi lạ không '
          'liên quan tới code - kiểm tra SDK, toolchain Android/iOS, '
          'IDE đã cài extension chưa, kết nối thiết bị. Dòng nào có '
          '"✗" (lỗi) hoặc "!" (cảnh báo) là thứ cần sửa trước khi code.',
      snippet: '''
flutter doctor -v

# Ví dụ output:
# [✓] Flutter (Channel stable, 3.x.x)
# [✓] Android toolchain
# [!] Xcode - cần cài thêm CocoaPods để build iOS
# [✗] Chrome - không tìm thấy, cần cài để chạy web''',
      preview: (_) => const _FlutterDoctorDemo(),
    ),
    CheatsheetEntry(
      name: 'FVM - vì sao cần quản lý version Flutter theo project?',
      category: 'FVM (Flutter Version Management)',
      description:
          'Mặc định máy bạn chỉ có 1 bản Flutter SDK DUY NHẤT (theo PATH). '
          'Nếu làm nhiều project khác version Flutter (vd project cũ cần '
          '3.16, project mới cần 3.24) - phải TỰ TAY đổi SDK mỗi lần '
          'chuyển project, dễ quên -> lỗi build khó hiểu, hoặc cả team '
          'build ra kết quả khác nhau vì version lệch. FVM cài NHIỀU '
          'bản SDK song song, mỗi project tự "pin" đúng 1 bản qua file '
          '`.fvm/fvm_config.json` (commit vào git) - ai clone code về '
          'cũng tự dùng ĐÚNG version, CI cũng vậy.',
      snippet: '''
# Cài FVM (1 lần, dùng chung cho mọi project)
dart pub global activate fvm

# Trong project: pin đúng version Flutter của project này
fvm install 3.24.0
fvm use 3.24.0   # tạo .fvm/fvm_config.json - commit file này vào git

# Chạy lệnh Flutter QUA fvm (dùng đúng SDK đã pin, không dùng PATH global)
fvm flutter run
fvm flutter pub get''',
      preview: (_) => const _FvmDemo(),
    ),
    CheatsheetEntry(
      name: 'Không dùng FVM thì sao? (rủi ro thật)',
      category: 'FVM (Flutter Version Management)',
      description:
          'Ví dụ thật: bạn `flutter upgrade` để làm project MỚI, sau đó '
          'quay lại project CŨ - code cũ có thể lỗi vì API đã đổi/bị '
          'deprecate ở version mới. Hoặc: đồng nghiệp join team, cài '
          'Flutter bản mới nhất (khác bản team đang dùng), code chạy '
          'được ở máy họ nhưng FAIL trên CI (CI pin version cũ) - mất '
          'thời gian debug "tại sao máy tôi chạy được".',
      snippet: '''
// Không có FVM: "flutter" luôn là 1 bản DUY NHẤT toàn máy
flutter --version  // luôn ra cùng 1 version, dù đang ở project nào

// Có FVM: mỗi project tự biết version của NÓ
cd project_a && fvm flutter --version   // vd 3.16.0
cd ../project_b && fvm flutter --version // vd 3.24.0 - KHÔNG xung đột''',
      preview: (_) => const _NoFvmRiskDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'Dev Environment & FVM cheat sheet',
      intro:
          'Thiết lập môi trường đúng ngay từ đầu giúp tránh rất nhiều lỗi '
          '"khó hiểu" không liên quan tới code của bạn. Trang này không '
          'chạy lệnh thật (cần terminal) - preview minh hoạ lại output/khái '
          'niệm.',
      items: _items,
    );
  }
}

class _IdeChoiceDemo extends StatelessWidget {
  const _IdeChoiceDemo();

  Widget _card(String name, String note, IconData icon) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          Text(note, style: const TextStyle(fontSize: 9), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _card('VS Code', 'Nhẹ, nhanh,\nhợp người mới', Icons.code),
        _card('Android Studio', 'Nặng hơn, mạnh\nvề native Android', Icons.android),
      ],
    );
  }
}

class _VscodeSettingsDemo extends StatelessWidget {
  const _VscodeSettingsDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _SettingRow(label: 'formatOnSave', enabled: true),
        _SettingRow(label: 'Error Lens', enabled: true),
        _SettingRow(label: 'Awesome Flutter Snippets', enabled: true),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final bool enabled;

  const _SettingRow({required this.label, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(enabled ? Icons.check_box : Icons.check_box_outline_blank, size: 16, color: Colors.green),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class _FlutterDoctorDemo extends StatefulWidget {
  const _FlutterDoctorDemo();

  @override
  State<_FlutterDoctorDemo> createState() => _FlutterDoctorDemoState();
}

class _FlutterDoctorDemoState extends State<_FlutterDoctorDemo> {
  bool _ran = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_ran)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6)),
            child: const Text(
              '[✓] Flutter (Channel stable)\n[✓] Android toolchain\n[!] Xcode - thiếu CocoaPods',
              style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.greenAccent),
            ),
          ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: () => setState(() => _ran = true),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: const Text('flutter doctor -v', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

class _FvmDemo extends StatefulWidget {
  const _FvmDemo();

  @override
  State<_FvmDemo> createState() => _FvmDemoState();
}

class _FvmDemoState extends State<_FvmDemo> {
  String _project = 'project_a';

  static const _versions = {'project_a': '3.16.0', 'project_b': '3.24.0'};

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButtons(
          isSelected: [_project == 'project_a', _project == 'project_b'],
          onPressed: (i) => setState(() => _project = i == 0 ? 'project_a' : 'project_b'),
          constraints: const BoxConstraints(minWidth: 70, minHeight: 28),
          children: const [
            Text('project_a', style: TextStyle(fontSize: 10)),
            Text('project_b', style: TextStyle(fontSize: 10)),
          ],
        ),
        const SizedBox(height: 6),
        Text('fvm flutter --version -> ${_versions[_project]}', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
      ],
    );
  }
}

class _NoFvmRiskDemo extends StatelessWidget {
  const _NoFvmRiskDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(6)),
          child: const Text('flutter upgrade (toàn máy)', style: TextStyle(fontSize: 10)),
        ),
        Icon(Icons.arrow_forward, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(6)),
          child: const Text('Project cũ lỗi vì API đổi', style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}
