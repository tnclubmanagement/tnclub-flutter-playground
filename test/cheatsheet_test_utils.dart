import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_layout_playground/widgets/cheatsheet_scaffold.dart';

/// Bấm lần lượt qua TẤT CẢ mục nav category dùng chung cho mọi trang cheat
/// sheet (xem `_CategoryNavScaffold` trong cheatsheet_scaffold.dart):
/// - Màn hình rộng (>= [cheatsheetNavWideBreakpoint]): nav là sidebar cố
///   định, bấm thẳng từng mục.
/// - Màn hình hẹp: nav nằm trong Drawer và TỰ ĐÓNG sau khi chọn 1 mục (nội
///   dung bên trong Drawer đã đóng không còn trong widget tree nữa) - phải
///   mở lại Drawer (bấm icon ☰) trước MỖI lần bấm.
///
/// [onSelected] chạy sau mỗi lần bấm (thường để `tester.pumpAndSettle()`
/// rồi `expect(tester.takeException(), isNull)`).
Future<void> tapThroughCategoryNav(
  WidgetTester tester, {
  required Size size,
  required Future<void> Function(int index) onSelected,
}) async {
  final isWide = size.width >= cheatsheetNavWideBreakpoint;

  Finder navTiles() => find.descendant(
    of: find.byKey(cheatsheetCategoryNavKey),
    matching: find.byType(ListTile),
  );

  if (isWide) {
    final tabCount = navTiles().evaluate().length;
    for (var i = 0; i < tabCount; i++) {
      await tester.tap(navTiles().at(i));
      await tester.pumpAndSettle();
      await onSelected(i);
    }
    return;
  }

  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  final tabCount = navTiles().evaluate().length;

  for (var i = 0; i < tabCount; i++) {
    if (i > 0) {
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
    }
    await tester.tap(navTiles().at(i));
    await tester.pumpAndSettle();
    await onSelected(i);
  }
}
