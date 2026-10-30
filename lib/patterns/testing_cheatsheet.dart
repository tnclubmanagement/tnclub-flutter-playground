import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về viết TEST cho Flutter (`flutter_test`) - dựa trên chính
/// các kỹ thuật đã dùng để viết test cho CÁC CHEAT SHEET khác trong app
/// này (xem thư mục `test/` của project, vd
/// `test/widgets_cheatsheet_overflow_test.dart`).
///
/// `flutter_test` là package CHO MÔI TRƯỜNG TEST, không import được trong
/// code app thật - nên preview bên dưới chỉ MÔ PHỎNG lại hành vi bằng
/// widget thường để thấy trực quan, code mẫu là code test THẬT.
class TestingCheatsheet extends StatelessWidget {
  const TestingCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'testWidgets + pumpWidget cơ bản',
      category: 'Widget test',
      description:
          '`testWidgets` là "test" dành riêng cho widget (khác `test` '
          'thường chỉ test hàm/logic Dart thuần). `tester.pumpWidget` '
          'render widget vào 1 môi trường giả lập, `expect` kiểm tra kết '
          'quả hiển thị đúng chưa.',
      snippet: '''
testWidgets('Counter hiển thị đúng số ban đầu', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: Counter()));

  expect(find.text('0'), findsOneWidget); // ban đầu phải là "0"
});''',
      preview: (_) => const _PumpWidgetDemo(),
    ),
    CheatsheetEntry(
      name: 'find.text/find.byType + tester.tap',
      category: 'Tìm & tương tác trong test',
      description:
          '`find.text`/`find.byType`/`find.byIcon` TÌM widget trong tree '
          'giả lập (giống querySelector trên web). `tester.tap` giả lập '
          'bấm vào widget đó, PHẢI `await tester.pump()` sau đó để '
          'Flutter build lại frame mới rồi mới `expect` kết quả.',
      snippet: '''
testWidgets('Bấm nút +1 làm số tăng lên', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: Counter()));

  await tester.tap(find.byIcon(Icons.add)); // bấm nút
  await tester.pump(); // build lại frame SAU khi bấm

  expect(find.text('1'), findsOneWidget); // đã tăng lên 1
});''',
      preview: (_) => const _FindAndTapDemo(),
    ),
    CheatsheetEntry(
      name: 'Bắt lỗi RenderFlex overflow trong test',
      category: 'Overflow & exception',
      description:
          '`tester.takeException()` lấy ra lỗi đã xảy ra trong lúc build '
          '(vd overflow, setState sau dispose...) - `expect(..., isNull)` '
          'để chắc chắn KHÔNG có lỗi nào. Đây CHÍNH LÀ kỹ thuật dùng '
          'trong `test/widgets_cheatsheet_overflow_test.dart` của app này '
          'để bắt lỗi layout trước khi bạn kịp thấy bằng mắt.',
      snippet: '''
testWidgets('Trang không bị overflow ở màn hình hẹp', (tester) async {
  await tester.binding.setSurfaceSize(const Size(390, 844)); // giả lập mobile
  await tester.pumpWidget(const MaterialApp(home: MyPage()));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull); // không có RenderFlex overflow
});''',
      preview: (_) => const _OverflowCatchDemo(),
    ),
    CheatsheetEntry(
      name: 'pump() vs pumpAndSettle()',
      category: 'Overflow & exception',
      description:
          '`pump()` chỉ build ĐÚNG 1 frame (dùng khi cần kiểm tra trạng '
          'thái GIỮA 1 animation/delay, vd đang loading). `pumpAndSettle()` '
          'build LIÊN TỤC tới khi không còn frame nào đang chờ (animation '
          'xong, Future xong) - tiện nhưng sẽ TREO VÔ HẠN nếu có '
          'animation lặp vô thời hạn (`repeat()`) chưa dừng.',
      snippet: '''
await tester.tap(find.text('Gọi API'));
await tester.pump(); // chỉ 1 frame - đúng lúc đang hiện CircularProgressIndicator
expect(find.byType(CircularProgressIndicator), findsOneWidget);

await tester.pumpAndSettle(); // đợi tới khi Future xong hẳn
expect(find.text('Đã xong!'), findsOneWidget);''',
      preview: (_) => const _PumpVsSettleDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'Testing cheat sheet',
      intro:
          'flutter_test chỉ dùng được trong môi trường test, không import '
          'được trong code app - preview bên dưới mô phỏng lại hành vi '
          'bằng widget thường để dễ hình dung, code mẫu là code test thật '
          'giống hệt các file trong test/ của app này.',
      items: _items,
    );
  }
}

class _MiniCounter extends StatefulWidget {
  const _MiniCounter();

  @override
  State<_MiniCounter> createState() => _MiniCounterState();
}

class _MiniCounterState extends State<_MiniCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$_count',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => setState(() => _count++),
          icon: const Icon(Icons.add, size: 16),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ],
    );
  }
}

class _PumpWidgetDemo extends StatelessWidget {
  const _PumpWidgetDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _MiniCounter(),
        CheatsheetHint("find.text('0') tìm thấy ngay khi vừa pumpWidget"),
      ],
    );
  }
}

class _FindAndTapDemo extends StatelessWidget {
  const _FindAndTapDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _MiniCounter(),
        CheatsheetHint('Bấm (+) = tester.tap(find.byIcon(Icons.add)) + pump()'),
      ],
    );
  }
}

class _OverflowCatchDemo extends StatefulWidget {
  const _OverflowCatchDemo();

  @override
  State<_OverflowCatchDemo> createState() => _OverflowCatchDemoState();
}

class _OverflowCatchDemoState extends State<_OverflowCatchDemo> {
  bool _tooNarrow = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 140,
          height: 30,
          child: _tooNarrow
              ? Container(
                  color: Colors.red.shade100,
                  alignment: Alignment.center,
                  child: const Text(
                    '⚠ RenderFlex overflowed',
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
                )
              : Container(
                  color: Colors.green.shade100,
                  alignment: Alignment.center,
                  child: const Text(
                    '✓ takeException() == null',
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                ),
        ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: () => setState(() => _tooNarrow = !_tooNarrow),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
          child: Text(
            _tooNarrow ? 'Thu hẹp màn hình lại' : 'Giả lập màn hình quá hẹp',
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _PumpVsSettleDemo extends StatefulWidget {
  const _PumpVsSettleDemo();

  @override
  State<_PumpVsSettleDemo> createState() => _PumpVsSettleDemoState();
}

class _PumpVsSettleDemoState extends State<_PumpVsSettleDemo> {
  bool _loading = false;
  bool _done = false;

  Future<void> _run() async {
    setState(() {
      _loading = true;
      _done = false;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
          child: _loading
              ? const Text(
                  'pump() thấy: đang loading...',
                  style: TextStyle(fontSize: 11),
                )
              : Text(
                  _done ? 'pumpAndSettle() thấy: Đã xong!' : 'Bấm nút để chạy',
                  style: const TextStyle(fontSize: 11),
                ),
        ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: _run,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
          child: const Text(
            'Gọi API (delay 800ms)',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }
}
