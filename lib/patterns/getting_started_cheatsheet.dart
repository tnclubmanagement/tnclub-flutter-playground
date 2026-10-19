import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet dành cho người MỚI TINH, chưa từng đụng Flutter: Flutter/Dart
/// là gì, cài SDK, tạo project đầu tiên, cấu trúc project, và chạy app +
/// Hot Reload/Restart. Đặt là mục ĐẦU TIÊN trong "Môi trường & Công cụ" vì
/// các trang khác (chọn IDE, FVM, Dart Tooling...) đều giả định bạn ĐÃ cài
/// xong Flutter và biết chạy app rồi.
class GettingStartedCheatsheet extends StatelessWidget {
  const GettingStartedCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'Flutter là gì? Dart là gì?',
      category: 'Flutter & Dart là gì?',
      description:
          'Dart là NGÔN NGỮ lập trình (do Google tạo) - giống vai trò của '
          'Python/JavaScript. Flutter là 1 FRAMEWORK viết bằng Dart, cho '
          'phép viết UI 1 LẦN rồi chạy được trên Android, iOS, Web, '
          'Windows/macOS/Linux - không cần viết lại UI riêng cho từng nền '
          'tảng như cách làm native truyền thống.',
      snippet: '''
// Dart: ngôn ngữ (cú pháp, kiểu dữ liệu, async/await, null safety...)
void main() => print('Hello Dart');

// Flutter: framework DÙNG Dart để build UI - MỌI THỨ hiện trên màn hình
// (Text, khoảng cách, màu nền...) đều là 1 Widget, lồng vào nhau.
void main() => runApp(
  const Center(child: Text('Hello Flutter', textDirection: TextDirection.ltr)),
);''',
      preview: (_) => const _PlatformsDemo(),
    ),
    CheatsheetEntry(
      name: 'Vì sao nên học Flutter?',
      category: 'Flutter & Dart là gì?',
      description:
          '1 codebase chạy NHIỀU nền tảng - tiết kiệm thời gian so với viết '
          'riêng app Android (Kotlin) + iOS (Swift). Hot Reload sửa code '
          'thấy kết quả gần NHƯ NGAY LẬP TỨC, không cần build lại từ đầu. '
          'Hệ sinh thái package lớn (pub.dev), được Google đứng sau + cộng '
          'đồng đông đảo, nhu cầu tuyển dụng ngày càng nhiều.',
      snippet: '''
// KHÔNG có Flutter: 2 codebase riêng, 2 ngôn ngữ riêng
// Android: MainActivity.kt (Kotlin)      iOS: ViewController.swift (Swift)

// CÓ Flutter: 1 codebase Dart duy nhất
// lib/main.dart -> build ra APK (Android), IPA (iOS), và web cùng lúc.''',
      preview: (_) => const _WhyFlutterDemo(),
    ),
    CheatsheetEntry(
      name: 'Cài Flutter SDK (lần đầu)',
      category: 'Cài đặt & tạo project đầu tiên',
      description:
          'Tải Flutter SDK từ trang chủ CHÍNH THỨC (flutter.dev) theo đúng '
          'hệ điều hành máy bạn, giải nén, rồi thêm vào biến môi trường '
          'PATH. Sau đó BẮT BUỘC chạy `flutter doctor` (xem thêm ở mục '
          '"Công cụ CLI" của trang Dev Environment) để kiểm tra đã cài đủ '
          'Android SDK/Xcode/IDE extension chưa - đừng vội code khi doctor '
          'còn báo lỗi "✗".',
      snippet: '''
# 1. Tải Flutter SDK tại trang chủ chính thức: https://flutter.dev
#    (chọn đúng hệ điều hành: Windows/macOS/Linux)
# 2. Giải nén, thêm thư mục "flutter/bin" vào biến môi trường PATH
# 3. Kiểm tra đã cài đúng chưa - sửa hết các dòng "✗"/"!" trước khi code:
flutter doctor -v''',
      preview: (_) => const _InstallStepsDemo(),
    ),
    CheatsheetEntry(
      name: '`flutter create` - tạo project đầu tiên',
      category: 'Cài đặt & tạo project đầu tiên',
      description:
          'Lệnh này tự tạo SẴN 1 project Flutter hoàn chỉnh (đủ thư mục, '
          'file mẫu, cấu hình cho mọi nền tảng) - không cần tự tạo tay '
          'từng file. Project mẫu có sẵn 1 app đếm số (counter) để chạy '
          'thử NGAY, chưa cần hiểu code đã thấy app chạy được thật.',
      snippet: '''
flutter create my_app
cd my_app
flutter run        # chạy thử app mẫu (counter) ngay lập tức''',
      preview: (_) => const _FlutterCreateDemo(),
    ),
    CheatsheetEntry(
      name: 'Các thư mục chính trong project',
      category: 'Cấu trúc project & pubspec.yaml',
      description:
          '`lib/` - TOÀN BỘ code Dart của bạn, `lib/main.dart` là điểm '
          'BẮT ĐẦU chạy app. `android/`, `ios/`, `web/`... - cấu hình/code '
          'RIÊNG cho từng nền tảng (lúc mới học hầu như KHÔNG cần đụng '
          'vào). `test/` - nơi viết unit/widget test. `pubspec.yaml` - file '
          'khai báo package cần dùng + asset (ảnh/font).',
      snippet: '''
my_app/
├── lib/
│   └── main.dart      # code Dart chính, entry point của app
├── android/           # cấu hình/code riêng cho Android
├── ios/               # cấu hình/code riêng cho iOS
├── web/               # cấu hình riêng khi build ra web
├── test/              # unit/widget test
└── pubspec.yaml       # khai báo package + asset''',
      preview: (_) => const _ProjectTreeDemo(),
    ),
    CheatsheetEntry(
      name: '`pubspec.yaml` dùng để làm gì?',
      category: 'Cấu trúc project & pubspec.yaml',
      description:
          'Giống `package.json` của Node.js - khai báo TÊN project, '
          'version, package cần dùng (`dependencies`), package chỉ cần '
          'lúc code/test (`dev_dependencies`), và asset (ảnh, font) cần '
          'đóng gói theo app. Sau khi sửa file này PHẢI chạy '
          '`flutter pub get` (xem mục Dart Tooling) để tải/áp dụng.',
      snippet: '''
name: my_app
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0          # package gọi API, thêm bằng "flutter pub add http"

flutter:
  assets:
    - assets/images/    # khai báo thư mục ảnh để dùng được trong app''',
      preview: (_) => const _PubspecDemo(),
    ),
    CheatsheetEntry(
      name: '`flutter run` - chọn device & chạy app',
      category: 'Chạy app & Hot Reload',
      description:
          'Trước khi chạy cần có ÍT NHẤT 1 "device" (điện thoại thật/giả '
          'lập/trình duyệt) đang sẵn sàng. `flutter devices` liệt kê các '
          'device đang kết nối/mở sẵn, `flutter run -d <id>` chạy đúng '
          'device đó - bỏ `-d` thì Flutter tự hỏi chọn nếu có nhiều hơn 1.',
      snippet: '''
flutter devices          # xem danh sách device đang kết nối/giả lập đang mở
flutter run               # chạy app (tự hỏi chọn device nếu có > 1)
flutter run -d chrome     # chỉ định rõ chạy trên Chrome (web)''',
      preview: (_) => const _DeviceListDemo(),
    ),
    CheatsheetEntry(
      name: 'Hot Reload (phím `r`) vs Hot Restart (phím `R`)',
      category: 'Chạy app & Hot Reload',
      description:
          'Hot Reload: bơm code MỚI vào app đang chạy mà KHÔNG mất state '
          'hiện tại (vd counter đang là 5 thì vẫn giữ 5) - nhanh, hợp khi '
          'chỉ sửa UI/logic trong `build()`. Hot Restart: khởi động lại '
          'app từ ĐẦU (mất hết state, chạy lại `main()`) - cần dùng khi '
          'sửa gì đó Hot Reload không áp dụng được (vd đổi biến `static`/'
          'global, thêm field mới vào State).',
      snippet: '''
# Khi "flutter run" đang chạy, gõ trực tiếp trong terminal:
r   # Hot Reload  - giữ state, áp dụng thay đổi trong vài trăm ms
R   # Hot Restart - mất state, chạy lại từ đầu (chậm hơn Reload)
q   # Thoát app''',
      preview: (_) => const _HotReloadVsRestartDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: '🚀 Bắt đầu với Flutter',
      intro:
          'Trang này dành cho người CHƯA TỪNG đụng Flutter - đi từ "Flutter '
          'là gì" tới lúc chạy được app đầu tiên trên máy. Các trang khác '
          'trong "Môi trường & Công cụ" (chọn IDE, FVM...) giả định bạn đã '
          'qua được bước này rồi.',
      items: _items,
    );
  }
}

