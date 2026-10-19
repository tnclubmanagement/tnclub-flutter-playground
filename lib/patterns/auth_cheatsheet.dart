import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';
import '../widgets/code_panel.dart';

/// Trang tổng hợp (cheat sheet) các vấn đề hay gặp khi làm LOGIN/CREDENTIAL:
/// lưu token an toàn, tự chuyển hướng khi chưa đăng nhập, tự refresh token
/// hết hạn, và logout "sạch" (không chỉ xoá token).
///
/// Các package thật (flutter_secure_storage, dio...) KHÔNG có trong
/// pubspec.yaml của app demo này - preview bên dưới MÔ PHỎNG hành vi bằng
/// biến trong memory để minh hoạ LUỒNG xử lý, code mẫu mới là code thật cần
/// dùng trong app production.
class AuthCheatsheet extends StatelessWidget {
  const AuthCheatsheet({super.key});

  static final _items = <_AuthInfo>[
    // ---- Lưu trữ an toàn ----
    _AuthInfo(
      name: 'flutter_secure_storage (lưu token an toàn)',
      category: 'Lưu trữ an toàn',
      description:
          'KHÔNG nên lưu access token/refresh token bằng '
          '`SharedPreferences` - nó lưu dạng file text thường, đọc được '
          'nếu máy bị root/jailbreak. `flutter_secure_storage` lưu vào '
          'Keychain (iOS) / Keystore (Android) - được hệ điều hành MÃ HOÁ, '
          'an toàn hơn nhiều cho dữ liệu nhạy cảm.',
      snippet: '''
final storage = const FlutterSecureStorage();

// Lưu token sau khi login thành công
await storage.write(key: 'access_token', value: token);

// Đọc lại khi mở app (vd kiểm tra đã đăng nhập sẵn chưa)
final token = await storage.read(key: 'access_token');

// Xoá khi logout
await storage.delete(key: 'access_token');''',
      preview: (_) => const _SecureStorageDemo(),
    ),
    // ---- Luồng xác thực (Auth flow) ----
    _AuthInfo(
      name: 'Auth guard - tự chuyển hướng nếu chưa đăng nhập',
      category: 'Luồng xác thực (Auth flow)',
      description:
          'Kiểm tra trạng thái đăng nhập TRƯỚC khi cho vào 1 trang cần '
          'bảo vệ - nếu chưa có token hợp lệ, tự redirect về trang Login '
          'thay vì để user vào được rồi mới báo lỗi. Thường làm qua '
          '`redirect` của `go_router`, hoặc 1 widget "Gatekeeper" bọc '
          'ngoài route cần bảo vệ.',
      snippet: '''
class AuthGate extends StatelessWidget {
  final Widget child; // trang cần bảo vệ (vd Dashboard)
  const AuthGate({required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authService.isLoggedIn(), // đọc token, kiểm tra còn hạn
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        if (snapshot.data == true) return child; // đã đăng nhập -> cho vào
        return const LoginScreen(); // chưa đăng nhập -> chuyển về Login
      },
    );
  }
}''',
      preview: (_) => const _AuthGateDemo(),
    ),
    _AuthInfo(
      name: 'Token refresh tự động (401 -> refresh -> retry)',
      category: 'Luồng xác thực (Auth flow)',
      description:
          'Access token thường có hạn NGẮN (vd 15 phút) vì lý do an toàn. '
          'Khi API trả 401 (hết hạn), dùng interceptor (Dio) tự gọi API '
          '"refresh" bằng refresh token (hạn DÀI hơn) để lấy access token '
          'mới, rồi RETRY lại request cũ - người dùng KHÔNG phải đăng '
          'nhập lại mỗi 15 phút.',
      snippet: '''
dio.interceptors.add(InterceptorsWrapper(
  onError: (error, handler) async {
    if (error.response?.statusCode == 401) {
      final newToken = await refreshAccessToken(); // gọi API refresh
      error.requestOptions.headers['Authorization'] = 'Bearer \$newToken';
      final retried = await dio.fetch(error.requestOptions); // gọi lại request cũ
      return handler.resolve(retried);
    }
    handler.next(error); // lỗi khác 401 -> trả lỗi như thường
  },
));''',
      preview: (_) => const _TokenRefreshDemo(),
    ),
    _AuthInfo(
      name: 'Logout - xoá HẾT, không chỉ xoá token',
      category: 'Luồng xác thực (Auth flow)',
      description:
          'Logout không chỉ xoá token - còn phải: xoá cache data của user '
          'cũ (tránh user B thấy data user A khi dùng chung máy), reset '
          'state trong Provider/Bloc, và xoá sạch BACK-STACK (nếu không, '
          'bấm nút Back vẫn quay lại được trang đã đăng nhập cũ).',
      snippet: '''
Future<void> logout(BuildContext context) async {
  await storage.delete(key: 'access_token');
  await storage.delete(key: 'refresh_token');
  userProvider.reset(); // xoá cache user trong app, KHÔNG CHỈ xoá token

  if (!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false, // xoá sạch back-stack, không bấm Back quay lại được
  );
}''',
      preview: (_) => const _LogoutChecklistDemo(),
    ),
    // ---- Form đăng nhập/đăng ký ----
    _AuthInfo(
      name: 'Kiểm tra độ mạnh mật khẩu khi nhập',
      category: 'Form đăng nhập/đăng ký',
      description:
          'Phản hồi NGAY khi người dùng gõ (không phải đợi bấm Submit) '
          'giúp họ chọn mật khẩu đủ mạnh ngay từ đầu - tính độ mạnh dựa '
          'trên độ dài + có chữ hoa/số/ký tự đặc biệt hay không.',
      snippet: '''
int passwordStrength(String password) {
  var score = 0;
  if (password.length >= 8) score++;
  if (password.contains(RegExp(r'[A-Z]'))) score++;
  if (password.contains(RegExp(r'[0-9]'))) score++;
  if (password.contains(RegExp(r'[!@#\$%^&*]'))) score++;
  return score; // 0-4
}

TextField(
  onChanged: (value) => setState(() => _strength = passwordStrength(value)),
)''',
      preview: (_) => const _PasswordStrengthDemo(),
    ),
  ];

