import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_layout_playground/main.dart';

void main() {
  testWidgets('HomePage renders without overflow on wide and narrow sizes', (
    tester,
  ) async {
    for (final size in [
      const Size(1400, 900), // desktop - sidebar cố định
      const Size(390, 844), // mobile - sidebar gấp vào Drawer
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Exception at size $size');
    }
  });

  testWidgets('Search box filters sections down to matching pages only', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Trước khi lọc: thấy cả "Row & Column" (Demos) và "Animation cheat
    // sheet" (Cheat Sheet) cùng lúc trong vùng nội dung chính.
    expect(find.text('Row & Column'), findsWidgets);
    expect(find.textContaining('Animation cheat sheet'), findsWidgets);

    await tester.enterText(find.byType(TextField).first, 'animation');
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // Sau khi lọc "animation": "Row & Column" KHÔNG còn hiện ở vùng nội
    // dung chính (section Demos tự ẩn vì rỗng kết quả).
    expect(find.text('Row & Column'), findsNothing);
    expect(find.textContaining('Animation cheat sheet'), findsWidgets);
  });

  testWidgets('Tapping a tag chip filters to only pages with that tag', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // "i18n" giờ cũng hiện như tag chip màu trên từng card (không chỉ
    // FilterChip ở sidebar) - chỉ nhắm đúng FilterChip để bấm.
    await tester.tap(
      find.descendant(of: find.byType(FilterChip), matching: find.text('i18n')),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Row & Column'), findsNothing);
    expect(find.textContaining('i18n'), findsWidgets);
  });

  testWidgets('Narrow screen hides the inline sidebar and uses a Drawer '
      'instead', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Sidebar không hiện inline (TextField tìm kiếm nằm trong Drawer,
    // chưa mở nên chưa có trong tree).
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsOneWidget);
  });
}
