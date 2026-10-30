import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';
import '../widgets/code_panel.dart';

/// Trang tổng hợp (cheat sheet) cách gọi API/service hay gặp trong Flutter:
/// gọi HTTP cơ bản, parse JSON thành model, xử lý loading/error/success,
/// tổ chức code qua Repository pattern, debounce, và tránh lỗi setState
/// sau khi widget đã dispose.
///
/// Để demo KHÔNG phụ thuộc mạng thật (chạy offline/trong môi trường sandbox
/// vẫn thấy được hành vi), các preview bên dưới MÔ PHỎNG gọi API bằng
/// `Future.delayed` + dữ liệu giả, nhưng code mẫu hiển thị là code THẬT
/// dùng package `http`/`dio` để gọi API thực tế.
class ApiServiceCheatsheet extends StatelessWidget {
  const ApiServiceCheatsheet({super.key});

  static final _items = <_ApiInfo>[
    // ---- Gọi API cơ bản ----
    _ApiInfo(
      name: 'GET request (package:http)',
      category: 'Gọi API cơ bản',
      description:
          'Cách gọi API đơn giản nhất: dùng package `http`, gửi GET, kiểm '
          'tra `statusCode` rồi `jsonDecode` body thành `Map`/`List`. Luôn '
          'nhớ bọc `try/catch` hoặc kiểm tra statusCode - API có thể trả '
          'lỗi (404/500) mà KHÔNG throw exception, chỉ trả về response '
          'với status khác 200.',
      snippet: '''
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchUser(int id) async {
  final res = await http.get(Uri.parse('https://api.example.com/users/\$id'));
  if (res.statusCode == 200) {
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
  throw Exception('Lỗi tải user: \${res.statusCode}');
}''',
      preview: (_) => const _GetRequestDemo(),
    ),
    _ApiInfo(
      name: 'Model class + fromJson/toJson',
      category: 'Gọi API cơ bản',
      description:
          'Parse JSON thành 1 class có type rõ ràng (thay vì dùng '
          '`Map<String, dynamic>` rải khắp code - dễ gõ sai tên field mà '
          'không ai báo lỗi lúc compile). `fromJson` là factory constructor '
          '(đã học ở Patterns) tự chọn cách tạo object từ Map, `toJson` '
          'làm ngược lại khi cần GỬI data lên server.',
      snippet: '''
class User {
  final int id;
  final String name;
  const User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

final user = User.fromJson(jsonMap); // Map -> object
final jsonMap2 = user.toJson();       // object -> Map (để gửi lên server)''',
      preview: (_) => const _ModelClassDemo(),
    ),
    _ApiInfo(
      name: 'Dio + interceptor (base URL, token, log)',
      category: 'Gọi API cơ bản',
      description:
          'Dio là package HTTP phổ biến hơn `http` thuần vì có sẵn '
          '`interceptor` - 1 chỗ DUY NHẤT để tự thêm header Authorization '
          'vào MỌI request, log request/response, set timeout, hoặc hủy '
          'request (`CancelToken`) - không phải lặp lại logic đó ở từng '
          'chỗ gọi API.',
      snippet: '''
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['Authorization'] = 'Bearer \$token'; // tự thêm mọi request
      handler.next(options);
    },
    onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        // token hết hạn -> tự điều hướng về trang login...
      }
      handler.next(error);
    },
  ));

final response = await dio.get('/users/1');''',
      preview: (_) => const _DioInterceptorDemo(),
    ),
    // ---- Xử lý trạng thái & lỗi ----
    _ApiInfo(
      name: 'FutureBuilder: loading / error / success',
      category: 'Xử lý trạng thái & lỗi',
      description:
          'Pattern chuẩn để hiện UI theo ĐÚNG 3 trạng thái của 1 lệnh gọi '
          'API: đang tải (`ConnectionState.waiting`), lỗi (`hasError`), và '
          'thành công (`hasData`). Thêm nút "Thử lại" khi lỗi bằng cách đổi '
          '1 `key`/biến để `FutureBuilder` tạo lại Future mới.',
      snippet: '''
Widget build(BuildContext context) {
  return FutureBuilder<User>(
    future: fetchUser(1),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      if (snapshot.hasError) {
        return Column(
          children: [
            Text('Lỗi: \${snapshot.error}'),
            ElevatedButton(onPressed: _retry, child: const Text('Thử lại')),
          ],
        );
      }
      return Text('Xin chào, \${snapshot.data!.name}');
    },
  );
}''',
      preview: (_) => const _FutureBuilderDemo(),
    ),
    _ApiInfo(
      name: 'Debounce khi gọi API theo mỗi keystroke',
      category: 'Xử lý trạng thái & lỗi',
      description:
          'Tránh gọi API NGAY MỖI LẦN người dùng gõ 1 ký tự (vừa tốn băng '
          'thông, vừa có rủi ro request CŨ trả về SAU request MỚI và hiện '
          'sai kết quả). Dùng `Timer`: mỗi lần gõ thì HỦY timer cũ và đặt '
          'timer mới - chỉ khi người dùng NGỪNG gõ đủ lâu thì mới thực sự '
          'gọi API.',
      snippet: '''
Timer? _debounce;

void onSearchChanged(String query) {
  _debounce?.cancel(); // huỷ lần gõ trước, chưa kịp gọi API thì thôi
  _debounce = Timer(const Duration(milliseconds: 400), () {
    fetchSearchResults(query); // chỉ gọi khi đã ngừng gõ 400ms
  });
}

@override
void dispose() {
  _debounce?.cancel(); // tránh gọi API sau khi widget đã đóng
  super.dispose();
}''',
      preview: (_) => const _DebounceDemo(),
    ),
    _ApiInfo(
      name: 'Kiểm tra `mounted` trước khi setState sau API',
      category: 'Xử lý trạng thái & lỗi',
      description:
          'Nếu người dùng rời trang (pop) TRƯỚC KHI API trả lời xong, '
          'response về SAU vẫn cố gọi `setState()` trên 1 widget đã bị '
          'dispose -> lỗi runtime "setState() called after dispose()". '
          'Luôn kiểm tra `mounted` (true nếu widget còn trong tree) ngay '
          'trước khi `setState` trong hàm `async`.',
      snippet: '''
Future<void> _load() async {
  final data = await fetchUser(1); // có thể mất vài giây
  if (!mounted) return; // widget đã bị dispose trong lúc chờ -> dừng lại
  setState(() => _user = data);
}''',
      preview: (_) => const _MountedCheckDemo(),
    ),
    // ---- Tổ chức code ----
    _ApiInfo(
      name: 'Repository pattern (tách UI khỏi cách gọi API)',
      category: 'Tổ chức code',
      description:
          'Gom toàn bộ logic gọi API (http/dio, URL, parse JSON) vào 1 '
          'class `Repository` riêng - UI chỉ gọi method của Repository qua '
          '1 `interface` (abstract class), KHÔNG biết/không quan tâm bên '
          'trong dùng http hay dio hay cache. Lợi ích: dễ viết TEST (tạo '
          'Fake Repository trả data giả, không cần gọi mạng thật), và dễ '
          'đổi nguồn dữ liệu sau này mà UI không phải sửa gì.',
      snippet: '''
abstract class UserRepository {
  Future<User> getUser(int id);
}

class ApiUserRepository implements UserRepository {
  final http.Client client;
  ApiUserRepository(this.client);

  @override
  Future<User> getUser(int id) async {
    final res = await client.get(Uri.parse('https://api.example.com/users/\$id'));
    return User.fromJson(jsonDecode(res.body));
  }
}

// Test: không cần gọi mạng thật, chỉ cần implement lại interface
class FakeUserRepository implements UserRepository {
  @override
  Future<User> getUser(int id) async => const User(id: 1, name: 'Test User');
}

// UI chỉ cần biết interface UserRepository, không quan tâm chi tiết bên trong:
class UserScreen extends StatelessWidget {
  final UserRepository repository;
  const UserScreen({required this.repository});
}''',
      preview: (_) => const _RepositoryDemo(),
    ),
  ];