  static List<String> get _categories =>
      _items.map((i) => i.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return CategoryFilterScaffold(
      title: 'Login & Credential cheat sheet',
      categories: _categories,
      bodyBuilder: (category) => _AuthList(
        items: category == null
            ? _items
            : _items.where((i) => i.category == category).toList(),
      ),
    );
  }
}

class _AuthList extends StatelessWidget {
  final List<_AuthInfo> items;

  const _AuthList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Package thật (flutter_secure_storage, dio...) không có '
              'trong app demo này - preview bên dưới MÔ PHỎNG luồng xử lý '
              'bằng biến trong memory. Lọc theo nhóm bằng tab ở trên, hoặc '
              'xem "Tất cả".',
            ),
          );
        }
        return _AuthCard(info: items[index - 1]);
      },
    );
  }
}

class _AuthInfo {
  final String name;
  final String category;
  final String description;
  final String snippet;
  final WidgetBuilder preview;

  const _AuthInfo({
    required this.name,
    required this.category,
    required this.description,
    required this.snippet,
    required this.preview,
  });
}

class _AuthCard extends StatelessWidget {
  final _AuthInfo info;

  const _AuthCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(info.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(label: Text(info.category, style: const TextStyle(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 8),
            Text(info.description, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Text(
              '▶ Minh họa trực quan:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(builder: info.preview),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: CodePanel(source: info.snippet, error: null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "flutter_secure_storage": map trong memory mô phỏng Keychain/Keystore.
class _SecureStorageDemo extends StatefulWidget {
  const _SecureStorageDemo();

  @override
  State<_SecureStorageDemo> createState() => _SecureStorageDemoState();
}

class _SecureStorageDemoState extends State<_SecureStorageDemo> {
  String? _token;
  String _status = 'Chưa có gì được lưu';

  void _write() => setState(() {
        _token = 'eyJhbGciOi... (giả lập)';
        _status = '🔒 Đã lưu (mã hoá qua Keychain/Keystore)';
      });

  void _read() => setState(() {
        _status = _token == null ? 'Không tìm thấy token' : '🔑 Đọc được: $_token';
      });

  void _delete() => setState(() {
        _token = null;
        _status = '🗑️ Đã xoá token';
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_status, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _write,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('Lưu token', style: TextStyle(fontSize: 11)),
            ),
            OutlinedButton(
              onPressed: _read,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('Đọc token', style: TextStyle(fontSize: 11)),
            ),
            OutlinedButton(
              onPressed: _delete,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('Xoá token', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }
}

/// "Auth guard": toggle "đã đăng nhập" để thấy việc tự chuyển hướng.
class _AuthGateDemo extends StatefulWidget {
  const _AuthGateDemo();

  @override
  State<_AuthGateDemo> createState() => _AuthGateDemoState();
}

class _AuthGateDemoState extends State<_AuthGateDemo> {
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Đã đăng nhập:', style: TextStyle(fontSize: 12)),
            Switch(value: _loggedIn, onChanged: (v) => setState(() => _loggedIn = v)),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _loggedIn
              ? Container(
                  key: const ValueKey('home'),
                  padding: const EdgeInsets.all(8),
                  color: Colors.green.shade100,
                  child: const Text('✅ AuthGate cho vào Dashboard', style: TextStyle(fontSize: 11)),
                )
              : Container(
                  key: const ValueKey('login'),
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange.shade100,
                  child: const Text('↩️ Chưa đăng nhập -> tự chuyển về LoginScreen', style: TextStyle(fontSize: 11)),
                ),
        ),
      ],
    );
  }
}

/// "Token refresh": chạy tuần tự 1 chuỗi trạng thái 401 -> refresh -> retry.
class _TokenRefreshDemo extends StatefulWidget {
  const _TokenRefreshDemo();

  @override
  State<_TokenRefreshDemo> createState() => _TokenRefreshDemoState();
}

class _TokenRefreshDemoState extends State<_TokenRefreshDemo> {
  static const _steps = [
    'Gọi API với token cũ...',
    '❌ 401 Unauthorized (token hết hạn)',
    '🔄 Đang refresh token...',
    '✅ Có access token mới',
    '🔁 Gọi lại request cũ với token mới...',
    '🎉 200 OK - user không cần đăng nhập lại',
  ];

  int _step = -1;
  bool _running = false;

  Future<void> _run() async {
    if (_running) return;
    setState(() => _running = true);
    for (var i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      setState(() => _step = i);
    }
    setState(() => _running = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 18,
          child: Text(
            _step < 0 ? 'Bấm "Mô phỏng" để xem luồng' : _steps[_step],
            style: const TextStyle(fontSize: 11),
          ),
        ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: _run,
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: Text(_running ? 'Đang chạy...' : 'Mô phỏng', style: const TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

/// "Logout": checklist các bước PHẢI làm, hiện dần khi bấm Logout - nhấn
/// mạnh ý "không chỉ xoá token".
class _LogoutChecklistDemo extends StatefulWidget {
  const _LogoutChecklistDemo();

  @override
  State<_LogoutChecklistDemo> createState() => _LogoutChecklistDemoState();
}

class _LogoutChecklistDemoState extends State<_LogoutChecklistDemo> {
  static const _checklist = [
    'Xoá access/refresh token',
    'Reset cache user trong Provider/Bloc',
    'Xoá sạch back-stack (pushAndRemoveUntil)',
  ];

  int _done = 0;
  bool _running = false;

  Future<void> _logout() async {
    if (_running) return;
    setState(() {
      _running = true;
      _done = 0;
    });
    for (var i = 0; i < _checklist.length; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() => _done = i + 1);
    }
    setState(() => _running = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _checklist.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  i < _done ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 14,
                  color: i < _done ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(_checklist[i], style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: _logout,
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: const Text('Đăng xuất', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

/// "Password strength": thanh màu đổi theo độ mạnh khi gõ.
class _PasswordStrengthDemo extends StatefulWidget {
  const _PasswordStrengthDemo();

  @override
  State<_PasswordStrengthDemo> createState() => _PasswordStrengthDemoState();
}

class _PasswordStrengthDemoState extends State<_PasswordStrengthDemo> {
  int _strength = 0;

  int _compute(String password) {
    var score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*]'))) score++;
    return score;
  }

  static const _labels = ['Rất yếu', 'Yếu', 'Trung bình', 'Khá', 'Mạnh'];
  static const _colors = [Colors.red, Colors.orange, Colors.amber, Colors.lightGreen, Colors.green];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 150,
          child: TextField(
            obscureText: true,
            onChanged: (value) => setState(() => _strength = _compute(value)),
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Nhập mật khẩu...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 4; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 30,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                color: i < _strength ? _colors[_strength] : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(_labels[_strength], style: TextStyle(fontSize: 11, color: _colors[_strength])),
      ],
    );
  }
}
