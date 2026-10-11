import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_layout_playground/patterns/widgets_cheatsheet.dart';

void main() {
  testWidgets('WidgetsCheatsheet renders without overflow on common sizes '
      'and on every category tab', (tester) async {
    for (final size in [
      const Size(1400, 900), // desktop
      const Size(900, 700), // tablet/borderline
      const Size(390, 844), // mobile
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        const MaterialApp(home: WidgetsCheatsheet()),
      );
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
        expect(
          e,
          isNull,
          reason: 'Exception at size $size (tab $i)',
        );
      }
    }
  });

  testWidgets('Tapping a constructor cell opens a code dialog', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const MaterialApp(home: WidgetsCheatsheet()));
    await tester.pumpAndSettle();

    // Tap the first "Container" row's monospace constructor cell (InkWell).
    final codeCell = find.byTooltip('Bấm để xem code mẫu').first;
    await tester.tap(codeCell);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Container'), findsWidgets);

    // Close it via the "Đóng" button.
    await tester.tap(find.byTooltip('Đóng'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });
}
