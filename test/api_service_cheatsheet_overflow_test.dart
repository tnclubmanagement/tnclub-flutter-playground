import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_layout_playground/patterns/api_service_cheatsheet.dart';
import 'cheatsheet_test_utils.dart';

void main() {
  testWidgets('ApiServiceCheatsheet renders without overflow on common '
      'sizes and on every category tab', (tester) async {
    for (final size in [
      const Size(1400, 900), // desktop
      const Size(900, 700), // tablet/borderline
      const Size(390, 844), // mobile
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(const MaterialApp(home: ApiServiceCheatsheet()));
      await tester.pumpAndSettle();
      final e0 = tester.takeException();
      if (e0 != null) debugPrint('EXC @ $size tab0: $e0');
      expect(e0, isNull, reason: 'Exception at size $size (tab 0)');

      await tapThroughCategoryNav(
        tester,
        size: size,
        onSelected: (i) async {
          final e = tester.takeException();
          if (e != null) debugPrint('EXC @ $size tab$i: $e');
          expect(e, isNull, reason: 'Exception at size $size (tab $i)');
        },
      );
    }
  });

  testWidgets('GET request demo: tapping "Gọi API" re-triggers the call', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const MaterialApp(home: ApiServiceCheatsheet()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gọi API').first);
    await tester.pump(); // ngay sau tap - đang ở trạng thái loading
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Kết quả:'), findsOneWidget);
  });

  testWidgets('Debounce demo: fewer "API calls" than keystrokes', (
    tester,
  ) async {
    // Surface RẤT cao để ListView.builder build hết mọi item (không cần
    // cuộn) - tránh phải tìm Scrollable đúng tab giữa nhiều TabBarView page.
    await tester.binding.setSurfaceSize(const Size(900, 4000));
    await tester.pumpWidget(const MaterialApp(home: ApiServiceCheatsheet()));
    await tester.pumpAndSettle();

    final field = find.descendant(
      of: find.ancestor(
        of: find.text('Debounce khi gọi API theo mỗi keystroke'),
        matching: find.byType(Card),
      ),
      matching: find.byType(TextField),
    );

    await tester.enterText(field, 'a');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(field, 'ab');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(field, 'abc');
    // Chưa đủ 500ms kể từ lần gõ cuối -> API chưa được gọi lần nào.
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('Số lần gọi API: 0'), findsOneWidget);

    // Đợi hết debounce.
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Số lần gọi API: 1'), findsOneWidget);
    expect(find.textContaining('Số ký tự gõ: 3'), findsOneWidget);
  });
}
