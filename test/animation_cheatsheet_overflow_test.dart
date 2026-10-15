import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_layout_playground/patterns/animation_cheatsheet.dart';
import 'package:flutter_layout_playground/widgets/cheatsheet_scaffold.dart';
import 'cheatsheet_test_utils.dart';

void main() {
  testWidgets('AnimationCheatsheet renders without overflow on common '
      'sizes and on every category tab', (tester) async {
    for (final size in [
      const Size(1400, 900), // desktop
      const Size(900, 700), // tablet/borderline
      const Size(390, 844), // mobile
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(const MaterialApp(home: AnimationCheatsheet()));
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

  testWidgets('Tapping a live demo actually triggers its animation', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const MaterialApp(home: AnimationCheatsheet()));
    await tester.pumpAndSettle();

    // AnimatedContainer demo: tap toggles size; find the AnimatedContainer
    // and confirm its target width actually changes after the tap.
    final containerFinder = find.byType(AnimatedContainer).first;
    final before = tester.widget<AnimatedContainer>(containerFinder);
    final beforeWidth = before.constraints?.maxWidth;

    await tester.tap(containerFinder);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final after = tester.widget<AnimatedContainer>(containerFinder);
    final afterWidth = after.constraints?.maxWidth;
    expect(afterWidth, isNot(equals(beforeWidth)));
  });

  testWidgets(
    'List key demo: without key the star leaks to the wrong row after '
    'removal; with key it does not',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 900));
      await tester.pumpWidget(const MaterialApp(home: AnimationCheatsheet()));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byKey(cheatsheetCategoryNavKey),
          matching:
              find.widgetWithText(ListTile, 'Danh sách (List) mượt & đúng state'),
        ),
      );
      await tester.pumpAndSettle();

      Finder iconForRow(String label, IconData icon) {
        final row = find
            .ancestor(of: find.text(label), matching: find.byType(Row))
            .first;
        return find.descendant(of: row, matching: find.byIcon(icon));
      }

      // --- KHÔNG key: star "dính" sang dòng sai sau khi xoá dòng A ---
      await tester.tap(find.byIcon(Icons.star_border).first); // đánh dấu "Dòng A"
      await tester.pumpAndSettle();
      expect(iconForRow('Dòng A', Icons.star), findsOneWidget);

      await tester.tap(find.text('Xoá dòng đầu'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // BUG: "Dòng B" (giờ ở vị trí 0) lại hiện star dù chưa từng được tick.
      expect(iconForRow('Dòng B', Icons.star), findsOneWidget);

      // Bật key rồi lặp lại đúng thao tác đó.
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.star_border).first); // đánh dấu "Dòng A"
      await tester.pumpAndSettle();
      expect(iconForRow('Dòng A', Icons.star), findsOneWidget);

      await tester.tap(find.text('Xoá dòng đầu'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // ĐÚNG: "Dòng B" không bị dính star của "Dòng A" (đã bị xoá cùng A).
      expect(iconForRow('Dòng B', Icons.star_border), findsOneWidget);
    },
  );

  testWidgets('AnimatedList demo: insert/remove run without exceptions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const MaterialApp(home: AnimationCheatsheet()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byKey(cheatsheetCategoryNavKey),
        matching:
            find.widgetWithText(ListTile, 'Danh sách (List) mượt & đúng state'),
      ),
    );
    await tester.pumpAndSettle();

    final addButton = find.text('+ Thêm');
    final removeButton = find.text('- Xoá');

    // Card nằm cuối ListView lazy-build - cuộn tới trước khi tap. TabBarView
    // giữ sẵn cả page kế bên nên có nhiều Scrollable cùng lúc trong tree;
    // định vị đúng Scrollable của tab hiện tại qua 1 Text chỉ xuất hiện ở đó.
    final scrollable = find
        .ancestor(
          of: find.text('Key trong ListView.builder (tránh giật/nhầm state)'),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(addButton, 300, scrollable: scrollable);
    await tester.pumpAndSettle();

    await tester.tap(addButton);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(removeButton);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
