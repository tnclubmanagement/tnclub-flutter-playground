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
      expect(tester.takeException(), isNull, reason: 'Exception at size $size (tab 0)');

      final tabs = find.byType(Tab);
      final tabCount = tabs.evaluate().length;
      for (var i = 0; i < tabCount; i++) {
        await tester.tap(tabs.at(i));
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'Exception at size $size (tab $i)',
        );
      }
    }
  });
}
