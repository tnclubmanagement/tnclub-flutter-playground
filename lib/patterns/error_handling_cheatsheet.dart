import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về XỬ LÝ LỖI & báo lỗi lên server: try/catch cơ bản,
/// `FlutterError.onError` (bắt lỗi UI để không crash cả app),
/// `runZonedGuarded` (bắt lỗi async NGOÀI Flutter framework), và gửi lỗi
/// lên dịch vụ crash reporting.
class ErrorHandlingCheatsheet extends StatelessWidget {
  const ErrorHandlingCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'try/catch quanh code có thể lỗi',
      category: 'try/catch trong Flutter',
      description:
          'Bọc code có khả năng lỗi (parse JSON sai định dạng, chia cho '
          '0, gọi API...) trong `try/catch` để app không crash TOÀN BỘ '
          'vì 1 lỗi nhỏ - hiện thông báo thân thiện cho người dùng thay '
          'vì "màn hình đỏ" (red screen of death).',
      snippet: '''
Future<void> loadUser() async {
  try {
    final user = await fetchUser(1);
    setState(() => _user = user);
  } catch (e) {
    setState(() => _error = 'Không tải được: \$e'); // báo lỗi thân thiện
  }
}''',
      preview: (_) => const _TryCatchDemo(),
    ),
    CheatsheetEntry(
      name: 'FlutterError.onError - bắt lỗi UI, không crash cả app',
      category: 'Bắt lỗi toàn app',
      description:
          'Lỗi xảy ra TRONG LÚC build/layout/paint (vd null check sai, '
          'RenderFlex overflow) được Flutter gom qua `FlutterError.onError` '
          '- mặc định chỉ IN RA CONSOLE (ở debug mode còn vẽ banner đỏ) '
          'nhưng KHÔNG tự crash app. Override hàm này để thay thế bằng '
          'gửi lỗi lên crash reporting ở bản RELEASE (người dùng thật '
          'không thấy banner đỏ debug).',
      snippet: '''
void main() {
  FlutterError.onError = (details) {
    // Mặc định: FlutterError.presentError(details) - in console/banner đỏ.
    // Thay bằng gửi lên crash reporting ở bản release:
    crashReportingService.recordFlutterError(details);
  };
  runApp(const MyApp());
}''',
      preview: (_) => const _FlutterErrorDemo(),
    ),
    CheatsheetEntry(
      name: 'runZonedGuarded - bắt lỗi async NGOÀI Flutter',
      category: 'Bắt lỗi toàn app',
      description:
          '`FlutterError.onError` CHỈ bắt lỗi trong vòng đời widget '
          '(build/layout/paint) - lỗi ném ra từ 1 `Future`/`Timer` KHÔNG '
          'ai `await`/`catch` (vd quên `await`, lỗi trong `Timer.periodic`) '
          'sẽ KHÔNG đi qua đó. `runZonedGuarded` bọc TOÀN BỘ app trong 1 '
          '"zone" riêng để bắt được cả loại lỗi async "mồ côi" này.',
      snippet: '''
void main() {
  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stackTrace) {
      // Bắt được cả lỗi async không ai await/catch
      crashReportingService.recordError(error, stackTrace);
    },
  );
}''',
      preview: (_) => const _RunZonedGuardedDemo(),
    ),
    CheatsheetEntry(
      name: 'Gửi lỗi lên Sentry/Firebase Crashlytics',
      category: 'Crash reporting',
      description:
          'Kết hợp `FlutterError.onError` + `runZonedGuarded` ở trên, '
          'gửi lỗi lên 1 dịch vụ crash reporting (Sentry hoặc Firebase '
          'Crashlytics là 2 lựa chọn phổ biến nhất) để biết NGƯỜI DÙNG '
          'THẬT gặp lỗi gì mà bạn không tự thấy được (khác với chỉ xem '
          'log lúc đang dev).',
      snippet: '''
// Firebase Crashlytics
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
PlatformDispatcher.instance.onError = (error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  return true;
};

// Sentry (cách gọn hơn - 1 hàm bọc sẵn mọi thứ ở trên)
await SentryFlutter.init(
  (options) => options.dsn = 'https://...',
  appRunner: () => runApp(const MyApp()),
);''',
      preview: (_) => const _CrashReportingDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'Error handling & Crash reporting cheat sheet',
      intro:
          'try/catch chạy thật trong preview. FlutterError.onError/'
          'runZonedGuarded chỉ set được 1 lần ở main() nên không thể demo '
          'sống trong 1 cheat sheet card - preview mô phỏng lại luồng xử '
          'lý. Sentry/Crashlytics không có trong app demo này.',
      items: _items,
    );
  }
}

class _TryCatchDemo extends StatefulWidget {
  const _TryCatchDemo();

  @override
  State<_TryCatchDemo> createState() => _TryCatchDemoState();
}

class _TryCatchDemoState extends State<_TryCatchDemo> {
  String _status = 'Chưa chạy';

  Future<void> _load({required bool crash}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      if (crash) throw Exception('Server trả lỗi 500 (giả lập)');
      setState(() => _status = '✅ Tải dữ liệu thành công');
    } catch (e) {
      setState(() => _status = '⚠️ Đã bắt lỗi, app không crash: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_status, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => _load(crash: false),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('Gọi API OK', style: TextStyle(fontSize: 11)),
            ),
            OutlinedButton(
              onPressed: () => _load(crash: true),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('Gọi API lỗi', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }
}

class _FlowDiagram extends StatelessWidget {
  final List<String> steps;
  final List<Color> colors;

  const _FlowDiagram({required this.steps, required this.colors});

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
            decoration: BoxDecoration(color: colors[i], borderRadius: BorderRadius.circular(6)),
            child: Text(steps[i], style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          if (i != steps.length - 1)
            Icon(Icons.arrow_forward, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ],
      ],
    );
  }
}

class _FlutterErrorDemo extends StatelessWidget {
  const _FlutterErrorDemo();

  @override
  Widget build(BuildContext context) {
    return const _FlowDiagram(
      steps: ['Lỗi build/layout', 'FlutterError.onError', 'Crash reporting (release)'],
      colors: [Colors.red, Colors.orange, Colors.teal],
    );
  }
}

class _RunZonedGuardedDemo extends StatelessWidget {
  const _RunZonedGuardedDemo();

  @override
  Widget build(BuildContext context) {
    return const _FlowDiagram(
      steps: ['Lỗi trong Future/Timer', 'Zone bắt được', 'Crash reporting'],
      colors: [Colors.red, Colors.indigo, Colors.teal],
    );
  }
}

class _CrashReportingDemo extends StatelessWidget {
  const _CrashReportingDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        const Text('Lỗi người dùng thật gặp -> gửi lên server -> bạn xem dashboard', style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
      ],
    );
  }
}
