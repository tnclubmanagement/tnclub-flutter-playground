import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'demos/column_row_demo.dart';
import 'demos/container_constraints_demo.dart';
import 'demos/edgeinsets_demo.dart';
import 'demos/expanded_flexible_demo.dart';
import 'demos/gridview_demo.dart';
import 'demos/listview_demo.dart';
import 'demos/stack_demo.dart';
import 'demos/wrap_demo.dart';
import 'examples/chat_bubble_example.dart';
import 'examples/chat_bubble_starter.dart';
import 'examples/dashboard_stats_example.dart';
import 'examples/dashboard_stats_starter.dart';
import 'examples/login_form_example.dart';
import 'examples/login_form_starter.dart';
import 'examples/product_grid_example.dart';
import 'examples/product_grid_starter.dart';
import 'examples/profile_card_example.dart';
import 'examples/profile_card_starter.dart';
import 'patterns/animation_cheatsheet.dart';
import 'patterns/api_service_cheatsheet.dart';
import 'patterns/atomic_widgets_cheatsheet.dart';
import 'patterns/auth_cheatsheet.dart';
import 'patterns/constructors_pattern.dart';
import 'patterns/dart_syntax_cheatsheet.dart';
import 'patterns/dart_tooling_cheatsheet.dart';
import 'patterns/dev_environment_cheatsheet.dart';
import 'patterns/error_handling_cheatsheet.dart';
import 'patterns/extension_pattern.dart';
import 'patterns/file_preview_cheatsheet.dart';
import 'patterns/i18n_cheatsheet.dart';
import 'patterns/inherited_widget_pattern.dart';
import 'patterns/libraries_page.dart';
import 'patterns/local_storage_cheatsheet.dart';
import 'patterns/navigation_cheatsheet.dart';
import 'patterns/performance_cheatsheet.dart';
import 'patterns/state_management_cheatsheet.dart';
import 'patterns/testing_cheatsheet.dart';
import 'patterns/theme_cheatsheet.dart';
import 'patterns/value_notifier_pattern.dart';
import 'patterns/widgets_cheatsheet.dart';
import 'widgets/demo_scaffold.dart';
import 'widgets/example_scaffold.dart';

/// Chế độ sáng/tối hiện tại - để TOÀN CỤC (đổi ở đâu cũng áp dụng ngay cho
/// cả app, xem [ThemeCheatsheet] cho pattern giải thích chi tiết). Dùng
/// `ValueNotifier` + `ValueListenableBuilder` thay vì setState thủ công -
/// đúng pattern đã dạy ở mục Pattern/ValueNotifier của app này.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

/// Mỗi nhóm lớn trên trang chủ (Demos/Examples/Patterns/Cheat Sheet) có 1
/// màu "thương hiệu" RIÊNG (không suy ra từ seed color chung) - dùng cho
/// icon section, nền card kiểu "bento block", và viền/bóng khi hover - để
/// mỗi khu vực có cá tính thị giác rõ ràng. Theo đúng bảng màu tham khảo
/// (lavender/cam đất/xám/vàng) - ô "hồng" trong ảnh gốc đổi thành cam đất.
const Map<String, Color> kSectionAccent = {
  'Demos': Color(0xFF7C6FE0), // tím lavender
  'Examples': Color(0xFFC1623D), // cam đất (terracotta) - thay cho hồng
  'Patterns': Color(0xFF64748B), // xám đậm
  'Cheat Sheet': Color(0xFFD4A017), // vàng gold
};

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
    ]) {
      if (demo.path == settings.name) {
        return MaterialPageRoute(settings: settings, builder: demo.builder);
      }
    }
    return MaterialPageRoute(settings: settings, builder: (_) => const HomePage());
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      // Cam đất (terracotta) làm màu CHỦ ĐẠO của app - thay cho tím/indigo
      // trước đó - theo đúng bảng màu tham khảo người dùng đưa ra.
      seedColor: const Color(0xFFC1623D),
      brightness: brightness,
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
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
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
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        dividerColor: colorScheme.outlineVariant,
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
          title: 'Flutter Layout Playground',
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

class LayoutDemo {
  final String title;
  final String description;
  final String path;
  final WidgetBuilder builder;
  // Chỉ dùng cho mục Cheat Sheet - gom các trang liên quan vào 1 nhóm nhỏ
  // (hiện tiêu đề phụ trên trang chủ) vì danh sách cheat sheet đã khá dài.
  final String? group;
  // Dùng cho search/filter ở sidebar trang chủ - mỗi trang gắn 1-3 tag
  // ngắn, KHÔNG phân biệt hoa/thường khi so khớp (xem _matchesQuery).
  final List<String> tags;

