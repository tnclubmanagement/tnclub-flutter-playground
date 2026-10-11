import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_layout_playground/patterns/auth_cheatsheet.dart';

void main() {
  testWidgets('AuthCheatsheet renders without overflow on common sizes '
      'and on every category tab', (tester) async {
    for (final size in [
      const Size(1400, 900), // desktop
      const Size(900, 700), // tablet/borderline
      const Size(390, 844), // mobile
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(const MaterialApp(home: AuthCheatsheet()));
      await tester.pumpAndSettle();
      final e0 = tester.takeException();
      if (e0 != null) debugPrint('EXC @ $size tab0: $e0');
      expect(e0, isNull, reason: 'Exception at size $size (tab 0)');

      final tabs = find.byType(Tab);
      final tabCount = tabs.evaluate().length;
      for (var i = 0; i < tabCount; i++) {
        await tester.tap(tabs.at(i));
        await tester.pumpAndSettle();
        final e = tester.takeException();
        if (e != null) debugPrint('EXC @ $size tab$i: $e');
        expect(e, isNull, reason: 'Exception at size $size (tab $i)');
      }
    }
  });

  testWidgets('Secure storage demo: write / read / delete update status '
      'text', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const MaterialApp(home: AuthCheatsheet()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lưu token'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Đã lưu'), findsOneWidget);

    await tester.tap(find.text('Đọc token'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Đọc được'), findsOneWidget);

    await tester.tap(find.text('Xoá token'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Đã xoá token'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Password strength demo: stronger password -> higher score', (
    tester,
  ) async {
    // Surface rất cao để ListView.builder build hết item, không cần cuộn.
    await tester.binding.setSurfaceSize(const Size(900, 4000));
    await tester.pumpWidget(const MaterialApp(home: AuthCheatsheet()));
    await tester.pumpAndSettle();

    final field = find.descendant(
      of: find.ancestor(
        of: find.text('Kiểm tra độ mạnh mật khẩu khi nhập'),
        matching: find.byType(Card),
      ),
      matching: find.byType(TextField),
    );

    await tester.enterText(field, 'abc');
    await tester.pumpAndSettle();
    expect(find.text('Rất yếu'), findsOneWidget);

    await tester.enterText(field, 'Abcdef1!');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Mạnh'), findsOneWidget);
  });
}
