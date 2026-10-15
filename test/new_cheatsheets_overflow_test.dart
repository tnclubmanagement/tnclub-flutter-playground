import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_layout_playground/patterns/dart_tooling_cheatsheet.dart';
import 'package:flutter_layout_playground/patterns/dev_environment_cheatsheet.dart';
import 'package:flutter_layout_playground/patterns/error_handling_cheatsheet.dart';
import 'package:flutter_layout_playground/patterns/i18n_cheatsheet.dart';
import 'package:flutter_layout_playground/patterns/local_storage_cheatsheet.dart';
import 'package:flutter_layout_playground/patterns/navigation_cheatsheet.dart';
import 'package:flutter_layout_playground/patterns/performance_cheatsheet.dart';
import 'package:flutter_layout_playground/patterns/state_management_cheatsheet.dart';
import 'package:flutter_layout_playground/patterns/testing_cheatsheet.dart';
import 'package:flutter_layout_playground/patterns/theme_cheatsheet.dart';
import 'cheatsheet_test_utils.dart';

/// Test CHUNG cho các cheat sheet dùng [CheatsheetScaffold] - 1 file loop
/// qua tất cả thay vì 1 file riêng gần như giống nhau cho mỗi trang, để dễ
/// maintain hơn (đúng tinh thần "dùng chung template" đã áp dụng cho các
/// trang này).
void main() {
  final pages = <String, WidgetBuilder>{
    'StateManagementCheatsheet': (_) => const StateManagementCheatsheet(),
    'NavigationCheatsheet': (_) => const NavigationCheatsheet(),
    'LocalStorageCheatsheet': (_) => const LocalStorageCheatsheet(),
    'TestingCheatsheet': (_) => const TestingCheatsheet(),
    'PerformanceCheatsheet': (_) => const PerformanceCheatsheet(),
    'ThemeCheatsheet': (_) => const ThemeCheatsheet(),
    'I18nCheatsheet': (_) => const I18nCheatsheet(),
    'ErrorHandlingCheatsheet': (_) => const ErrorHandlingCheatsheet(),
    'DevEnvironmentCheatsheet': (_) => const DevEnvironmentCheatsheet(),
    'DartToolingCheatsheet': (_) => const DartToolingCheatsheet(),
  };

  for (final entry in pages.entries) {
    testWidgets(
      '${entry.key} renders without overflow on common sizes and on '
      'every category tab',
      (tester) async {
        for (final size in [
          const Size(1400, 900), // desktop
          const Size(900, 700), // tablet/borderline
          const Size(390, 844), // mobile
        ]) {
          await tester.binding.setSurfaceSize(size);
          await tester.pumpWidget(MaterialApp(home: Builder(builder: entry.value)));
          await tester.pumpAndSettle();
          final e0 = tester.takeException();
          if (e0 != null) debugPrint('${entry.key} EXC @ $size tab0: $e0');
          expect(e0, isNull, reason: '${entry.key} exception at size $size (tab 0)');

          await tapThroughCategoryNav(
            tester,
            size: size,
            onSelected: (i) async {
              final e = tester.takeException();
              if (e != null) debugPrint('${entry.key} EXC @ $size tab$i: $e');
              expect(e, isNull, reason: '${entry.key} exception at size $size (tab $i)');
            },
          );
        }
      },
    );
  }
}