  const LayoutDemo({
    required this.title,
    required this.description,
    required this.path,
    required this.builder,
    this.group,
    this.tags = const [],
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final List<LayoutDemo> demos = [
    LayoutDemo(
      title: 'Row & Column',
      description: 'Sắp xếp widget theo trục ngang/dọc, mainAxisAlignment, crossAxisAlignment',
      path: '/row-column',
      tags: const ['layout', 'widget'],
      builder: (_) => const DemoScaffold(
        title: 'Row & Column',
        assetPath: 'lib/demos/column_row_demo.dart',
        bodyBuilder: _buildColumnRowDemo,
      ),
    ),
    LayoutDemo(
      title: 'Expanded & Flexible',
      description: 'Chia không gian còn lại giữa các children trong Row/Column',
      path: '/expanded-flexible',
      tags: const ['layout', 'widget'],
      builder: (_) => const DemoScaffold(
        title: 'Expanded & Flexible',
        assetPath: 'lib/demos/expanded_flexible_demo.dart',
        bodyBuilder: _buildExpandedFlexibleDemo,
      ),
    ),
    LayoutDemo(
      title: 'Stack & Positioned',
      description: 'Chồng widget lên nhau, định vị bằng Positioned/Align',
      path: '/stack',
      tags: const ['layout', 'widget'],
      builder: (_) => const DemoScaffold(
        title: 'Stack & Positioned',
        assetPath: 'lib/demos/stack_demo.dart',
        bodyBuilder: _buildStackDemo,
      ),
    ),
    LayoutDemo(
      title: 'Container & Constraints',
      description: 'Padding, margin, BoxConstraints và cách constraints truyền xuống children',
      path: '/container-constraints',
      tags: const ['layout', 'widget'],
      builder: (_) => const DemoScaffold(
        title: 'Container & Constraints',
        assetPath: 'lib/demos/container_constraints_demo.dart',
        bodyBuilder: _buildContainerConstraintsDemo,
      ),
    ),
    LayoutDemo(
      title: 'ListView',
      description: 'Danh sách cuộn được: builder, separated, horizontal',
      path: '/listview',
      tags: const ['layout', 'scroll', 'list'],
      builder: (_) => const DemoScaffold(
        title: 'ListView',
        assetPath: 'lib/demos/listview_demo.dart',
        bodyBuilder: _buildListViewDemo,
      ),
    ),
    LayoutDemo(
      title: 'GridView',
      description: 'Lưới item với GridView.count và GridView.builder',
      path: '/gridview',
      tags: const ['layout', 'scroll', 'list'],
      builder: (_) => const DemoScaffold(
        title: 'GridView',
        assetPath: 'lib/demos/gridview_demo.dart',
        bodyBuilder: _buildGridViewDemo,
      ),
    ),
    LayoutDemo(
      title: 'Wrap',
      description: 'Tự động xuống dòng khi hết chỗ, khác với Row',
      path: '/wrap',
      tags: const ['layout', 'widget'],
      builder: (_) => const DemoScaffold(
        title: 'Wrap',
        assetPath: 'lib/demos/wrap_demo.dart',
        bodyBuilder: _buildWrapDemo,
      ),
    ),
    LayoutDemo(
      title: 'EdgeInsets',
      description:
          'Các cách tạo EdgeInsets: all, symmetric, only, fromLTRB, zero, '
          'EdgeInsetsDirectional',
      path: '/edgeinsets',
      tags: const ['layout', 'widget'],
      builder: (_) => const DemoScaffold(
        title: 'EdgeInsets',
        assetPath: 'lib/demos/edgeinsets_demo.dart',
        bodyBuilder: _buildEdgeInsetsDemo,
      ),
    ),
  ];

  // Các "Examples": layout UI thực tế (kết hợp nhiều widget đã học ở phần
  // Demos) kiêm bài tập thử thách - xem lib/widgets/example_scaffold.dart.
  static final List<LayoutDemo> examples = [
    LayoutDemo(
      title: 'Profile Card',
      description: 'Stack (avatar đè lên cover) + Column/Row + Wrap cho stats',
      path: '/examples/profile-card',
      tags: const ['layout', 'widget'],
      builder: (_) => ExampleScaffold(
        title: 'Example: Profile Card',
        task:
            'Dựng 1 thẻ profile gồm: ảnh cover (gradient), avatar tròn đè lên '
            'mép dưới cover, tên + chức danh, 3 chỉ số (bài viết/followers/'
            'following) và 1 nút "Theo dõi" full-width.',
        hints: const [
          'Dùng Stack + Positioned (hoặc Align) để đặt avatar đè lên cover.',
          'CircleAvatar bọc trong Container hình tròn màu trắng để tạo viền.',
          'Row + mainAxisAlignment.spaceAround cho 3 chỉ số.',
        ],
        assetPath: 'lib/examples/profile_card_example.dart',
        bodyBuilder: _buildProfileCardExample,
        answerBuilder: _buildProfileCardAnswer,
      ),
    ),
    LayoutDemo(
      title: 'Login Form',
      description: 'Column các field + Row (Checkbox/Spacer) + Expanded(Divider)',
      path: '/examples/login-form',
      tags: const ['form', 'layout'],
      builder: (_) => ExampleScaffold(
        title: 'Example: Login Form',
        task:
            'Dựng 1 form đăng nhập gồm: tiêu đề, field Email, field Mật khẩu '
            '(có icon ẩn/hiện), dòng "Nhớ tôi" + "Quên mật khẩu?" cùng 1 Row, '
            'nút Đăng nhập, dải phân cách "hoặc", và nút đăng nhập Google.',
        hints: const [
          'Dùng Spacer() trong Row để đẩy "Quên mật khẩu?" sang phải.',
          'Dải phân cách "hoặc": Row gồm Expanded(Divider) - Text - Expanded(Divider).',
          'State _obscurePassword (StatefulWidget) để toggle icon ẩn/hiện mật khẩu.',
        ],
        assetPath: 'lib/examples/login_form_example.dart',
        bodyBuilder: _buildLoginFormExample,
        answerBuilder: _buildLoginFormAnswer,
      ),
    ),
    LayoutDemo(
      title: 'Product Grid',
      description: 'GridView.builder + Expanded trong Column cho ảnh sản phẩm',
      path: '/examples/product-grid',
      tags: const ['layout', 'list', 'scroll'],
      builder: (_) => ExampleScaffold(
        title: 'Example: Product Grid',
        task:
            'Dựng lưới sản phẩm 2 cột, mỗi item gồm: ảnh (placeholder), tên '
            'sản phẩm (1 dòng, ellipsis), rating (icon sao + số) và giá.',
        hints: const [
          'GridView.builder + SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2).',
          'Dùng Expanded bên trong Column của mỗi item cho phần ảnh, phần chữ bên dưới dùng Padding cố định.',
          'overflow: TextOverflow.ellipsis + maxLines: 1 để tên dài không vỡ layout.',
        ],
        assetPath: 'lib/examples/product_grid_example.dart',
        bodyBuilder: _buildProductGridExample,
        answerBuilder: _buildProductGridAnswer,
      ),
    ),
    LayoutDemo(
      title: 'Chat Bubble List',
      description: 'ListView.builder + Row(mainAxisAlignment) + ConstrainedBox',
      path: '/examples/chat-bubble',
      tags: const ['layout', 'list', 'scroll'],
      builder: (_) => ExampleScaffold(
        title: 'Example: Chat Bubble List',
        task:
            'Dựng danh sách chat: tin nhắn của "mình" lệch phải (màu tím), '
            'tin nhắn người khác lệch trái (màu trắng), bong bóng không rộng '
            'quá ~50% màn hình và có góc bo khác nhau để tạo "mỏ" bong bóng.',
        hints: const [
          'Mỗi tin nhắn là 1 Row, dùng mainAxisAlignment.end/start theo người gửi.',
          'ConstrainedBox(maxWidth: ...) để bong bóng không chiếm hết chiều rộng.',
          'BorderRadius.only(...) với 1 góc bo nhỏ hơn để tạo điểm nhấn hướng.',
        ],
        assetPath: 'lib/examples/chat_bubble_example.dart',
        bodyBuilder: _buildChatBubbleExample,
        answerBuilder: _buildChatBubbleAnswer,
      ),
    ),
    LayoutDemo(
      title: 'Dashboard Stats',
      description: 'Wrap cho thẻ thống kê + ListView ngang cho hoạt động gần đây',
      path: '/examples/dashboard-stats',
      tags: const ['layout', 'list', 'scroll'],
      builder: (_) => ExampleScaffold(
        title: 'Example: Dashboard Stats',
        task:
            'Dựng 1 khu vực "Tổng quan" gồm các thẻ thống kê (icon, giá trị, '
            'nhãn) tự xuống dòng khi hẹp, và khu vực "Hoạt động gần đây" là '
            '1 danh sách cuộn ngang các thẻ nhỏ.',
        hints: const [
          'Wrap(spacing, runSpacing) cho các thẻ thống kê thay vì Row để tránh overflow.',
          'ListView.separated(scrollDirection: Axis.horizontal) cho hoạt động gần đây.',
          'Mỗi thẻ hoạt động dùng Row + Expanded(Text(...)) để chữ dài tự ellipsis.',
        ],
        assetPath: 'lib/examples/dashboard_stats_example.dart',
        bodyBuilder: _buildDashboardStatsExample,
        answerBuilder: _buildDashboardStatsAnswer,
      ),
    ),
  ];

  // Các "Patterns": cách tổ chức code/quản lý state hay gặp trong Flutter,
  // mỗi pattern là 1 demo chạy thật kèm source thật (giống Demos), cộng
  // thêm 1 trang giới thiệu tĩnh về các package phổ biến (flutter_hooks...).
  static final List<LayoutDemo> patterns = [
    LayoutDemo(
      title: 'ValueNotifier + ValueListenableBuilder',
      description: 'Quản lý state mà không cần setState() rebuild cả widget',
      path: '/patterns/value-notifier',
      tags: const ['state', 'pattern'],
      builder: (_) => const DemoScaffold(
        title: 'Pattern: ValueNotifier',
        assetPath: 'lib/patterns/value_notifier_pattern.dart',
        bodyBuilder: _buildValueNotifierPattern,
      ),
    ),
    LayoutDemo(
      title: 'InheritedWidget',
      description: 'Chia sẻ dữ liệu xuống widget con sâu nhiều lớp, không cần truyền qua constructor',
      path: '/patterns/inherited-widget',
      tags: const ['state', 'pattern'],
      builder: (_) => const DemoScaffold(
        title: 'Pattern: InheritedWidget',
        assetPath: 'lib/patterns/inherited_widget_pattern.dart',
        bodyBuilder: _buildInheritedWidgetPattern,
      ),
    ),
    LayoutDemo(
      title: 'Named & Factory constructor',
      description: 'Nhiều cách tạo object theo ngữ cảnh, factory tự chọn implementation',
      path: '/patterns/constructors',
      tags: const ['dart', 'pattern'],
      builder: (_) => const DemoScaffold(
        title: 'Pattern: Constructors',
        assetPath: 'lib/patterns/constructors_pattern.dart',
        bodyBuilder: _buildConstructorsPattern,
      ),
    ),
    LayoutDemo(
      title: 'Extension method',
      description: 'Gắn thêm method/getter vào type có sẵn (num, BuildContext...) để code gọn hơn',
      path: '/patterns/extension',
      tags: const ['dart', 'pattern'],
      builder: (_) => const DemoScaffold(
        title: 'Pattern: Extension method',
        assetPath: 'lib/patterns/extension_pattern.dart',
        bodyBuilder: _buildExtensionPattern,
      ),
    ),
    LayoutDemo(
      title: '📚 Thư viện thường dùng',
      description: 'flutter_hooks, provider, riverpod, go_router, dio, freezed... (trang giới thiệu tĩnh)',
      path: '/patterns/libraries',
      tags: const ['tooling', 'pattern'],
      builder: (_) => const LibrariesPage(),
    ),
  ];

  // Các "Cheat Sheet": trang tra cứu nhanh tĩnh (không phải demo chạy thật),
  // tổng hợp sẵn syntax/widget hay dùng kèm ví dụ, để tra lại khi quên.
  // Gom theo `group` vì danh sách đã khá dài - xem _DemoGrid/_SectionHeader
  // ở HomePage.build để biết cách hiện tiêu đề phụ theo nhóm.
  static final List<LayoutDemo> cheatSheets = [
    // ---- Nền tảng (Layout & Dart) ----
    LayoutDemo(
      group: 'Nền tảng (Layout & Dart)',
      title: '🧩 Atomic widgets cheat sheet',
      description:
          'BoxDecoration, BoxShape, BoxShadow, TextStyle, MainAxisAlignment, '
          'Positioned, Clip, padding vs margin... (trang tổng hợp tĩnh)',
      path: '/cheatsheet/atomic-widgets',
      tags: const ['widget', 'layout'],
      builder: (_) => const AtomicWidgetsCheatsheet(),
    ),
    LayoutDemo(
      group: 'Nền tảng (Layout & Dart)',
      title: '📊 Widget cheat sheet',
      description:
          'Bảng tra nhanh: constructor mẫu, dùng để làm gì, có padding/'
          'background/scroll hay gì đặc biệt (trang tổng hợp tĩnh, lọc nhóm)',
      path: '/cheatsheet/widgets',
      tags: const ['widget', 'layout'],
      builder: (_) => const WidgetsCheatsheet(),
    ),
    LayoutDemo(
      group: 'Nền tảng (Layout & Dart)',
      title: '📖 Dart syntax cheat sheet',
      description:
          'Null safety, cascade ".." , spread "...", async/await, pattern '
          'matching, constructor... (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/dart-syntax',
      tags: const ['dart'],
      builder: (_) => const DartSyntaxCheatsheet(),
    ),
    LayoutDemo(
      group: 'Nền tảng (Layout & Dart)',
      title: '🎬 Animation cheat sheet',
      description:
          'Animation ngầm (AnimatedContainer, AnimatedSwitcher...) và '
          'animation rõ ràng (AnimationController, Tween, Hero...) '
          '(trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/animation',
      tags: const ['animation', 'widget'],
      builder: (_) => const AnimationCheatsheet(),
    ),
    // ---- Kiến trúc & State ----
    LayoutDemo(
      group: 'Kiến trúc & State',
      title: '🧠 State Management cheat sheet',
      description:
          'ChangeNotifier chia sẻ state (không cần package), so sánh với '
          'provider/riverpod/bloc (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/state-management',
      tags: const ['state'],
      builder: (_) => const StateManagementCheatsheet(),
    ),
    LayoutDemo(
      group: 'Kiến trúc & State',
      title: '🧭 Navigation & Routing cheat sheet',
      description:
          'Navigator.push/pop, trả dữ liệu khi pop, named routes (chính '
          'app này đang dùng), go_router (trang tổng hợp tĩnh, lọc nhóm)',
      path: '/cheatsheet/navigation',
      tags: const ['navigation'],
      builder: (_) => const NavigationCheatsheet(),
    ),
    LayoutDemo(
      group: 'Kiến trúc & State',
      title: '💾 Local Storage cheat sheet',
      description:
          'shared_preferences, khi nào cần database thật (sqlite/drift/'
          'hive) (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/local-storage',
      tags: const ['storage'],
      builder: (_) => const LocalStorageCheatsheet(),
    ),
    // ---- Networking & Auth ----
    LayoutDemo(
      group: 'Networking & Auth',
      title: '🌐 API & Service cheat sheet',
      description:
          'Gọi HTTP (http/dio), parse JSON -> model, FutureBuilder loading/'
          'error/success, debounce, Repository pattern (trang tổng hợp '
          'tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/api-service',
      tags: const ['network', 'async'],
      builder: (_) => const ApiServiceCheatsheet(),
    ),
    LayoutDemo(
      group: 'Networking & Auth',
      title: '🔐 Login & Credential cheat sheet',
      description:
          'Lưu token an toàn, auth guard tự chuyển hướng, token refresh '
          'tự động, logout "sạch", độ mạnh mật khẩu (trang tổng hợp tĩnh, '
          'lọc theo nhóm)',
      path: '/cheatsheet/auth',
      tags: const ['auth', 'security', 'storage'],
      builder: (_) => const AuthCheatsheet(),
    ),
    LayoutDemo(
      group: 'Networking & Auth',
      title: '🖼️ File preview cheat sheet',
      description:
          'Zoom/pan ảnh (InteractiveViewer), xử lý ảnh lỗi/đang tải, xem '
          'PDF, chọn ảnh/file từ máy (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/file-preview',
      tags: const ['image', 'widget'],
      builder: (_) => const FilePreviewCheatsheet(),
    ),
    // ---- Chất lượng & Vận hành ----
    LayoutDemo(
      group: 'Chất lượng & Vận hành',
      title: '🧪 Testing cheat sheet',
      description:
          'testWidgets/pumpWidget, find + tap, bắt lỗi overflow trong '
          'test, pump() vs pumpAndSettle() (trang tổng hợp tĩnh, lọc nhóm)',
      path: '/cheatsheet/testing',
      tags: const ['testing'],
      builder: (_) => const TestingCheatsheet(),
    ),
    LayoutDemo(
      group: 'Chất lượng & Vận hành',
      title: '⚡ Performance cheat sheet',
      description:
          'const widget tránh rebuild, ListView.builder lazy load, '
          'RepaintBoundary, DevTools (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/performance',
      tags: const ['performance'],
      builder: (_) => const PerformanceCheatsheet(),
    ),
    LayoutDemo(
      group: 'Chất lượng & Vận hành',
      title: '🎨 Theme & Dark Mode cheat sheet',
      description:
          'ColorScheme.fromSeed, Theme.of(context), tự chuyển Light/Dark '
          '(trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/theme',
      tags: const ['theme'],
      builder: (_) => const ThemeCheatsheet(),
    ),
    LayoutDemo(
      group: 'Chất lượng & Vận hành',
      title: '🌍 i18n (đa ngôn ngữ) cheat sheet',
      description:
          'supportedLocales, AppLocalizations.of(context), format ngày/số '
          'theo vùng (package:intl) (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/i18n',
      tags: const ['i18n'],
      builder: (_) => const I18nCheatsheet(),
    ),
    LayoutDemo(
      group: 'Chất lượng & Vận hành',
      title: '🚨 Error handling & Crash reporting cheat sheet',
      description:
          'try/catch, FlutterError.onError, runZonedGuarded, Sentry/'
          'Crashlytics (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/error-handling',
      tags: const ['error-handling', 'async'],
      builder: (_) => const ErrorHandlingCheatsheet(),
    ),
    // ---- Môi trường & Công cụ ----
    LayoutDemo(
      group: 'Môi trường & Công cụ',
      title: '🛠️ Dev Environment & FVM cheat sheet',
      description:
          'Cài IDE, extension hữu ích, flutter doctor, vì sao cần FVM để '
          'quản lý version Flutter theo project (trang tổng hợp tĩnh, '
          'lọc theo nhóm)',
      path: '/cheatsheet/dev-environment',
      tags: const ['setup', 'tooling'],
      builder: (_) => const DevEnvironmentCheatsheet(),
    ),
    LayoutDemo(
      group: 'Môi trường & Công cụ',
      title: '⌨️ Dart Tooling cheat sheet',
      description:
          'dart pub add/get, dart format, dart analyze, dart fix, dart '
          'compile (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/dart-tooling',
      tags: const ['dart', 'tooling'],
      builder: (_) => const DartToolingCheatsheet(),
    ),
  ];

  static Widget _buildColumnRowDemo(BuildContext context) =>
      const ColumnRowDemo();
  static Widget _buildExpandedFlexibleDemo(BuildContext context) =>
      const ExpandedFlexibleDemo();
  static Widget _buildStackDemo(BuildContext context) => const StackDemo();
  static Widget _buildContainerConstraintsDemo(BuildContext context) =>
      const ContainerConstraintsDemo();
  static Widget _buildListViewDemo(BuildContext context) =>
      const ListViewDemo();
  static Widget _buildGridViewDemo(BuildContext context) =>
      const GridViewDemo();
  static Widget _buildWrapDemo(BuildContext context) => const WrapDemo();
  static Widget _buildEdgeInsetsDemo(BuildContext context) =>
      const EdgeInsetsDemo();

  static Widget _buildProfileCardExample(BuildContext context) =>
      const ProfileCardStarter();
  static Widget _buildLoginFormExample(BuildContext context) =>
      const LoginFormStarter();
  static Widget _buildProductGridExample(BuildContext context) =>
      const ProductGridStarter();
  static Widget _buildChatBubbleExample(BuildContext context) =>
      const ChatBubbleStarter();
  static Widget _buildDashboardStatsExample(BuildContext context) =>
      const DashboardStatsStarter();

  static Widget _buildProfileCardAnswer(BuildContext context) =>
      const ProfileCardExample();
  static Widget _buildLoginFormAnswer(BuildContext context) =>
      const LoginFormExample();
  static Widget _buildProductGridAnswer(BuildContext context) =>
      const ProductGridExample();
  static Widget _buildChatBubbleAnswer(BuildContext context) =>
      const ChatBubbleExample();
  static Widget _buildDashboardStatsAnswer(BuildContext context) =>
      const DashboardStatsExample();

  static Widget _buildValueNotifierPattern(BuildContext context) =>
      const ValueNotifierPattern();
  static Widget _buildInheritedWidgetPattern(BuildContext context) =>
      const InheritedWidgetPattern();
  static Widget _buildConstructorsPattern(BuildContext context) =>
      const ConstructorsPattern();
  static Widget _buildExtensionPattern(BuildContext context) =>
      const ExtensionPattern();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _selectedTags = {};
  // Các section trong sidebar đang "mở" (fold/collapse) - mặc định mở hết.
  // NavigationDrawer (Material 3) không tự hỗ trợ fold từng nhóm như
  // ExpansionTile, nên tự quản lý: bấm tiêu đề section để ẩn/hiện các
  // NavigationDrawerDestination con của nó (xem _NavSidebar._addSection).
  final Set<String> _expandedSections = {'Demos', 'Examples', 'Patterns', 'Cheat Sheet'};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(LayoutDemo demo) {
    final q = _query.trim().toLowerCase();
    final matchesQuery = q.isEmpty ||
        demo.title.toLowerCase().contains(q) ||
        demo.description.toLowerCase().contains(q) ||
        demo.tags.any((t) => t.toLowerCase().contains(q));
    final matchesTags =
        _selectedTags.isEmpty || demo.tags.any(_selectedTags.contains);
    return matchesQuery && matchesTags;
  }

  List<LayoutDemo> _filter(List<LayoutDemo> list) =>
      list.where(_matches).toList();

  List<String> get _allTags {
    final tags = <String>{};
    for (final d in [
      ...HomePage.demos,
      ...HomePage.examples,
      ...HomePage.patterns,
      ...HomePage.cheatSheets,
    ]) {
      tags.addAll(d.tags);
    }
    return tags.toList()..sort();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (!_selectedTags.remove(tag)) _selectedTags.add(tag);
    });
  }

