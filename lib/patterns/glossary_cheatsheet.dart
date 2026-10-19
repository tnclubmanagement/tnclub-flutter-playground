import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Trang tra nhanh THUẬT NGỮ hay gặp khi mới học Flutter/Dart - khác các
/// cheat sheet khác (dạy CÁCH DÙNG), trang này chỉ giải thích NGẮN GỌN từng
/// từ để tra lại khi đọc tài liệu/code mà gặp từ lạ, không cần hiểu sâu
/// ngay - các khái niệm quan trọng (Widget, setState, Hot Reload...) đã có
/// demo/trang riêng dạy kỹ hơn, trang này chỉ là "tra từ điển" nhanh.
class GlossaryCheatsheet extends StatelessWidget {
  const GlossaryCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'Widget',
      category: 'Khái niệm Flutter',
      description:
          'MỌI THỨ hiện trên màn hình Flutter đều là 1 Widget - kể cả '
          'khoảng cách (Padding), màu nền (Container), hay cả 1 trang '
          '(Scaffold). Widget lồng vào nhau tạo thành "widget tree" (xem '
          'thêm bên dưới). Xem demo "StatelessWidget vs StatefulWidget" ở '
          'mục Demos để hiểu kỹ hơn.',
      snippet: '''
// "Hello" bên dưới là 1 Widget (Text), nằm trong Widget khác (Padding),
// nằm trong Widget khác nữa (Center)... - đây là ý nghĩa "widget tree".
Center(child: Padding(padding: EdgeInsets.all(8), child: Text('Hello')))''',
      preview: (_) => const _TermCard(term: 'Widget', icon: Icons.widgets),
    ),
    CheatsheetEntry(
      name: 'Widget tree',
      category: 'Khái niệm Flutter',
      description:
          'Cấu trúc PHÂN CẤP (cha-con) của toàn bộ Widget trong app - '
          'giống cây thư mục. Flutter vẽ UI bằng cách đi từ gốc (root '
          'widget, thường là MaterialApp) xuống từng nhánh con. Hiểu '
          'widget tree giúp biết "đặt widget này vào đâu" khi build UI.',
      snippet: '''
MaterialApp              // gốc
  └── Scaffold           // 1 trang
        └── Column       // xếp dọc
              ├── Text('Tiêu đề')
              └── ElevatedButton(...)''',
      preview: (_) => const _TermCard(term: 'Widget tree', icon: Icons.account_tree),
    ),
    CheatsheetEntry(
      name: 'State',
      category: 'Khái niệm Flutter',
      description:
          'Dữ liệu có thể THAY ĐỔI theo thời gian của 1 StatefulWidget (vd '
          'số đếm, giá trị ô input). Khi state đổi và gọi `setState()`, '
          'Flutter build() lại UI để hiện giá trị mới.',
      snippet: '''
class _MyState extends State<MyWidget> {
  int _count = 0;   // đây là "state" - sống lâu hơn 1 lần build()
}''',
      preview: (_) => const _TermCard(term: 'State', icon: Icons.memory),
    ),
    CheatsheetEntry(
      name: 'BuildContext',
      category: 'Khái niệm Flutter',
      description:
          'Tham số `context` xuất hiện trong hầu hết hàm `build()` - đại '
          'diện cho VỊ TRÍ của widget hiện tại trong widget tree. Dùng để '
          'tra thông tin từ widget CHA phía trên (vd `Theme.of(context)` '
          'lấy theme, `Navigator.of(context)` để chuyển trang).',
      snippet: '''
Widget build(BuildContext context) {
  final color = Theme.of(context).colorScheme.primary; // tra từ cha
  return Text('Hi', style: TextStyle(color: color));
}''',
      preview: (_) => const _TermCard(term: 'BuildContext', icon: Icons.my_location),
    ),
    CheatsheetEntry(
      name: 'build() method',
      category: 'Khái niệm Flutter',
      description:
          'Hàm BẮT BUỘC phải có trong mọi Widget - trả về widget tree mô '
          'tả giao diện. Flutter gọi lại hàm này mỗi khi cần vẽ lại (sau '
          '`setState()`, hoặc khi widget cha truyền prop mới xuống).',
      snippet: '''
@override
Widget build(BuildContext context) {
  return const Text('UI được mô tả ở ĐÂY, mỗi lần build() chạy lại');
}''',
      preview: (_) => const _TermCard(term: 'build()', icon: Icons.construction),
    ),
    CheatsheetEntry(
      name: 'Hot Reload / Hot Restart',
      category: 'Khái niệm Flutter',
      description:
          'Hot Reload (`r`): bơm code mới vào app đang chạy, GIỮ state. '
          'Hot Restart (`R`): chạy lại từ đầu, MẤT state. Xem trang "🚀 '
          'Bắt đầu với Flutter" để có demo tương tác so sánh 2 cái này.',
      snippet: '''
# Khi "flutter run" đang chạy, gõ trong terminal:
r   # Hot Reload
R   # Hot Restart''',
      preview: (_) => const _TermCard(term: 'Hot Reload', icon: Icons.bolt),
    ),
    CheatsheetEntry(
      name: 'SDK (Software Development Kit)',
      category: 'Dự án & môi trường',
      description:
          'Bộ công cụ + thư viện cần có để BUILD được app - "Flutter SDK" '
          'gồm engine render, framework widget, và lệnh CLI (`flutter`). '
          'Không có SDK thì không `flutter run`/`flutter build` được.',
      snippet: '# Kiểm tra SDK đã cài đúng chưa:\nflutter doctor -v',
      preview: (_) => const _TermCard(term: 'SDK', icon: Icons.inventory_2),
    ),
    CheatsheetEntry(
      name: 'pubspec.yaml',
      category: 'Dự án & môi trường',
      description:
          'File cấu hình GỐC của 1 project Flutter - khai báo tên, '
          'version, package cần dùng (`dependencies`), và asset (ảnh/'
          'font). Giống vai trò `package.json` bên Node.js.',
      snippet: '''
name: my_app
dependencies:
  http: ^1.2.0''',
      preview: (_) => const _TermCard(term: 'pubspec.yaml', icon: Icons.description),
    ),
    CheatsheetEntry(
      name: 'Package',
      category: 'Dự án & môi trường',
      description:
          'Thư viện code có sẵn người khác viết, tải về dùng lại qua '
          'pub.dev (kho package chính thức của Dart/Flutter) thay vì tự '
          'viết lại từ đầu - vd `http` (gọi API), `provider` (quản lý '
          'state).',
      snippet: 'flutter pub add http   # thêm package "http" vào project',
      preview: (_) => const _TermCard(term: 'Package', icon: Icons.inventory),
    ),
    CheatsheetEntry(
      name: 'IDE (Integrated Development Environment)',
      category: 'Dự án & môi trường',
      description:
          'Phần mềm dùng để VIẾT CODE (VS Code, Android Studio...) - có '
          'highlight cú pháp, gợi ý code, debug tích hợp. Xem trang "🚀 '
          'Bắt đầu với Flutter" / "Dev Environment" để so sánh VS Code vs '
          'Android Studio.',
      snippet: '// VS Code: cài extension "Flutter" là đủ dùng\ncode --install-extension Dart-Code.flutter',
      preview: (_) => const _TermCard(term: 'IDE', icon: Icons.laptop_mac),
    ),
    CheatsheetEntry(
      name: 'null safety',
      category: 'Lập trình Dart',
      description:
          'Dart BẮT BUỘC khai báo rõ 1 biến có được phép là `null` hay '
          'không (`String` = không được null, `String?` = được phép '
          'null) - giúp bắt lỗi "quên kiểm tra null" ngay lúc viết code '
          'thay vì app crash lúc chạy.',
      snippet: '''
String name = 'Lan';     // KHÔNG được null
String? nickname;        // ĐƯỢC phép null (dấu "?")
print(nickname?.length);  // "?." - chỉ gọi .length nếu nickname khác null''',
      preview: (_) => const _TermCard(term: 'null safety', icon: Icons.security),
    ),
    CheatsheetEntry(
      name: 'async / await / Future',
      category: 'Lập trình Dart',
      description:
          'Dùng cho tác vụ CHỜ kết quả (gọi API, đọc file...) mà không '
          'làm "đứng" app trong lúc chờ. `Future` là "lời hứa" sẽ có giá '
          'trị trong tương lai, `async`/`await` giúp viết code chờ đó '
          'theo kiểu tuần tự, dễ đọc hơn callback lồng nhau.',
      snippet: '''
Future<String> fetchName() async {
  await Future.delayed(const Duration(seconds: 1)); // giả lập chờ mạng
  return 'Lan';
}''',
      preview: (_) => const _TermCard(term: 'async/await', icon: Icons.hourglass_bottom),
    ),
    CheatsheetEntry(
      name: 'const vs final',
      category: 'Lập trình Dart',
      description:
          '`final`: chỉ gán giá trị 1 LẦN, nhưng giá trị có thể được tính '
          'ra LÚC CHẠY (runtime). `const`: giá trị phải biết trước LÚC '
          'BIÊN DỊCH (compile-time) - Flutter tận dụng `const` để BỎ QUA '
          'việc build lại widget đó khi không cần, giúp app nhanh hơn.',
      snippet: '''
final now = DateTime.now();   // OK - tính lúc chạy
const pi = 3.14;              // OK - biết trước lúc compile
const now2 = DateTime.now();  // LỖI - DateTime.now() chỉ biết lúc chạy''',
      preview: (_) => const _TermCard(term: 'const/final', icon: Icons.lock_outline),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: '📚 Giải thích thuật ngữ (Glossary)',
      intro:
          'Tra nhanh các từ hay gặp khi đọc tài liệu/code Flutter mà chưa '
          'quen. Mỗi mục chỉ giải thích NGẮN GỌN - khái niệm quan trọng đã '
          'có demo/trang riêng dạy kỹ hơn (link nhắc tới trong mô tả).',
      items: _items,
    );
  }
}

class _TermCard extends StatelessWidget {
  final String term;
  final IconData icon;

  const _TermCard({required this.term, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.indigo),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              term,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ),
        ],
      ),
    );
  }
}