class _PlatformsDemo extends StatelessWidget {
  const _PlatformsDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '1 codebase Dart (Flutter)',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Icon(Icons.arrow_downward, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: const [
            _PlatformChip('Android', Icons.android),
            _PlatformChip('iOS', Icons.phone_iphone),
            _PlatformChip('Web', Icons.language),
            _PlatformChip('Desktop', Icons.desktop_windows),
          ],
        ),
      ],
    );
  }
}

class _PlatformChip extends StatelessWidget {
  final String name;
  final IconData icon;

  const _PlatformChip(this.name, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(height: 2),
          Text(name, style: const TextStyle(fontSize: 9)),
        ],
      ),
    );
  }
}

class _WhyFlutterDemo extends StatelessWidget {
  const _WhyFlutterDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _ReasonRow('1 codebase, nhiều nền tảng'),
        _ReasonRow('Hot Reload - sửa code thấy ngay'),
        _ReasonRow('Package phong phú (pub.dev)'),
        _ReasonRow('Google đứng sau + cộng đồng lớn'),
      ],
    );
  }
}

class _ReasonRow extends StatelessWidget {
  final String text;

  const _ReasonRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 14, color: Colors.green),
          const SizedBox(width: 6),
          Flexible(child: Text(text, style: const TextStyle(fontSize: 11))),
        ],
      ),
    );
  }
}

