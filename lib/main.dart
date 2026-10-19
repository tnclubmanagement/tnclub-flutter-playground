import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app_constants.dart';
import 'home/home_page.dart';

void main() {
  // Bỏ dấu '#' trong URL web (ví dụ /edgeinsets thay vì /#/edgeinsets) để URL
  // gọn và dễ chia sẻ/deep-link hơn.
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Mỗi demo có 1 "path" riêng (xem LayoutDemo.path) nên URL luôn phản ánh
  // đúng trang đang xem -> F5/refresh hoặc chia sẻ link vẫn mở đúng demo đó,
  // tiện khi cần trỏ vào 1 trang cụ thể để yêu cầu chỉnh sửa.
  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    for (final demo in [
      ...HomePage.demos,
      ...HomePage.examples,
      ...HomePage.patterns,
      ...HomePage.cheatSheets,
      ...HomePage.environmentTools,
    ]) {
      if (demo.path == settings.name) {
        return MaterialPageRoute(settings: settings, builder: demo.builder);
      }
    }
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const HomePage(),
    );
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    // Tím nhạt (lavender) làm màu CHỦ ĐẠO - thay cam đất (terracotta) vì
    // bị chê quá gắt. Primary/secondary/tertiary vẫn suy từ seed này.
    final seeded = ColorScheme.fromSeed(
      seedColor: const Color(0xFF9575CD),
      brightness: brightness,
    );
    // NHƯNG nền/card dùng XÁM TRUNG TÍNH THẬT (không pha màu tím của M3 "surface
    // tint") làm chủ đạo - ép lại các tông surface thay vì để seed chi phối,
    // để nền luôn xám sạch, chỉ có card/button mới có màu.
    final neutralBg = isLight
        ? const Color(0xFFF2F3F5)
        : const Color(0xFF17181B);
    final neutralBgLow = isLight
        ? const Color(0xFFF7F8FA)
        : const Color(0xFF1C1D21);
    final neutralCard = isLight ? Colors.white : const Color(0xFF232428);
    final neutralOutline = isLight
        ? const Color(0xFFE3E5E9)
        : const Color(0xFF34363B);
    final colorScheme = seeded.copyWith(
      surface: neutralCard,
      surfaceContainerLowest: neutralBg,
      surfaceContainerLow: neutralBgLow,
      surfaceContainer: neutralBgLow,
      surfaceContainerHigh: neutralCard,
      surfaceContainerHighest: neutralOutline,
      outlineVariant: neutralOutline,
    );
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        labelStyle: TextStyle(
          color: colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        shape: const StadiumBorder(),
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
      // Indicator dạng "pill" (bo tròn hết, phủ cả tab) thay vạch kẻ mảnh
      // mặc định - đồng bộ với tinh thần "bento block" bo góc lớn.
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.onPrimary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
      // Button bo góc lớn (14px, không còn pill mảnh/vuông mặc định) +
      // chữ đậm - khớp với card bo 16-20px đã đổi ở trang chủ.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      // Input/search field bo tròn pill, nền tint nhẹ thay viền mỏng xám
      // mặc định - đồng bộ với ô tìm kiếm ở sidebar.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary.withValues(alpha: 0.5)
              : null,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : null,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: const TextTheme().apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Flutter Beginner Journey',
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: mode,
          initialRoute: '/',
          onGenerateRoute: _onGenerateRoute,
          // Giới hạn chiều rộng TOÀN BỘ app (mọi trang/Scaffold) tại 1 CHỖ
          // DUY NHẤT ở đây - thay vì phải tự thêm ConstrainedBox vào từng
          // trang. `child` ở đây là cả Navigator (nội dung trang hiện tại).
          builder: (context, child) {
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
