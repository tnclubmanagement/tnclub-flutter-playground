import 'package:flutter/material.dart';

import '../demos/column_row_demo.dart';
import '../demos/container_constraints_demo.dart';
import '../demos/edgeinsets_demo.dart';
import '../demos/expanded_flexible_demo.dart';
import '../demos/gridview_demo.dart';
import '../demos/listview_demo.dart';
import '../demos/stack_demo.dart';
import '../demos/stateless_vs_stateful_demo.dart';
import '../demos/wrap_demo.dart';
import '../examples/chat_bubble_example.dart';
import '../examples/chat_bubble_starter.dart';
import '../examples/dashboard_stats_example.dart';
import '../examples/dashboard_stats_starter.dart';
import '../examples/login_form_example.dart';
import '../examples/login_form_starter.dart';
import '../examples/product_grid_example.dart';
import '../examples/product_grid_starter.dart';
import '../examples/profile_card_example.dart';
import '../examples/profile_card_starter.dart';
import '../models/layout_demo.dart';
import '../patterns/animation_cheatsheet.dart';
import '../patterns/api_service_cheatsheet.dart';
import '../patterns/atomic_widgets_cheatsheet.dart';
import '../patterns/auth_cheatsheet.dart';
import '../patterns/constructors_pattern.dart';
import '../patterns/dart_syntax_cheatsheet.dart';
import '../patterns/dart_tooling_cheatsheet.dart';
import '../patterns/deploy_cheatsheet.dart';
import '../patterns/dev_environment_cheatsheet.dart';
import '../patterns/error_handling_cheatsheet.dart';
import '../patterns/extension_pattern.dart';
import '../patterns/file_preview_cheatsheet.dart';
import '../patterns/getting_started_cheatsheet.dart';
import '../patterns/glossary_cheatsheet.dart';
import '../patterns/i18n_cheatsheet.dart';
import '../patterns/inherited_widget_pattern.dart';
import '../patterns/libraries_page.dart';
import '../patterns/local_storage_cheatsheet.dart';
import '../patterns/navigation_cheatsheet.dart';
import '../patterns/performance_cheatsheet.dart';
import '../patterns/requirements_cheatsheet.dart';
import '../patterns/state_management_cheatsheet.dart';
import '../patterns/testing_cheatsheet.dart';
import '../patterns/theme_cheatsheet.dart';
import '../patterns/value_notifier_pattern.dart';
import '../patterns/widgets_cheatsheet.dart';
import '../widgets/demo_scaffold.dart';
import '../widgets/example_scaffold.dart';
import 'background_blobs.dart';
import 'main_content.dart';
import 'nav_sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final List<LayoutDemo> demos = [
    LayoutDemo(
      title: 'StatelessWidget vs StatefulWidget',
      description:
          'Nền tảng cơ bản nhất: khi nào widget "tĩnh", khi nào cần giữ '
          'state + setState() để tự thay đổi',
      path: '/stateless-vs-stateful',
      tags: const ['widget', 'state', 'beginner'],
      builder: (_) => const DemoScaffold(
        title: 'StatelessWidget vs StatefulWidget',
        assetPath: 'lib/demos/stateless_vs_stateful_demo.dart',
        bodyBuilder: _buildStatelessVsStatefulDemo,
      ),
    ),
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
      description:
          'Column các field + Row (Checkbox/Spacer) + Expanded(Divider)',
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
      description:
          'Wrap cho thẻ thống kê + ListView ngang cho hoạt động gần đây',
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
      advanced: true,
      builder: (_) => const DemoScaffold(
        title: 'Pattern: InheritedWidget',
        assetPath: 'lib/patterns/inherited_widget_pattern.dart',
        bodyBuilder: _buildInheritedWidgetPattern,
      ),
    ),
    LayoutDemo(
      title: 'Named & Factory constructor',
      description:
          'Nhiều cách tạo object theo ngữ cảnh, factory tự chọn implementation',
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
  // Gom theo `group` vì danh sách đã khá dài - xem DemoGrid/SectionHeader
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
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/01-atomic-widgets.vi.md',
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
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/02-widgets.vi.md',
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
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/03-dart-syntax.vi.md',
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
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/04-animation.vi.md',
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
      advanced: true,
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/05-state-management.vi.md',
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
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/06-navigation.vi.md',
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
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/07-local-storage.vi.md',
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
      advanced: true,
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/08-api-service.vi.md',
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
      advanced: true,
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/09-auth.vi.md',
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
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/10-file-preview.vi.md',
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
      advanced: true,
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/11-testing.vi.md',
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
      advanced: true,
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/12-performance.vi.md',
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
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/13-theme.vi.md',
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
      advanced: true,
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/14-i18n.vi.md',
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
      advanced: true,
      articleAssetPath:
          'content/articles/chapter-02-cheat-sheets/15-error-handling.vi.md',
      builder: (_) => const ErrorHandlingCheatsheet(),
    ),
  ];

  // "Môi trường & Công cụ" trước là 1 group con bên trong Cheat Sheet, giờ
  // tách thành 1 CHỦ ĐỀ riêng (ngang hàng Demos/Examples/Patterns/Cheat
  // Sheet) vì nội dung (cài đặt máy, công cụ dòng lệnh) khác hẳn các trang
  // tra cứu syntax/widget còn lại.
  static final List<LayoutDemo> environmentTools = [
    LayoutDemo(
      title: '✅ Yêu cầu trước khi học Flutter',
      description:
          'Checklist dành cho người mới: kiến thức nền tảng, thiết bị, '
          'Flutter SDK, IDE và cách chọn thiết bị chạy thử',
      path: '/cheatsheet/requirements',
      tags: const ['setup', 'beginner'],
      articleAssetPath:
          'content/articles/chapter-01-getting-started/01-requirements.vi.md',
      builder: (_) => const RequirementsCheatsheet(),
    ),
    LayoutDemo(
      title: '🚀 Bắt đầu với Flutter',
      description:
          'Dành cho người MỚI TINH: Flutter/Dart là gì, cài SDK, tạo '
          'project đầu tiên, cấu trúc project, flutter run + Hot Reload/'
          'Restart (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/getting-started',
      tags: const ['setup', 'beginner'],
      articleAssetPath: 'content/articles/chapter-01-getting-started/02-first-flutter-app.vi.md',
      builder: (_) => const GettingStartedCheatsheet(),
    ),
    LayoutDemo(
      title: '🛠️ Dev Environment & FVM cheat sheet',
      description:
          'Cài IDE, extension hữu ích, flutter doctor, vì sao cần FVM để '
          'quản lý version Flutter theo project (trang tổng hợp tĩnh, '
          'lọc theo nhóm)',
      path: '/cheatsheet/dev-environment',
      tags: const ['setup', 'tooling'],
      articleAssetPath: 'content/articles/chapter-01-getting-started/03-dev-environment.vi.md',
      builder: (_) => const DevEnvironmentCheatsheet(),
    ),
    LayoutDemo(
      title: '📦 Deploy lên Android & iOS',
      description:
          'Chuẩn bị tên/icon/version, ký + build release cho Android '
          '(keystore, AAB) và iOS (Xcode signing, IPA - cần máy Mac), '
          'nộp lên Play Store/App Store/TestFlight, checklist trước khi '
          'submit (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/deploy',
      tags: const ['setup', 'tooling', 'android', 'ios'],
      articleAssetPath:
          'content/articles/chapter-01-getting-started/04-deploy.vi.md',
      builder: (_) => const DeployCheatsheet(),
    ),
    LayoutDemo(
      title: '⌨️ Dart Tooling cheat sheet',
      description:
          'dart pub add/get, dart format, dart analyze, dart fix, dart '
          'compile (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/dart-tooling',
      tags: const ['dart', 'tooling'],
      articleAssetPath:
          'content/articles/chapter-01-getting-started/05-dart-tooling.vi.md',
      builder: (_) => const DartToolingCheatsheet(),
    ),
    LayoutDemo(
      title: '📚 Giải thích thuật ngữ (Glossary)',
      description:
          'Tra nhanh các từ hay gặp khi mới học (Widget, State, '
          'BuildContext, SDK, pubspec.yaml, null safety...) (trang tổng '
          'hợp tĩnh, lọc theo nhóm)',
      path: '/cheatsheet/glossary',
      tags: const ['beginner', 'dart'],
      articleAssetPath:
          'content/articles/chapter-01-getting-started/06-glossary.vi.md',
      builder: (_) => const GlossaryCheatsheet(),
    ),
  ];

  static Widget _buildStatelessVsStatefulDemo(BuildContext context) =>
      const StatelessVsStatefulDemo();
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
  // NavigationDrawerDestination con của nó (xem NavSidebar._addSection).
  final Set<String> _expandedSections = {
    'Demos',
    'Examples',
    'Patterns',
    'Cheat Sheet',
    'Môi trường & Công cụ',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(LayoutDemo demo) {
    final q = _query.trim().toLowerCase();
    final matchesQuery =
        q.isEmpty ||
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
      ...HomePage.environmentTools,
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
    final filteredEnvironmentTools = _filter(HomePage.environmentTools);

    final sidebar = NavSidebar(
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
      environmentTools: filteredEnvironmentTools,
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
          // KHÔNG còn AppBar/header riêng - tên app + nút dark mode giờ
          // nằm NGAY trong sidebar (xem NavSidebar) để trang đỡ bị chia
          // làm 2 tầng điều hướng (header + sidebar) như trước.
          //
          // Màn hình hẹp vẫn cần 1 thanh TỐI THIỂU chỉ để có icon ☰ mở
          // Drawer (không có AppBar thì không có cách chuẩn nào để mở
          // sidebar) - không hiện title ở đây nữa vì title đã chuyển vào
          // sidebar/drawer rồi.
          appBar: isWide
              ? null
              : AppBar(title: const SizedBox.shrink(), toolbarHeight: 48),
          // Màn hình hẹp: sidebar gấp vào Drawer (bấm icon ☰ ở thanh trên để
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
                final mainContent = MainContent(
                  isWide: isWide,
                  demos: filteredDemos,
                  examples: filteredExamples,
                  patterns: filteredPatterns,
                  cheatSheets: filteredCheatSheets,
                  environmentTools: filteredEnvironmentTools,
                );

                // BackgroundBlobs nằm Ở DƯỚI CÙNG (phía sau) - các
                // GlassPanel (sidebar, section panel) phía trên làm mờ
                // đúng những khối màu này, tạo hiệu ứng Liquid Glass.
                return Stack(
                  children: [
                    const Positioned.fill(child: BackgroundBlobs()),
                    if (!isWide)
                      mainContent
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 300, child: sidebar),
                          Expanded(child: mainContent),
                        ],
                      ),
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