class _InstallStepsDemo extends StatefulWidget {
  const _InstallStepsDemo();

  @override
  State<_InstallStepsDemo> createState() => _InstallStepsDemoState();
}

class _InstallStepsDemoState extends State<_InstallStepsDemo> {
  static const _steps = [
    'Tải Flutter SDK (flutter.dev)',
    'Thêm vào PATH',
    'Chạy flutter doctor',
  ];

  int _done = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _steps.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  i < _done ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 14,
                  color: i < _done ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text('${i + 1}. ${_steps[i]}', style: const TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: _done >= _steps.length ? null : () => setState(() => _done++),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: Text(
            _done >= _steps.length ? 'Xong! Sẵn sàng code' : 'Hoàn thành bước tiếp theo',
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _FlutterCreateDemo extends StatefulWidget {
  const _FlutterCreateDemo();

  @override
  State<_FlutterCreateDemo> createState() => _FlutterCreateDemoState();
}

class _FlutterCreateDemoState extends State<_FlutterCreateDemo> {
  bool _created = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_created)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6)),
            child: const Text(
              'Creating project my_app...\n'
              'Wrote 127 files.\n'
              'All done! my_app is ready.',
              style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.greenAccent),
            ),
          ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: () => setState(() => _created = true),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: const Text('flutter create my_app', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

class _ProjectTreeDemo extends StatefulWidget {
  const _ProjectTreeDemo();

  @override
  State<_ProjectTreeDemo> createState() => _ProjectTreeDemoState();
}

class _ProjectTreeDemoState extends State<_ProjectTreeDemo> {
  static const _entries = {
    'lib/main.dart': 'Code Dart chính - entry point chạy app',
    'android/, ios/, web/': 'Cấu hình/code riêng từng nền tảng',
    'test/': 'Nơi viết unit/widget test',
    'pubspec.yaml': 'Khai báo package + asset',
  };

  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in _entries.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: InkWell(
              onTap: () => setState(() => _selected = entry.key),
              child: Row(
                children: [
                  const Icon(Icons.folder, size: 14, color: Colors.amber),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        fontWeight: _selected == entry.key ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 6),
        SizedBox(
          height: 28,
          child: Text(
            _selected == null ? '(bấm vào 1 dòng để xem giải thích)' : _entries[_selected]!,
            style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _PubspecDemo extends StatelessWidget {
  const _PubspecDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: Colors.indigo.shade100, borderRadius: BorderRadius.circular(6)),
          child: const Text('dependencies: (package dùng trong app)', style: TextStyle(fontSize: 10)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: Colors.teal.shade100, borderRadius: BorderRadius.circular(6)),
          child: const Text('dev_dependencies: (chỉ cần lúc code/test)', style: TextStyle(fontSize: 10)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(6)),
          child: const Text('assets: (ảnh, font đóng gói theo app)', style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}

class _DeviceListDemo extends StatefulWidget {
  const _DeviceListDemo();

  @override
  State<_DeviceListDemo> createState() => _DeviceListDemoState();
}

class _DeviceListDemoState extends State<_DeviceListDemo> {
  static const _devices = ['Chrome (web)', 'iPhone 15 (giả lập)', 'Pixel 7 (giả lập)'];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _devices.length; i++)
          InkWell(
            onTap: () => setState(() => _selected = i),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(
                    i == _selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    size: 14,
                    color: i == _selected ? Colors.blue : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Flexible(child: Text(_devices[i], style: const TextStyle(fontSize: 11))),
                ],
              ),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          'flutter run -d "${_devices[_selected]}"',
          style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
        ),
      ],
    );
  }
}

class _HotReloadVsRestartDemo extends StatefulWidget {
  const _HotReloadVsRestartDemo();

  @override
  State<_HotReloadVsRestartDemo> createState() => _HotReloadVsRestartDemoState();
}

class _HotReloadVsRestartDemoState extends State<_HotReloadVsRestartDemo> {
  int _counter = 0;
  String _status = 'Bấm "+" để tăng counter, rồi thử Hot Reload/Restart.';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Counter: $_counter', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            IconButton(
              iconSize: 18,
              visualDensity: VisualDensity.compact,
              onPressed: () => setState(() {
                _counter++;
                _status = 'Đã tăng counter (giống app đang chạy thật).';
              }),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => _status = '🔥 Hot Reload: code mới đã áp dụng - counter GIỮ NGUYÊN ($_counter).'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
              child: const Text('🔥 Hot Reload (r)', style: TextStyle(fontSize: 10)),
            ),
            OutlinedButton(
              onPressed: () => setState(() {
                _counter = 0;
                _status = '🔁 Hot Restart: app chạy lại từ đầu - counter MẤT, về 0.';
              }),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
              child: const Text('🔁 Hot Restart (R)', style: TextStyle(fontSize: 10)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 220,
          child: Text(
            _status,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
