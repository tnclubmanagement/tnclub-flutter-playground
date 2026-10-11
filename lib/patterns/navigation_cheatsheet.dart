import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về NAVIGATION/ROUTING: push/pop cơ bản, trả dữ liệu khi
/// pop, named routes (chính pattern app này đang dùng ở `main.dart`), và
/// `go_router` cho điều hướng khai báo (declarative).
class NavigationCheatsheet extends StatelessWidget {
  const NavigationCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'Navigator.push / pop cơ bản',
      category: 'Navigator cơ bản',
      description:
          '`push` mở 1 trang MỚI lên trên (chồng vào back-stack), `pop` '
          'đóng trang hiện tại, quay về trang trước. Đây là cách điều '
          'hướng "imperative" (tự gọi lệnh) cơ bản nhất của Flutter.',
      snippet: '''
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => const DetailPage()),
);

// Trong DetailPage, quay lại trang trước:
Navigator.of(context).pop();''',
      preview: (_) => const _PushPopDemo(),
    ),
    CheatsheetEntry(
      name: 'Trả dữ liệu khi pop (await Navigator.push)',
      category: 'Navigator cơ bản',
      description:
          '`Navigator.push` trả về 1 `Future` - `await` nó để nhận giá '
          'trị người dùng chọn ở trang con, truyền qua `Navigator.pop(value)`. '
          'Rất hay dùng cho màn "chọn 1 mục" (chọn địa chỉ, chọn ảnh...).',
      snippet: '''
Future<void> _pickColor(BuildContext context) async {
  final selected = await Navigator.of(context).push<String>(
    MaterialPageRoute(builder: (context) => const ColorPickerPage()),
  );
  if (selected == null) return; // người dùng bấm Back, không chọn gì
  setState(() => _color = selected);
}

// Trong ColorPickerPage, khi người dùng chọn xong:
Navigator.of(context).pop('Đỏ'); // trả "Đỏ" về cho nơi đã await push''',
      preview: (_) => const _PopWithResultDemo(),
    ),
    CheatsheetEntry(
      name: 'Named routes (onGenerateRoute) - CHÍNH app này đang dùng',
      category: 'Named routes',
      description:
          'Mỗi trang gắn 1 "đường dẫn" (path) cố định, điều hướng bằng '
          '`pushNamed(path)` thay vì phải import/nhớ constructor của '
          'từng trang. Lợi ích lớn nhất: URL trên web PHẢN ÁNH ĐÚNG trang '
          'đang xem (F5/share link vẫn mở đúng trang) - xem `lib/main.dart` '
          'của app này, mọi `LayoutDemo` đều có `path` riêng theo đúng '
          'pattern này.',
      snippet: '''
// Khai báo 1 lần, tra theo path khi điều hướng:
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/profile':
      return MaterialPageRoute(builder: (_) => const ProfilePage());
    case '/settings':
      return MaterialPageRoute(builder: (_) => const SettingsPage());
    default:
      return MaterialPageRoute(builder: (_) => const HomePage());
  }
}

MaterialApp(onGenerateRoute: onGenerateRoute, initialRoute: '/');

// Điều hướng bằng path, không cần biết chi tiết widget:
Navigator.of(context).pushNamed('/profile');''',
      preview: (_) => const _NamedRouteDemo(),
    ),
    CheatsheetEntry(
      name: 'go_router (declarative, cần package ngoài)',
      category: 'go_router',
      description:
          'Khai báo TOÀN BỘ cây route 1 lần (giống cấu hình, không phải '
          'gọi lệnh push/pop rải rác) - hỗ trợ sẵn deep link, nested '
          'navigation (vd Bottom Navigation Bar giữ state riêng mỗi tab), '
          'và `redirect` để làm Auth guard (xem Login cheat sheet). '
          'KHÔNG có trong app demo này, cần thêm package `go_router`.',
      snippet: '''
final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomePage()),
  GoRoute(
    path: '/profile/:id',
    builder: (context, state) => ProfilePage(id: state.pathParameters['id']!),
  ),
], redirect: (context, state) {
  if (!authService.isLoggedIn && state.matchedLocation != '/login') {
    return '/login'; // auth guard tích hợp sẵn trong router
  }
  return null;
});

MaterialApp.router(routerConfig: router);''',
      preview: (_) => const _GoRouterDiagramDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'Navigation & Routing cheat sheet',
      intro:
          '2 mục đầu + named routes chạy THẬT (push/pop trong app demo '
          'này). go_router cần package ngoài nên chỉ có sơ đồ minh hoạ.',
      items: _items,
    );
  }
}

class _PushPopDemo extends StatelessWidget {
  const _PushPopDemo();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Trang con')),
            body: Center(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Navigator.pop() - quay lại'),
              ),
            ),
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
      child: const Text('Navigator.push() - mở trang con', style: TextStyle(fontSize: 12)),
    );
  }
}

class _PopWithResultDemo extends StatefulWidget {
  const _PopWithResultDemo();

  @override
  State<_PopWithResultDemo> createState() => _PopWithResultDemoState();
}

class _PopWithResultDemoState extends State<_PopWithResultDemo> {
  String? _selected;

  Future<void> _pick() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Chọn màu')),
          body: Center(
            child: Wrap(
              spacing: 8,
              children: [
                for (final c in ['Đỏ', 'Xanh', 'Vàng'])
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(c),
                    child: Text(c),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (result == null) return;
    setState(() => _selected = result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_selected == null ? 'Chưa chọn màu nào' : 'Đã chọn: $_selected', style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: _pick,
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
          child: const Text('Chọn màu (mở trang con)', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

class _NamedRouteDemo extends StatelessWidget {
  const _NamedRouteDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/widgets-cheatsheet'),
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('/widgets-cheatsheet (mô phỏng)')),
                body: Center(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Quay lại'),
                  ),
                ),
              ),
            ),
          ),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
          child: const Text("pushNamed('/widgets-cheatsheet')", style: TextStyle(fontSize: 11)),
        ),
        const CheatsheetHint('Giống hệt cách bạn bấm các thẻ ở trang chủ app này'),
      ],
    );
  }
}

class _GoRouterDiagramDemo extends StatelessWidget {
  const _GoRouterDiagramDemo();

  Widget _box(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text(label, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
      );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        _box('GoRouter(routes)', Colors.indigo),
        Icon(Icons.arrow_forward, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        _box('redirect (auth guard)', Colors.deepOrange),
        Icon(Icons.arrow_forward, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        _box('đúng trang + đúng URL', Colors.teal),
      ],
    );
  }
}