  static List<String> get _categories =>
      _items.map((i) => i.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return CategoryFilterScaffold(
      title: 'API & Service cheat sheet',
      categories: _categories,
      bodyBuilder: (category) => _ApiList(
        items: category == null
            ? _items
            : _items.where((i) => i.category == category).toList(),
      ),
    );
  }
}

class _ApiList extends StatelessWidget {
  final List<_ApiInfo> items;

  const _ApiList({required this.items});

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
              'Demo bên dưới MÔ PHỎNG gọi API (không gọi mạng thật) để '
              'chạy được offline, nhưng code mẫu là code THẬT dùng '
              'http/dio. Lọc theo nhóm bằng tab ở trên, hoặc xem "Tất cả".',
            ),
          );
        }
        return _ApiCard(info: items[index - 1]);
      },
    );
  }
}

class _ApiInfo {
  final String name;
  final String category;
  final String description;
  final String snippet;
  final WidgetBuilder preview;

  const _ApiInfo({
    required this.name,
    required this.category,
    required this.description,
    required this.snippet,
    required this.preview,
  });
}

class _ApiCard extends StatelessWidget {
  final _ApiInfo info;

  const _ApiCard({required this.info});

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
                Text(
                  info.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    info.category,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              info.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '▶ Minh họa trực quan:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(builder: info.preview),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
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

class _Hint extends StatelessWidget {
  final String text;

  const _Hint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// "Gọi API": mô phỏng fetchUser bằng Future.delayed, có thể trả lỗi giả
/// để thấy cả nhánh thành công và nhánh lỗi.
Future<Map<String, dynamic>> _fakeFetchUser({bool forceError = false}) async {
  await Future.delayed(const Duration(milliseconds: 700));
  if (forceError) {
    throw Exception('Không kết nối được server (giả lập)');
  }
  return {'id': 1, 'name': 'Trí Ngô'};
}

class _GetRequestDemo extends StatefulWidget {
  const _GetRequestDemo();

  @override
  State<_GetRequestDemo> createState() => _GetRequestDemoState();
}

class _GetRequestDemoState extends State<_GetRequestDemo> {
  late Future<Map<String, dynamic>> _future = _fakeFetchUser();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            return Text(
              'Kết quả: ${snapshot.data}',
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => setState(() {
            _future = _fakeFetchUser();
          }),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: const Text('Gọi API', style: TextStyle(fontSize: 12)),
        ),
        const _Hint('Mô phỏng GET, trễ ~700ms rồi trả JSON giả'),
      ],
    );
  }
}

