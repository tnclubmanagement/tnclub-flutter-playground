import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_layout_playground/patterns/file_preview_cheatsheet.dart';
import 'cheatsheet_test_utils.dart';

void main() {
  testWidgets('FilePreviewCheatsheet renders without overflow on common '
      'sizes and on every category tab', (tester) async {
    for (final size in [
      const Size(1400, 900), // desktop
      const Size(900, 700), // tablet/borderline
      const Size(390, 844), // mobile
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(const MaterialApp(home: FilePreviewCheatsheet()));
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

  testWidgets('Hero preview demo: tapping the thumbnail opens and closes '
      'a dialog', (tester) async {
    // Surface rất cao để ListView.builder build hết item (card này là item
    // thứ 2 trong tab "Tất cả") mà không cần cuộn tới.
    await tester.binding.setSurfaceSize(const Size(900, 4000));
    await tester.pumpWidget(const MaterialApp(home: FilePreviewCheatsheet()));
    await tester.pumpAndSettle();

    final thumbnail = find.descendant(
      of: find.ancestor(
        of: find.text('Hero + InteractiveViewer cho xem ảnh full-screen'),
        matching: find.byType(Card),
      ),
      matching: find.byIcon(Icons.landscape),
    );
    await tester.tap(thumbnail);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(Dialog), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('PDF viewer demo: next/prev buttons change the page number', (
    tester,
  ) async {
    // Surface rất cao để ListView.builder build hết item, không cần cuộn.
    await tester.binding.setSurfaceSize(const Size(900, 4000));
    await tester.pumpWidget(const MaterialApp(home: FilePreviewCheatsheet()));
    await tester.pumpAndSettle();

    expect(find.text('Trang 1/5'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Trang 2/5'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text('Trang 1/5'), findsOneWidget);
  });
}
