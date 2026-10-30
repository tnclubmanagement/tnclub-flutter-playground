import 'package:flutter/material.dart';

import '../widgets/code_panel.dart';

/// Trang giới thiệu các package phổ biến trong hệ sinh thái Flutter.
///
/// Đây CHỈ là trang thông tin tĩnh: các đoạn code bên dưới là ví dụ minh hoạ
/// cách dùng (copy từ docs của từng package), KHÔNG chạy thật trong app này
/// (app chưa cài các package này trong pubspec.yaml). Muốn dùng thật, bạn cần
/// tự thêm dependency tương ứng vào project của mình.
class LibrariesPage extends StatelessWidget {
  const LibrariesPage({super.key});

  static const _libraries = [
    _LibraryInfo(
      name: 'flutter_hooks',
      category: 'State / Logic reuse',
      pubPackage: 'flutter_hooks',
      description:
          'Mang "hooks" kiểu React sang Flutter: useState, useEffect, '
          'useMemoized... giúp viết logic có state mà KHÔNG cần tách thành '
          '2 class Widget/State như StatefulWidget truyền thống, và dễ tái '
          'sử dụng logic giữa nhiều widget hơn (custom hook).',
      snippet: '''
class Counter extends HookWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    // Thay cho: final State với 1 field _count + setState().
    final count = useState(0);

    return Row(
      children: [
        Text('\${count.value}'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => count.value++,
        ),
      ],
    );
  }
}''',
    ),
    _LibraryInfo(
      name: 'provider',
      category: 'State management / Dependency Injection',
      pubPackage: 'provider',
      description:
          'Wrapper gọn & chính thức khuyên dùng cho InheritedWidget. Đưa '
          '1 object (ChangeNotifier, giá trị bất kỳ...) lên trên tree bằng '
          'Provider/ChangeNotifierProvider, widget con đọc bằng '
          'context.watch/context.read mà không cần tự viết InheritedWidget.',
      snippet: '''
class CartModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void add() {
    _count++;
    notifyListeners();
  }
}

// Đặt ở gốc app:
ChangeNotifierProvider(
  create: (_) => CartModel(),
  child: const MyApp(),
);

// Đọc/ghi ở bất kỳ widget con nào:
final cart = context.watch<CartModel>();
Text('\${cart.count}');
ElevatedButton(onPressed: () => context.read<CartModel>().add(), ...);''',
    ),
    _LibraryInfo(
      name: 'flutter_riverpod',
      category: 'State management',
      pubPackage: 'flutter_riverpod',
      description:
          'Phiên bản "đời sau" của provider: không phụ thuộc BuildContext để '
          'khai báo state (an toàn hơn khi test, không lo "Provider not '
          'found"), hỗ trợ sẵn cache/auto-dispose và combine nhiều state '
          '(provider phụ thuộc provider khác) rất gọn.',
      snippet: '''
final counterProvider = StateProvider((ref) => 0);

class CounterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return ElevatedButton(
      onPressed: () => ref.read(counterProvider.notifier).state++,
      child: Text('\$count'),
    );
  }
}''',
    ),
    _LibraryInfo(
      name: 'go_router',
      category: 'Routing / Navigation',
      pubPackage: 'go_router',
      description:
          'Routing khai báo (declarative) dựa trên URL path, hỗ trợ sẵn '
          'deep-link, nested routes, redirect (ví dụ chặn vào trang cần '
          'login). Thay thế cho việc tự viết onGenerateRoute như trong '
          'main.dart của project này.',
      snippet: '''
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (c, s) => const HomePage()),
    GoRoute(
      path: '/users/:id',
      builder: (c, s) => UserPage(id: s.pathParameters['id']!),
    ),
  ],
);

MaterialApp.router(routerConfig: router);

// Điều hướng:
context.go('/users/42');''',
    ),
    _LibraryInfo(
      name: 'dio',
      category: 'Network / HTTP client',
      pubPackage: 'dio',
      description:
          'HTTP client mạnh hơn package http: hỗ trợ sẵn interceptor (log, '
          'gắn token tự động), timeout, cancel request, upload/download '
          'file với progress callback.',
      snippet: '''
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['Authorization'] = 'Bearer \$token';
      handler.next(options);
    },
  ),
);

final response = await dio.get('/users/1');
print(response.data);''',
    ),
    _LibraryInfo(
      name: 'freezed',
      category: 'Model / Code generation',
      pubPackage: 'freezed',
      description:
          'Sinh code (build_runner) cho data class immutable: tự tạo '
          'copyWith, ==/hashCode, toString, và union types (sealed class) '
          'tiện cho state (loading/data/error) mà không cần viết tay.',
      snippet: '''
@freezed
class User with _\$User {
  const factory User({
    required String name,
    required int age,
  }) = _User;
}

// Dùng:
final u = User(name: 'An', age: 20);
final u2 = u.copyWith(age: 21);''',
    ),
    _LibraryInfo(
      name: 'intl',
      category: 'Định dạng / Đa ngôn ngữ',
      pubPackage: 'intl',
      description:
          'Định dạng ngày giờ, số, tiền tệ theo locale (ví dụ "1.000.000 ₫" '
          'ở vi_VN khác "1,000,000" ở en_US), và hỗ trợ đa ngôn ngữ (i18n) '
          'cho app.',
      snippet: '''
final price = NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
    .format(1000000); // "1.000.000 ₫"

final date = DateFormat('dd/MM/yyyy', 'vi_VN').format(DateTime.now());''',
    ),
    _LibraryInfo(
      name: 'cached_network_image',
      category: 'Ảnh / Media',
      pubPackage: 'cached_network_image',
      description:
          'Tải ảnh từ URL kèm cache tự động (lần sau mở lại không tải lại), '
          'có sẵn placeholder lúc đang tải và widget hiển thị khi lỗi - '
          'tiện hơn nhiều so với Image.network thuần.',
      snippet: '''
CachedNetworkImage(
  imageUrl: 'https://example.com/avatar.png',
  placeholder: (c, url) => const CircularProgressIndicator(),
  errorWidget: (c, url, err) => const Icon(Icons.error),
)''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thư viện thường dùng')),
      body: SelectionArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _libraries.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Các package phổ biến ngoài những gì "core" Flutter có '
                  'sẵn. Trang này chỉ giới thiệu + code mẫu tĩnh, CHƯA cài '
                  'vào project này - muốn dùng thật, thêm dependency tương '
                  'ứng vào pubspec.yaml của project bạn.',
                ),
              );
            }
            return _LibraryCard(info: _libraries[index - 1]);
          },
        ),
      ),
    );
  }
}

class _LibraryInfo {
  final String name;
  final String category;
  final String pubPackage;
  final String description;
  final String snippet;

  const _LibraryInfo({
    required this.name,
    required this.category,
    required this.pubPackage,
    required this.description,
    required this.snippet,
  });
}

class _LibraryCard extends StatelessWidget {
  final _LibraryInfo info;

  const _LibraryCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    info.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    info.category,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'pub.dev/packages/${info.pubPackage}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(info.description),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
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
