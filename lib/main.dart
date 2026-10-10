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
import 'patterns/atomic_widgets_cheatsheet.dart';
import 'patterns/constructors_pattern.dart';
import 'patterns/dart_syntax_cheatsheet.dart';
import 'patterns/extension_pattern.dart';
import 'patterns/inherited_widget_pattern.dart';
import 'patterns/libraries_page.dart';
import 'patterns/value_notifier_pattern.dart';
import 'patterns/widgets_cheatsheet.dart';
import 'widgets/demo_scaffold.dart';
import 'widgets/example_scaffold.dart';

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
    ]) {
      if (demo.path == settings.name) {
        return MaterialPageRoute(settings: settings, builder: demo.builder);
      }
    }
    return MaterialPageRoute(settings: settings, builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5B4FE9), // indigo/violet hiện đại hơn deepPurple mặc định
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'Flutter Layout Playground',
      theme: ThemeData(
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
      ),
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

class LayoutDemo {
  final String title;
  final String description;
  final String path;
  final WidgetBuilder builder;

  const LayoutDemo({
    required this.title,
    required this.description,
    required this.path,
    required this.builder,
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<LayoutDemo> demos = [
    LayoutDemo(
      title: 'Row & Column',
      description: 'Sắp xếp widget theo trục ngang/dọc, mainAxisAlignment, crossAxisAlignment',
      path: '/row-column',
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
      builder: (_) => const LibrariesPage(),
    ),
    LayoutDemo(
      title: '🧩 Atomic widgets cheat sheet',
      description:
          'BoxDecoration, BoxShape, BoxShadow, TextStyle, MainAxisAlignment, '
          'Positioned, Clip, padding vs margin... (trang tổng hợp tĩnh)',
      path: '/patterns/atomic-widgets',
      builder: (_) => const AtomicWidgetsCheatsheet(),
    ),
    LayoutDemo(
      title: '� Widget cheat sheet',
      description:
          'Bảng tra nhanh: constructor mẫu, dùng để làm gì, có padding/'
          'background/scroll hay gì đặc biệt (trang tổng hợp tĩnh, lọc nhóm)',
      path: '/patterns/widgets-cheatsheet',
      builder: (_) => const WidgetsCheatsheet(),
    ),
    LayoutDemo(
      title: '�📖 Dart syntax cheat sheet',
      description:
          'Null safety, cascade ".." , spread "...", async/await, pattern '
          'matching, constructor... (trang tổng hợp tĩnh, lọc theo nhóm)',
      path: '/patterns/dart-syntax-cheatsheet',
      builder: (_) => const DartSyntaxCheatsheet(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Layout Playground')),
      // SelectionArea cho phép kéo chuột quét chọn text xuyên qua nhiều
      // Text/widget cùng lúc (giống chọn text trên 1 trang web thường).
      // Đặt trong từng trang (dưới Navigator) để luôn có Overlay ancestor.
      body: SelectionArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Màn hình rộng (web/desktop): xếp các thẻ thành lưới nhiều cột,
            // giới hạn chiều rộng nội dung để không bị kéo dài hết màn hình.
            // Màn hình hẹp (mobile): quay lại list 1 cột full-width như cũ.
            final isWide = constraints.maxWidth >= 700;
            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader('Demos'),
                _DemoGrid(demos: demos, isWide: isWide),
                const SizedBox(height: 16),
                const _SectionHeader('Examples'),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    'Layout mẫu kết hợp nhiều widget, kèm đề bài + gợi ý để bạn '
                    'tự luyện trước khi xem đáp án.',
                  ),
                ),
                _DemoGrid(demos: examples, isWide: isWide),
                const SizedBox(height: 16),
                const _SectionHeader('Patterns'),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    'Cách tổ chức code/quản lý state hay gặp, và danh sách các '
                    'package phổ biến đáng tìm hiểu thêm.',
                  ),
                ),
                _DemoGrid(demos: patterns, isWide: isWide),
              ],
            );

            if (!isWide) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: content,
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: content,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: colorScheme.primary,
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

/// Xếp các [_DemoTile] thành lưới nhiều cột (Wrap) khi [isWide], mỗi thẻ có
/// chiều rộng cố định nên số cột tự co giãn theo chiều rộng cửa sổ. Khi hẹp
/// (mobile) quay lại list 1 cột full-width như trước.
class _DemoGrid extends StatelessWidget {
  final List<LayoutDemo> demos;
  final bool isWide;

  const _DemoGrid({required this.demos, required this.isWide});

  static const double _cardWidth = 360;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(
        children: demos.map((demo) => _DemoTile(demo: demo)).toList(),
      );
    }
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: demos
          .map(
            (demo) => SizedBox(
              width: _cardWidth,
              child: _DemoTile(demo: demo),
            ),
          )
          .toList(),
    );
  }
}

class _DemoTile extends StatelessWidget {
  final LayoutDemo demo;

  const _DemoTile({required this.demo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(demo.path),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.widgets_outlined, color: colorScheme.onPrimaryContainer, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      demo.description,
                      style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