  void _toggleSection(String title) {
    setState(() {
      if (!_expandedSections.remove(title)) _expandedSections.add(title);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredDemos = _filter(HomePage.demos);
    final filteredExamples = _filter(HomePage.examples);
    final filteredPatterns = _filter(HomePage.patterns);
    final filteredCheatSheets = _filter(HomePage.cheatSheets);

    final sidebar = _NavSidebar(
      searchController: _searchController,
      onSearchChanged: (v) => setState(() => _query = v),
      allTags: _allTags,
      selectedTags: _selectedTags,
      onTagToggle: _toggleTag,
      expandedSections: _expandedSections,
      onSectionToggle: _toggleSection,
      demos: filteredDemos,
      examples: filteredExamples,
      patterns: filteredPatterns,
      cheatSheets: filteredCheatSheets,
    );

    // Dùng LayoutBuilder (không phải MediaQuery) để quyết định hiện sidebar
    // cố định hay gấp vào Drawer - nhất quán với cách mọi trang khác trong
    // app này tự co layout theo `constraints.maxWidth`, và quan trọng hơn:
    // MediaQuery.sizeOf KHÔNG phản ánh đúng kích thước giả lập trong test
    // (`tester.binding.setSurfaceSize`) nên nếu dùng sẽ không test được.
    return LayoutBuilder(
      builder: (context, outerConstraints) {
        final isWide = outerConstraints.maxWidth >= 900;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Layout Playground'),
            actions: [
              // Toggle Dark Mode THẬT (không chỉ demo trong cheat sheet) -
              // đổi themeModeNotifier.value sẽ áp dụng NGAY cho toàn app,
              // kể cả các trang đã push trước đó (Theme là InheritedWidget
              // toàn cục qua MaterialApp, không chỉ riêng HomePage).
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeModeNotifier,
                builder: (context, mode, _) {
                  final isDark = mode == ThemeMode.dark;
                  return IconButton(
                    tooltip: isDark ? 'Chuyển sang Light mode' : 'Chuyển sang Dark mode',
                    icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                    onPressed: () => themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          // Màn hình hẹp: sidebar gấp vào Drawer (bấm icon ☰ ở AppBar để
          // mở). Màn hình rộng: CÙNG widget sidebar hiện cố định bên trái
          // (xem Row dưới) - NavigationDrawer (Material 3) vốn đã tự vẽ
          // elevation/shadow riêng, không cần Drawer bọc ngoài nữa.
          drawer: isWide ? null : sidebar,
          // SelectionArea cho phép kéo chuột quét chọn text xuyên qua nhiều
          // Text/widget cùng lúc (giống chọn text trên 1 trang web thường).
          // Đặt trong từng trang (dưới Navigator) để luôn có Overlay ancestor.
          body: SelectionArea(
            child: Builder(
              builder: (context) {
                final mainContent = _MainContent(
                  isWide: isWide,
                  demos: filteredDemos,
                  examples: filteredExamples,
                  patterns: filteredPatterns,
                  cheatSheets: filteredCheatSheets,
                );

                if (!isWide) return mainContent;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: 300, child: sidebar),
                    Expanded(child: mainContent),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Khối "Giới thiệu" ở đầu vùng nội dung chính: app này là gì, dùng để làm
/// gì, và gợi ý thứ tự học - để người mới mở app không bị "rơi" thẳng vào
/// 1 danh sách dài không biết bắt đầu từ đâu.
class _IntroSection extends StatelessWidget {
  const _IntroSection();

  Widget _step(String text, Color dotColor) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.white))),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Gradient SỐNG ĐỘNG dùng chính 3 màu accent của Demos/Patterns/
        // Cheat Sheet - không phụ thuộc vào primaryContainer "nhạt nhoà"
        // của theme, nên luôn rực rỡ y hệt ở cả light và dark mode.
        gradient: LinearGradient(
          colors: [
            kSectionAccent['Demos']!,
            kSectionAccent['Patterns']!,
            kSectionAccent['Cheat Sheet']!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: kSectionAccent['Patterns']!.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👋 Flutter Layout Playground',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nơi luyện layout/UI Flutter qua demo chạy thật kèm source code, '
            'bài tập Examples có đáp án, các Pattern tổ chức code hay gặp, và '
            'một bộ Cheat Sheet tra cứu nhanh (widget, Dart syntax, animation, '
            'API, auth, testing, performance, môi trường & FVM...).',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text('Gợi ý thứ tự học:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          _step('1. Demos - nắm widget layout cơ bản (Row/Column/Stack/ListView...)', kSectionAccent['Demos']!),
          _step('2. Examples - tự làm bài tập layout UI thực tế, đối chiếu đáp án', kSectionAccent['Examples']!),
          _step('3. Patterns & Cheat Sheet - tra cứu khi cần, không cần học hết 1 lần', kSectionAccent['Cheat Sheet']!),
          const SizedBox(height: 8),
          const Text(
            '💡 Dùng ô tìm kiếm/tag ở sidebar bên trái (hoặc mở menu ☰ nếu màn '
            'hình hẹp) để lọc nhanh theo chủ đề.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// Dải "bento block" màu đậm hiện tổng số trang theo mỗi nhóm - lấy cảm
/// hứng từ các ô thống kê màu nổi bật (vàng/xám/cam đất) trong ảnh tham
/// khảo. Luôn hiện TỔNG số trang thật (không theo kết quả đang lọc) để
/// làm điểm tham chiếu ổn định, không nhảy số theo search/tag.
class _StatStrip extends StatelessWidget {
  const _StatStrip();

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Demos', HomePage.demos.length, Icons.widgets_outlined),
      ('Examples', HomePage.examples.length, Icons.assignment_outlined),
      ('Patterns', HomePage.patterns.length, Icons.extension_outlined),
      ('Cheat Sheet', HomePage.cheatSheets.length, Icons.menu_book_outlined),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((item) {
        final (title, count, icon) = item;
        final accent = kSectionAccent[title]!;
        // Chữ trên nền SOLID cần tương phản tốt - vàng (Cheat Sheet) sáng
        // nên dùng chữ đen, 3 màu còn lại tối hơn nên dùng chữ trắng.
        final onAccent = title == 'Cheat Sheet' ? Colors.black : Colors.white;
        // Width CỐ ĐỊNH (không dùng MediaQuery) để Wrap tự xuống dòng theo
        // không gian thật - MediaQuery.sizeOf không phản ánh đúng kích
        // thước giả lập trong test (`setSurfaceSize`), đã gặp lỗi này ở
        // sidebar trước đây nên tránh lặp lại.
        return Container(
          width: 150,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: onAccent, size: 20),
              const SizedBox(height: 10),
              Text('$count', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: onAccent)),
              Text(title, style: TextStyle(fontSize: 12, color: onAccent.withValues(alpha: 0.85), fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Toàn bộ vùng nội dung chính bên phải sidebar (hoặc TOÀN màn hình khi
/// hẹp, sidebar gấp vào Drawer): khối giới thiệu + các section đã lọc theo
/// search/tag hiện tại. Section nào lọc ra rỗng thì tự ẩn, không hiện tiêu
/// đề "trống trơn".
class _MainContent extends StatelessWidget {
  final bool isWide;
  final List<LayoutDemo> demos;
  final List<LayoutDemo> examples;
  final List<LayoutDemo> patterns;
  final List<LayoutDemo> cheatSheets;

  const _MainContent({
    required this.isWide,
    required this.demos,
    required this.examples,
    required this.patterns,
    required this.cheatSheets,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnyResult =
        demos.isNotEmpty || examples.isNotEmpty || patterns.isNotEmpty || cheatSheets.isNotEmpty;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _IntroSection(),
        const SizedBox(height: 12),
        const _StatStrip(),
        const SizedBox(height: 20),
        if (!hasAnyResult)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Không tìm thấy trang phù hợp - thử bỏ bớt từ khoá/tag đang lọc.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        if (demos.isNotEmpty) ...[
          const _SectionHeader('Demos'),
          _DemoGrid(demos: demos, isWide: isWide, accent: kSectionAccent['Demos']!),
          const SizedBox(height: 16),
        ],
        if (examples.isNotEmpty) ...[
          const _SectionHeader('Examples'),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Layout mẫu kết hợp nhiều widget, kèm đề bài + gợi ý để bạn '
              'tự luyện trước khi xem đáp án.',
            ),
          ),
          _DemoGrid(demos: examples, isWide: isWide, accent: kSectionAccent['Examples']!),
          const SizedBox(height: 16),
        ],
        if (patterns.isNotEmpty) ...[
          const _SectionHeader('Patterns'),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Cách tổ chức code/quản lý state hay gặp, và danh sách các '
              'package phổ biến đáng tìm hiểu thêm.',
            ),
          ),
          _DemoGrid(demos: patterns, isWide: isWide, accent: kSectionAccent['Patterns']!),
          const SizedBox(height: 16),
        ],
        if (cheatSheets.isNotEmpty) ...[
          const _SectionHeader('Cheat Sheet'),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Trang tra cứu nhanh (không phải demo chạy thật): tổng '
              'hợp sẵn syntax/widget hay dùng kèm ví dụ, để tra lại '
              'khi quên. Gom theo nhóm vì danh sách đã khá dài.',
            ),
          ),
          _CheatSheetGroups(cheatSheets: cheatSheets, isWide: isWide, accent: kSectionAccent['Cheat Sheet']!),
        ],
      ],
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(isWide ? 24 : 8),
      child: content,
    );
  }
}

/// Sidebar điều hướng: ô tìm kiếm + chip tag lọc + mục lục (Demos/Examples/
/// Patterns/Cheat Sheet) theo kết quả ĐÃ LỌC - dùng chung cho cả bản hiện
/// cố định (desktop) và bản trong Drawer (mobile).
///
/// Dùng [NavigationDrawer] CHÍNH THỨC của Material 3 (không tự dựng
/// ExpansionTile/ListTile) - đây là component điều hướng dạng danh sách
/// chuẩn Google, có indicator chọn/hover/ripple xịn sẵn, thay vì tự vẽ lại
/// từ đầu. Section/group label là các `Widget` thường chèn giữa các
/// [NavigationDrawerDestination] - [NavigationDrawer] tự biết bỏ qua
/// chúng khi tính index (chỉ đếm các `NavigationDrawerDestination`).
class _NavSidebar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<String> allTags;
  final Set<String> selectedTags;
  final ValueChanged<String> onTagToggle;
  final Set<String> expandedSections;
  final ValueChanged<String> onSectionToggle;
  final List<LayoutDemo> demos;
  final List<LayoutDemo> examples;
  final List<LayoutDemo> patterns;
  final List<LayoutDemo> cheatSheets;

  const _NavSidebar({
    required this.searchController,
    required this.onSearchChanged,
    required this.allTags,
    required this.selectedTags,
    required this.onTagToggle,
    required this.expandedSections,
    required this.onSectionToggle,
    required this.demos,
    required this.examples,
    required this.patterns,
    required this.cheatSheets,
  });

  Widget _sectionLabel(BuildContext context, String title, IconData icon, int count) {
    final cs = Theme.of(context).colorScheme;
    final expanded = expandedSections.contains(title);
    final accent = kSectionAccent[title] ?? cs.primary;
    return InkWell(
      onTap: () => onSectionToggle(title),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: accent),
            const SizedBox(width: 6),
            Text(
              title.toUpperCase(),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: accent),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)),
              child: Text('$count', style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            Icon(expanded ? Icons.expand_less : Icons.expand_more, size: 18, color: cs.outline),
          ],
        ),
      ),
    );
  }

  Widget _groupLabel(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 6, 16, 2),
      child: Text(
        title,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.outline),
      ),
    );
  }

  /// Gộp 1 section vào [destinations] - tự chèn label section (+ label
  /// từng group con nếu [groupByField]) rồi mới tới các
  /// [NavigationDrawerDestination]. Section rỗng (do bị lọc hết) tự ẩn.
  ///
  /// QUAN TRỌNG: [flatOrder] phải được cập nhật ĐÚNG SONG SONG với
  /// [destinations] - `NavigationDrawer.onDestinationSelected` trả về index
  /// tính theo thứ tự CÁC NavigationDrawerDestination THỰC SỰ xuất hiện
  /// (bỏ qua section đang fold/collapse), nên nếu [flatOrder] lại chứa cả
  /// item của section đang ẩn thì index sẽ lệch, bấm sai trang.
  void _addSection(
    BuildContext context,
    List<Widget> destinations,
    List<LayoutDemo> flatOrder,
    String title,
    IconData icon,
    List<LayoutDemo> items, {
    bool groupByField = false,
  }) {
    if (items.isEmpty) return;
    destinations.add(_sectionLabel(context, title, icon, items.length));
    if (!expandedSections.contains(title)) return; // fold: ẩn hết item con

    if (!groupByField) {
      for (final d in items) {
        flatOrder.add(d);
        destinations.add(_destinationFor(d));
      }
      return;
    }
    final groupOrder = <String>[];
    final byGroup = <String, List<LayoutDemo>>{};
    for (final d in items) {
      final g = d.group ?? 'Khác';
      byGroup.putIfAbsent(g, () {
        groupOrder.add(g);
        return [];
      }).add(d);
    }
    for (final g in groupOrder) {
      destinations.add(_groupLabel(context, g));
      for (final d in byGroup[g]!) {
        flatOrder.add(d);
        destinations.add(_destinationFor(d));
      }
    }
  }

  NavigationDrawerDestination _destinationFor(LayoutDemo demo) {
    return NavigationDrawerDestination(
      icon: const Icon(Icons.circle_outlined, size: 14),
      // NavigationDrawerDestination xếp icon+label trong 1 Row KHÔNG có
      // Expanded/Flexible nội bộ - label dài (tiêu đề đầy đủ kèm emoji) sẽ
      // làm Row tràn. Ép width cố định để Text tự ellipsis đúng cách thay
      // vì tràn ra ngoài.
      label: SizedBox(
        width: 200,
        child: Text(demo.title, overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final destinations = <Widget>[];
    final flatOrder = <LayoutDemo>[];
    _addSection(context, destinations, flatOrder, 'Demos', Icons.widgets_outlined, demos);
    _addSection(context, destinations, flatOrder, 'Examples', Icons.assignment_outlined, examples);
    _addSection(context, destinations, flatOrder, 'Patterns', Icons.extension_outlined, patterns);
    _addSection(
      context,
      destinations,
      flatOrder,
      'Cheat Sheet',
      Icons.menu_book_outlined,
      cheatSheets,
      groupByField: true,
    );

    return NavigationDrawer(
      // -1: không có mục nào "đang chọn" cố định - mỗi lần bấm sẽ MỞ 1
      // trang MỚI (push) chứ không phải chuyển tab trong cùng 1 màn hình.
      selectedIndex: -1,
      onDestinationSelected: (index) => Navigator.of(context).pushNamed(flatOrder[index].path),
      indicatorColor: cs.primaryContainer,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.explore_outlined, size: 18, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  'MỤC LỤC',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1, color: cs.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: searchController,
              builder: (context, _) {
                return TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Tìm trang...',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    suffixIcon: searchController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
                          ),
                    isDense: true,
                    filled: true,
                    fillColor: cs.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: cs.primary, width: 1.5),
                    ),
                  ),
                );
              },
            ),
            if (allTags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: allTags
                    .map(
                      (tag) => FilterChip(
                        label: Text(tag, style: const TextStyle(fontSize: 10)),
                        selected: selectedTags.contains(tag),
                        onSelected: (_) => onTagToggle(tag),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        showCheckmark: false,
                        selectedColor: cs.primary,
                        labelStyle: TextStyle(
                          color: selectedTags.contains(tag) ? cs.onPrimary : null,
                          fontSize: 10,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 4),
            Divider(height: 1, color: cs.outlineVariant),
          ],
        ),
      ),
      children: destinations,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Mỗi section có màu "thương hiệu" riêng (xem kSectionAccent) - không
    // phải lúc nào cũng dùng chung colorScheme.primary như trước, để từng
    // khu vực có cá tính thị giác rõ ràng hơn.
    final accent = kSectionAccent[title] ?? colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gom các [LayoutDemo] trong mục Cheat Sheet theo `group` (giữ đúng thứ
/// tự xuất hiện lần đầu của mỗi group trong list), mỗi group có 1 tiêu đề
/// phụ nhỏ (xem [_SubSectionHeader]) rồi mới tới lưới thẻ của riêng nó.
/// Item không có `group` (null) được xếp chung vào 1 nhóm "Khác" ở cuối.
class _CheatSheetGroups extends StatelessWidget {
  final List<LayoutDemo> cheatSheets;
  final bool isWide;
  final Color accent;

  const _CheatSheetGroups({required this.cheatSheets, required this.isWide, required this.accent});

  @override
  Widget build(BuildContext context) {
    final groupOrder = <String>[];
    final byGroup = <String, List<LayoutDemo>>{};
    for (final demo in cheatSheets) {
      final group = demo.group ?? 'Khác';
      if (!byGroup.containsKey(group)) {
        groupOrder.add(group);
        byGroup[group] = [];
      }
      byGroup[group]!.add(demo);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groupOrder) ...[
          _SubSectionHeader(group),
          const SizedBox(height: 8),
          _DemoGrid(demos: byGroup[group]!, isWide: isWide, accent: accent),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _SubSectionHeader extends StatelessWidget {
  final String title;

  const _SubSectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

/// Xếp các [_DemoTile] thành lưới nhiều cột (Wrap) khi [isWide], mỗi thẻ có
/// chiều rộng cố định nên số cột tự co giãn theo chiều rộng cửa sổ. Khi hẹp
/// (mobile) quay lại list 1 cột full-width như trước.
class _DemoGrid extends StatelessWidget {
  final List<LayoutDemo> demos;
  final bool isWide;
  final Color accent;

  const _DemoGrid({required this.demos, required this.isWide, required this.accent});

  static const double _cardWidth = 360;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(
        children: demos.map((demo) => _DemoTile(demo: demo, accent: accent)).toList(),
      );
    }
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: demos
          .map(
            (demo) => SizedBox(
              width: _cardWidth,
              child: _DemoTile(demo: demo, accent: accent),
            ),
          )
          .toList(),
    );
  }
}

class _DemoTile extends StatefulWidget {
  final LayoutDemo demo;
  final Color accent;

  const _DemoTile({required this.demo, required this.accent});

  @override
  State<_DemoTile> createState() => _DemoTileState();
}

class _DemoTileState extends State<_DemoTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final demo = widget.demo;
    final accent = widget.accent;
    // Nền "bento block" pastel - pha accent vào nền theme (khác nhau giữa
    // light/dark) thay vì màu CỨNG, để vẫn đọc được chữ ở cả 2 mode.
    final blockColor = Color.alphaBlend(accent.withValues(alpha: 0.16), colorScheme.surface);
    final blockColorHover = Color.alphaBlend(accent.withValues(alpha: 0.24), colorScheme.surface);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(bottom: 8, top: _hovering ? 0 : 4),
        transform: Matrix4.translationValues(0, _hovering ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: _hovering ? blockColorHover : blockColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hovering
              ? [BoxShadow(color: accent.withValues(alpha: 0.3), blurRadius: 18, offset: const Offset(0, 8))]
              : [BoxShadow(color: accent.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(demo.path),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon section tô màu SOLID theo accent riêng - để mỗi
                  // nhóm Demos/Examples/Patterns/Cheat Sheet có nhận diện
                  // riêng, nổi trên nền pastel cùng tông.
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.widgets_outlined, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demo.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          demo.description,
                          style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                        ),
                        if (demo.tags.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: demo.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Nút mũi tên tròn kiểu "bento block" (giống ảnh tham
                  // khảo) thay cho chevron mảnh trước đây.
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.north_east, size: 14, color: colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