/// "Model class": hiện trực tiếp Map JSON và object đã parse để so sánh.
class _ModelClassDemo extends StatelessWidget {
  const _ModelClassDemo();

  @override
  Widget build(BuildContext context) {
    const jsonMap = {'id': 1, 'name': 'Trí Ngô'};
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'JSON thô:',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        Text(
          '$jsonMap',
          style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 8),
        Icon(
          Icons.arrow_downward,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        const Text(
          'Sau User.fromJson(...):',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const Text(
          "User(id: 1, name: 'Trí Ngô')",
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'monospace',
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}

/// "Dio interceptor": mô phỏng log console khi interceptor tự thêm header.
class _DioInterceptorDemo extends StatelessWidget {
  const _DioInterceptorDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        '>> GET /users/1\n'
        '>> Authorization: Bearer eyJhbG... (interceptor tự thêm)\n'
        '<< 200 OK (124ms)',
        style: TextStyle(
          fontSize: 10,
          fontFamily: 'monospace',
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}

/// "FutureBuilder loading/error/success": nút "Gọi lại" random thành
/// công/lỗi để thấy đủ 3 trạng thái, có nút "Thử lại" khi lỗi.
class _FutureBuilderDemo extends StatefulWidget {
  const _FutureBuilderDemo();

  @override
  State<_FutureBuilderDemo> createState() => _FutureBuilderDemoState();
}

class _FutureBuilderDemoState extends State<_FutureBuilderDemo> {
  late Future<Map<String, dynamic>> _future = _call();
  final _random = Random();

  Future<Map<String, dynamic>> _call() =>
      _fakeFetchUser(forceError: _random.nextBool());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        Widget content;
        if (snapshot.connectionState == ConnectionState.waiting) {
          content = const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        } else if (snapshot.hasError) {
          content = Text(
            'Lỗi: ${snapshot.error}',
            style: const TextStyle(fontSize: 11, color: Colors.red),
          );
        } else {
          content = Text(
            'Xin chào, ${snapshot.data!['name']}',
            style: const TextStyle(fontSize: 12),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => setState(() {
                _future = _call();
              }),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
              child: const Text(
                'Gọi lại (random lỗi)',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// "Debounce": đếm số lần THỰC SỰ gọi "API" so với số ký tự đã gõ.
class _DebounceDemo extends StatefulWidget {
  const _DebounceDemo();

  @override
  State<_DebounceDemo> createState() => _DebounceDemoState();
}

class _DebounceDemoState extends State<_DebounceDemo> {
  Timer? _debounce;
  int _keystrokes = 0;
  int _apiCalls = 0;
  String _lastQuery = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _keystrokes++);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _apiCalls++;
        _lastQuery = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 140,
          child: TextField(
            onChanged: _onChanged,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Gõ thử...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Số ký tự gõ: $_keystrokes  |  Số lần gọi API: $_apiCalls',
          style: const TextStyle(fontSize: 10),
        ),
        if (_lastQuery.isNotEmpty)
          Text(
            'Đã gọi API với: "$_lastQuery"',
            style: const TextStyle(fontSize: 10, color: Colors.deepPurple),
          ),
      ],
    );
  }
}

/// "mounted check": minh hoạ bằng cách "giả lập rời trang" - bật cờ
/// isDisposedSimulated để thấy setState KHÔNG chạy nếu không check mounted.
class _MountedCheckDemo extends StatefulWidget {
  const _MountedCheckDemo();

  @override
  State<_MountedCheckDemo> createState() => _MountedCheckDemoState();
}

class _MountedCheckDemoState extends State<_MountedCheckDemo> {
  String _status = 'Chưa gọi';
  bool _simulateLeftPage = false;

  Future<void> _load() async {
    setState(() => _status = 'Đang gọi API (3s)...');
    await Future.delayed(const Duration(seconds: 1));
    // Mô phỏng "mounted" bằng 1 cờ tự set, vì demo này không thật sự rời trang.
    if (_simulateLeftPage) {
      setState(() => _status = 'Đã bỏ qua vì mounted == false (giả lập)');
      return;
    }
    if (!mounted) return;
    setState(() => _status = 'setState() thành công: có data!');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Giả lập rời trang trước khi xong:',
              style: TextStyle(fontSize: 10),
            ),
            Switch(
              value: _simulateLeftPage,
              onChanged: (v) => setState(() => _simulateLeftPage = v),
            ),
          ],
        ),
        Text(_status, style: const TextStyle(fontSize: 11)),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: _load,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: const Text('Gọi API', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

/// "Repository pattern": sơ đồ tĩnh UI -> Repository -> http/dio.
class _RepositoryDemo extends StatelessWidget {
  const _RepositoryDemo();

  Widget _box(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        _box(context, 'UserScreen (UI)', Colors.indigo),
        Icon(
          Icons.arrow_forward,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        _box(context, 'UserRepository\n(interface)', Colors.teal),
        Icon(
          Icons.arrow_forward,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        _box(context, 'ApiUserRepository\n(http/dio thật)', Colors.deepOrange),
      ],
    );
  }
}
