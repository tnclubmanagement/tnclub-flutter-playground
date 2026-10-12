import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_layout_playground/main.dart';

void main() {
  tearDown(() => themeModeNotifier.value = ThemeMode.light);

  testWidgets('Dark mode toggle in sidebar header actually switches ThemeMode', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(themeModeNotifier.value, ThemeMode.light);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(themeModeNotifier.value, ThemeMode.dark);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    // Theme.of thực sự đổi brightness (không chỉ icon đổi hình).
    final context = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(context).brightness, Brightness.dark);
  });

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

  testWidgets('Folding a section hides its items and does not shift the '
      'index used to navigate other sections', (tester) async {
    // Sidebar (NavigationDrawer) dùng ListView nội bộ - CŨNG lazy-build
    // theo viewport giống ListView.builder (không build hết ngay dù dùng
    // constructor `children:`) - dùng chiều cao RẤT lớn để toàn bộ mục
    // trong sidebar được build, khỏi phải tự cuộn trong test.
    await tester.binding.setSurfaceSize(const Size(1400, 3000));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Fold "Demos" (section đầu tiên) bằng cách bấm vào label của nó.
    await tester.tap(find.text('DEMOS'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // Item của Demos không còn hiện trong sidebar (NavigationDrawer) nữa.
    expect(
      find.descendant(of: find.byType(NavigationDrawer), matching: find.text('Row & Column')),
      findsNothing,
    );

    // Bấm 1 item ở section SAU "Demos" (Patterns) - nếu mapping index vẫn
    // đúng sau khi fold, phải điều hướng tới ĐÚNG trang Constructors pattern.
    await tester.tap(
      find.descendant(of: find.byType(NavigationDrawer), matching: find.text('Named & Factory constructor')),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Pattern: Constructors'), findsOneWidget);
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
