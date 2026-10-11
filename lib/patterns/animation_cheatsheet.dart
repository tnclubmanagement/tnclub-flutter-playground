import 'package:flutter/material.dart';

import '../widgets/code_panel.dart';

/// Trang tổng hợp (cheat sheet) các cách làm ANIMATION hay gặp trong Flutter:
/// animation ngầm (`Animated...` widget tự nội suy khi thuộc tính đổi) và
/// animation rõ ràng (tự quản lý `AnimationController` + `Tween`).
///
/// Đây CHỈ là trang thông tin tĩnh (giống các cheat sheet khác): code mẫu
/// minh hoạ cú pháp, không chạy thật trong app này.
class AnimationCheatsheet extends StatelessWidget {
  const AnimationCheatsheet({super.key});

  static final _items = <_AnimInfo>[
    // ---- Animation ngầm (Implicit) ----
    _AnimInfo(
      name: 'AnimatedContainer',
      category: 'Animation ngầm (Implicit)',
      description:
          'Tự động animate khi các thuộc tính (width/height/color/padding/'
          'decoration/alignment...) THAY ĐỔI giữa 2 lần build - chỉ cần '
          'đổi state rồi `setState()`, Flutter tự nội suy (interpolate) '
          'giá trị cũ -> mới qua `duration`/`curve`, KHÔNG cần tự viết '
          'AnimationController.',
      snippet: '''
bool _expanded = false;

AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: _expanded ? 200 : 100,
  height: _expanded ? 200 : 100,
  color: _expanded ? Colors.deepPurple : Colors.orange,
  child: GestureDetector(
    onTap: () => setState(() => _expanded = !_expanded),
  ),
)''',
      preview: (_) => const _AnimatedContainerDemo(),
    ),
    _AnimInfo(
      name: 'AnimatedOpacity',
      category: 'Animation ngầm (Implicit)',
      description:
          'Animate riêng độ mờ (0.0 - 1.0) khi `opacity` đổi - nhẹ hơn '
          'AnimatedContainer nếu chỉ cần fade in/out, không đổi kích '
          'thước/màu.',
      snippet: '''
AnimatedOpacity(
  opacity: _visible ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 200),
  child: const Text('Xin chào'),
)

// Lưu ý: widget vẫn CHIẾM không gian dù opacity = 0 (không ẩn hẳn khỏi
// layout) - dùng Visibility/Offstage nếu cần bỏ hẳn, không chỉ làm mờ.''',
      preview: (_) => const _AnimatedOpacityDemo(),
    ),
    _AnimInfo(
      name: 'AnimatedAlign / AnimatedPositioned',
      category: 'Animation ngầm (Implicit)',
      description:
          'Animate VỊ TRÍ. AnimatedAlign animate theo `Alignment` (dùng '
          'thay Align thường). AnimatedPositioned animate '
          'top/left/right/bottom nhưng CHỈ dùng được bên trong `Stack` '
          '(giống Positioned thường).',
      snippet: '''
Stack(
  children: [
    AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: _moved ? 100 : 0,
      left: _moved ? 50 : 0,
      child: const CircleAvatar(radius: 20),
    ),
  ],
)''',
      preview: (_) => const _AnimatedPositionedDemo(),
    ),
    _AnimInfo(
      name: 'AnimatedDefaultTextStyle',
      category: 'Animation ngầm (Implicit)',
      description:
          'Animate style của Text (màu/size/weight...) khi `TextStyle` '
          'đổi, mà KHÔNG cần set style trực tiếp trên Text - Text con tự '
          '"kế thừa" style animate từ `DefaultTextStyle` phía trên nó.',
      snippet: '''
AnimatedDefaultTextStyle(
  duration: const Duration(milliseconds: 300),
  style: TextStyle(
    fontSize: _big ? 28 : 14,
    color: _big ? Colors.red : Colors.black,
  ),
  child: const Text('Xin chào'), // Text không cần tự set style
)''',
      preview: (_) => const _AnimatedDefaultTextStyleDemo(),
    ),
    _AnimInfo(
      name: 'AnimatedCrossFade',
      category: 'Animation ngầm (Implicit)',
      description:
          'Chuyển mượt (crossfade) giữa 2 widget KHÁC NHAU hoàn toàn '
          '(không chỉ đổi thuộc tính) - vd chuyển từ "Đang tải" sang nội '
          'dung thật.',
      snippet: '''
AnimatedCrossFade(
  duration: const Duration(milliseconds: 300),
  firstChild: const CircularProgressIndicator(),
  secondChild: const Text('Đã tải xong!'),
  crossFadeState:
      _loaded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
)''',
      preview: (_) => const _AnimatedCrossFadeDemo(),
    ),
    _AnimInfo(
      name: 'AnimatedSwitcher',
      category: 'Animation ngầm (Implicit)',
      description:
          'Tự động animate (mặc định fade) khi `child` bị THAY ĐỔI (dựa '
          'theo `key` khác nhau) - hay dùng khi đổi hẳn sang widget khác '
          '(đổi icon, đổi số đếm...) mà không cần biết trước sẽ chuyển '
          'thành gì như AnimatedCrossFade.',
      snippet: '''
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: Text(
    '\$_count',
    key: ValueKey(_count), // PHẢI đổi key để biết đây là child MỚI
    style: const TextStyle(fontSize: 32),
  ),
)

// Quên đặt key khác nhau -> AnimatedSwitcher nghĩ là CÙNG 1 widget
// (chỉ đổi nội dung) và sẽ KHÔNG animate gì cả.''',
      preview: (_) => const _AnimatedSwitcherDemo(),
    ),
    _AnimInfo(
      name: 'TweenAnimationBuilder',
      category: 'Animation ngầm (Implicit)',
      description:
          'Animate 1 GIÁ TRỊ tuỳ ý (không chỉ thuộc tính UI có sẵn) từ '
          '`begin` -> `end` mỗi khi widget rebuild với tween mới - tiện '
          'khi cần animate value để tự vẽ/tự tính toán mà không có widget '
          '`Animated...` sẵn cho việc đó.',
      snippet: '''
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: _progress), // 0..1
  duration: const Duration(milliseconds: 400),
  builder: (context, value, child) => LinearProgressIndicator(value: value),
)''',
      preview: (_) => const _TweenAnimationBuilderDemo(),
    ),
    // ---- Animation rõ ràng (Explicit) ----
    _AnimInfo(
      name: 'AnimationController + Tween',
      category: 'Animation rõ ràng (Explicit)',
      description:
          'Cách animate "gốc": tự quản lý 1 `AnimationController` (cần '
          '`vsync`, thường lấy từ `SingleTickerProviderStateMixin`), chạy '
          'animation (`forward()`/`reverse()`/`repeat()`), và nghe giá '
          'trị qua `addListener` + `setState()` (hoặc gọn hơn dùng '
          '`AnimatedBuilder` - xem mục dưới).',
      snippet: '''
class _MyState extends State<MyWidget> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat(reverse: true); // chạy lặp đi lặp lại, đảo chiều

  @override
  void dispose() {
    controller.dispose(); // BẮT BUỘC - quên sẽ leak memory/ticker
    super.dispose();
  }
}''',
      preview: (_) => const _AnimationControllerDemo(),
    ),
    _AnimInfo(
      name: 'AnimatedBuilder',
      category: 'Animation rõ ràng (Explicit)',
      description:
          'Cách GỌN để chỉ rebuild phần UI phụ thuộc animation, mà KHÔNG '
          'rebuild lại toàn bộ widget cha mỗi frame. Truyền `child` '
          '(phần KHÔNG đổi) ra ngoài `builder` để Flutter không tạo lại '
          'nó mỗi lần animation tick - tối ưu hiệu năng.',
      snippet: '''
AnimatedBuilder(
  animation: controller,
  builder: (context, child) => Transform.rotate(
    angle: controller.value * 2 * 3.14159,
    child: child, // phần tĩnh, KHÔNG bị tạo lại mỗi frame
  ),
  child: const Icon(Icons.refresh, size: 48),
)''',
      preview: (_) => const _AnimatedBuilderDemo(),
    ),
    _AnimInfo(
      name: 'CurvedAnimation / Curves',
      category: 'Animation rõ ràng (Explicit)',
      description:
          '"Bọc" 1 Animation gốc (tuyến tính 0 -> 1 theo thời gian) để '
          'đổi TỐC ĐỘ theo từng giai đoạn (nhanh dần/chậm dần/nảy...) qua '
          '`Curves` (easeIn, easeOut, bounceOut, elasticOut...) - KHÔNG '
          'đổi khoảng giá trị, chỉ đổi NHỊP ĐỘ chạy.',
      snippet: '''
final curved = CurvedAnimation(
  parent: controller,
  curve: Curves.easeInOutBack,
);
final sizeTween = Tween<double>(begin: 50, end: 150).animate(curved);''',
      preview: (_) => const _CurvedAnimationDemo(),
    ),
    _AnimInfo(
      name: 'FadeTransition / SlideTransition / ScaleTransition / RotationTransition',
      category: 'Animation rõ ràng (Explicit)',
      description:
          'Các widget animate SẴN cho 1 hiệu ứng cụ thể, nhận trực tiếp '
          '1 `Animation<T>` (không cần tự vẽ qua AnimatedBuilder) - '
          'FadeTransition (opacity), SlideTransition (vị trí offset), '
          'ScaleTransition (tỉ lệ), RotationTransition (góc xoay).',
      snippet: '''
FadeTransition(
  opacity: controller, // Animation<double> 0..1
  child: const Text('Mờ dần hiện ra'),
)''',
      preview: (_) => const _TransitionWidgetsDemo(),
    ),
    _AnimInfo(
      name: 'Hero',
      category: 'Animation rõ ràng (Explicit)',
      description:
          'Animate 1 widget "bay" mượt từ vị trí/kích thước ở trang NÀY '
          'sang vị trí/kích thước ở trang KIA khi chuyển route (push/pop) '
          '- chỉ cần đặt CÙNG 1 `tag` ở Hero ở cả 2 trang, Flutter tự '
          'tính toán animation.',
      snippet: '''
// Trang A (danh sách):
Hero(tag: 'avatar-\$id', child: CircleAvatar(backgroundImage: image))

// Trang B (chi tiết) - CÙNG tag với trang A:
Hero(tag: 'avatar-\$id', child: CircleAvatar(radius: 80, backgroundImage: image))

// 2 Hero PHẢI cùng tag, và chỉ hoạt động khi chuyển trang qua Navigator
// (push/pop) - không tự chạy khi đang ở 1 trang.''',
      preview: (_) => const _HeroSimDemo(),
    ),
    _AnimInfo(
      name: 'Staggered animation (Interval)',
      category: 'Animation rõ ràng (Explicit)',
      description:
          'Nhiều animation con chạy LỆCH NHAU theo thời gian (vd icon mờ '
          'dần hiện trước, rồi text mới hiện sau) dùng CHUNG 1 '
          '`AnimationController` nhưng mỗi animation con dùng `Interval` '
          'khác nhau để chỉ "active" trong 1 khoảng [0..1] của controller.',
      snippet: '''
final iconFade = CurvedAnimation(
  parent: controller,
  curve: const Interval(0.0, 0.5, curve: Curves.easeIn), // nửa đầu
);
final textSlide = CurvedAnimation(
  parent: controller,
  curve: const Interval(0.5, 1.0, curve: Curves.easeOut), // nửa sau
);''',
      preview: (_) => const _StaggeredDemo(),
    ),
    // ---- Danh sách (List) mượt & đúng state ----
    _AnimInfo(
      name: 'Key trong ListView.builder (tránh giật/nhầm state)',
      category: 'Danh sách (List) mượt & đúng state',
      description:
          'Khi XOÁ/THÊM/SẮP XẾP LẠI item mà KHÔNG gán `key` riêng cho mỗi '
          'item, Flutter mặc định ghép (reconcile) widget cũ-mới theo VỊ '
          'TRÍ (index), KHÔNG theo dữ liệu. Nếu mỗi item có state riêng '
          '(đã tick chọn, đang animate, đã expand...) thì sau khi xoá 1 '
          'item, state đó bị "dính" nhầm sang item khác - đây là nguyên '
          'nhân phổ biến nhất gây cảm giác "giật/nhảy" khi list đổi, '
          'KHÔNG liên quan gì đến animation cả.',
      snippet: '''
// SAI: không key - state riêng mỗi item dễ bị "dính" nhầm khi list đổi
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => FavoriteRow(item: items[index]),
)

// ĐÚNG: key theo ID dữ liệu, không theo index -> Flutter ghép đúng
// widget theo ĐÚNG item dù vị trí trong list đã đổi
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return FavoriteRow(key: ValueKey(item.id), item: item);
  },
)''',
      preview: (_) => const _ListKeyDemo(),
    ),
    _AnimInfo(
      name: 'AnimatedList / AnimatedList.builder',
      category: 'Danh sách (List) mượt & đúng state',
      description:
          'Dùng khi cần THÊM/XOÁ item có animation mượt (slide/fade/co '
          'giãn) thay vì item "biến mất/xuất hiện" ngay lập tức như '
          'ListView thường. Khác ListView.builder: phải tự gọi '
          '`insertItem`/`removeItem` qua 1 `GlobalKey<AnimatedListState>` '
          'NGAY SAU KHI sửa list dữ liệu.',
      snippet: '''
final listKey = GlobalKey<AnimatedListState>();
final items = <String>['A', 'B', 'C'];

AnimatedList(
  key: listKey,
  initialItemCount: items.length,
  itemBuilder: (context, index, animation) => SizeTransition(
    sizeFactor: animation,
    child: ListTile(title: Text(items[index])),
  ),
)

// Thêm item - sửa list TRƯỚC, rồi báo AnimatedList ngay sau đó:
items.insert(0, 'Mới');
listKey.currentState!.insertItem(0);

// Xoá item - PHẢI tự cung cấp lại UI của item ĐÃ XOÁ cho animation
// thoát ra, vì lúc này nó không còn trong `items` nữa:
final removed = items.removeAt(0);
listKey.currentState!.removeItem(
  0,
  (context, animation) => SizeTransition(
    sizeFactor: animation,
    child: ListTile(title: Text(removed)),
  ),
);''',
      preview: (_) => const _AnimatedListDemo(),
    ),
  ];

  static List<String> get _categories =>
      _items.map((i) => i.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Animation cheat sheet'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              const Tab(text: 'Tất cả'),
              ..._categories.map((c) => Tab(text: c)),
            ],
          ),
        ),
        body: SelectionArea(
          child: TabBarView(
            children: [
              _AnimList(items: _items),
              ..._categories.map(
                (c) => _AnimList(
                  items: _items.where((i) => i.category == c).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimList extends StatelessWidget {
  final List<_AnimInfo> items;

  const _AnimList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Animation ngầm (Implicit): chỉ đổi state, widget Animated... '
              'tự nội suy. Animation rõ ràng (Explicit): tự quản lý '
              'AnimationController cho hiệu ứng tuỳ biến sâu hơn. Lọc theo '
              'nhóm bằng tab ở trên, hoặc xem "Tất cả".',
            ),
          );
        }
        return _AnimCard(info: items[index - 1]);
      },
    );
  }
}

class _AnimInfo {
  final String name;
  final String category;
  final String description;
  final String snippet;
  final WidgetBuilder preview;

  const _AnimInfo({
    required this.name,
    required this.category,
    required this.description,
    required this.snippet,
    required this.preview,
  });
}

class _AnimCard extends StatelessWidget {
  final _AnimInfo info;

  const _AnimCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  info.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(label: Text(info.category, style: const TextStyle(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 8),
            Text(info.description, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Text(
              '▶ Xem trực tiếp (bấm vào demo bên dưới):',
              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(builder: info.preview),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: CodePanel(source: info.snippet, error: null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Caption nhỏ gợi ý hành động dưới mỗi demo (dùng chung cho gọn, tránh lặp
/// lại cùng 1 đoạn Text style ở 13 demo khác nhau).
class _Hint extends StatelessWidget {
  final String text;

  const _Hint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _AnimatedContainerDemo extends StatefulWidget {
  const _AnimatedContainerDemo();

  @override
  State<_AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<_AnimatedContainerDemo> {
  bool _big = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _big = !_big),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _big ? 140 : 70,
            height: _big ? 80 : 44,
            decoration: BoxDecoration(
              color: _big ? Colors.deepPurple : Colors.orange,
              borderRadius: BorderRadius.circular(_big ? 20 : 8),
            ),
            alignment: Alignment.center,
            child: Text(
              _big ? 'To' : 'Nhỏ',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        const _Hint('Bấm vào ô để phóng to/thu nhỏ'),
      ],
    );
  }
}

class _AnimatedOpacityDemo extends StatefulWidget {
  const _AnimatedOpacityDemo();

  @override
  State<_AnimatedOpacityDemo> createState() => _AnimatedOpacityDemoState();
}

class _AnimatedOpacityDemoState extends State<_AnimatedOpacityDemo> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _visible = !_visible),
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.15,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: const Icon(Icons.star, color: Colors.white, size: 28),
            ),
          ),
        ),
        const _Hint('Bấm để fade in/out'),
      ],
    );
  }
}

class _AnimatedPositionedDemo extends StatefulWidget {
  const _AnimatedPositionedDemo();

  @override
  State<_AnimatedPositionedDemo> createState() => _AnimatedPositionedDemoState();
}

class _AnimatedPositionedDemoState extends State<_AnimatedPositionedDemo> {
  bool _moved = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _moved = !_moved),
          child: Container(
            width: 120,
            height: 70,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  top: _moved ? 36 : 2,
                  left: _moved ? 80 : 2,
                  child: const CircleAvatar(radius: 14, backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ),
        const _Hint('Bấm để di chuyển vị trí'),
      ],
    );
  }
}

class _AnimatedDefaultTextStyleDemo extends StatefulWidget {
  const _AnimatedDefaultTextStyleDemo();

  @override
  State<_AnimatedDefaultTextStyleDemo> createState() => _AnimatedDefaultTextStyleDemoState();
}

class _AnimatedDefaultTextStyleDemoState extends State<_AnimatedDefaultTextStyleDemo> {
  bool _big = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _big = !_big),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: _big ? 26 : 14,
              fontWeight: FontWeight.bold,
              color: _big ? Colors.red : Colors.black87,
            ),
            child: const Text('Xin chào'),
          ),
        ),
        const _Hint('Bấm để đổi cỡ chữ/màu'),
      ],
    );
  }
}

class _AnimatedCrossFadeDemo extends StatefulWidget {
  const _AnimatedCrossFadeDemo();

  @override
  State<_AnimatedCrossFadeDemo> createState() => _AnimatedCrossFadeDemoState();
}

class _AnimatedCrossFadeDemoState extends State<_AnimatedCrossFadeDemo> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _loaded = !_loaded),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            secondChild: const Text('Đã tải xong!', style: TextStyle(fontWeight: FontWeight.bold)),
            crossFadeState: _loaded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          ),
        ),
        const _Hint('Bấm để chuyển "đang tải" <-> "xong"'),
      ],
    );
  }
}

class _AnimatedSwitcherDemo extends StatefulWidget {
  const _AnimatedSwitcherDemo();

  @override
  State<_AnimatedSwitcherDemo> createState() => _AnimatedSwitcherDemoState();
}

class _AnimatedSwitcherDemoState extends State<_AnimatedSwitcherDemo> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _count++),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '$_count',
              key: ValueKey(_count),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const _Hint('Bấm để tăng số (mỗi số là 1 widget MỚI)'),
      ],
    );
  }
}

class _TweenAnimationBuilderDemo extends StatefulWidget {
  const _TweenAnimationBuilderDemo();

  @override
  State<_TweenAnimationBuilderDemo> createState() => _TweenAnimationBuilderDemoState();
}

class _TweenAnimationBuilderDemoState extends State<_TweenAnimationBuilderDemo> {
  double _target = 0.2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _target = _target > 0.5 ? 0.15 : 0.9),
          child: SizedBox(
            width: 100,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _target),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: value, minHeight: 10),
              ),
            ),
          ),
        ),
        const _Hint('Bấm để animate progress tới giá trị mới'),
      ],
    );
  }
}

/// Dùng chung cho mục "AnimationController + Tween": nút play/stop điều
/// khiển `repeat(reverse: true)`, nghe giá trị qua `addListener` + setState
/// (ĐÚNG như code mẫu, không dùng AnimatedBuilder) để co giãn 1 box.
class _AnimationControllerDemo extends StatefulWidget {
  const _AnimationControllerDemo();

  @override
  State<_AnimationControllerDemo> createState() => _AnimationControllerDemoState();
}

class _AnimationControllerDemoState extends State<_AnimationControllerDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..addListener(() => setState(() {}));
  bool _playing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _playing = !_playing);
    if (_playing) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = 1.0 + _controller.value * 0.4;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: scale,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _toggle,
          icon: Icon(_playing ? Icons.stop : Icons.play_arrow, size: 16),
          label: Text(_playing ? 'Dừng' : 'Chạy', style: const TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
        ),
      ],
    );
  }
}

/// Mục "AnimatedBuilder": bấm 1 lần -> xoay đúng 1 vòng (forward từ 0), thể
/// hiện rõ `child:` (icon) KHÔNG bị rebuild lại - chỉ phần Transform mới
/// rebuild mỗi frame.
class _AnimatedBuilderDemo extends StatefulWidget {
  const _AnimatedBuilderDemo();

  @override
  State<_AnimatedBuilderDemo> createState() => _AnimatedBuilderDemoState();
}

class _AnimatedBuilderDemoState extends State<_AnimatedBuilderDemo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _controller.forward(from: 0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.rotate(
              angle: _controller.value * 2 * 3.14159,
              child: child,
            ),
            child: const Icon(Icons.refresh, size: 40, color: Colors.deepOrange),
          ),
        ),
        const _Hint('Bấm icon để xoay 1 vòng'),
      ],
    );
  }
}

/// Mục "CurvedAnimation / Curves": 2 thanh chạy CÙNG lúc, CÙNG thời gian,
/// nhưng 1 theo Curves.linear và 1 theo Curves.easeInOutBack - thấy rõ sự
/// khác biệt về NHỊP ĐỘ dù khoảng giá trị animate giống nhau.
class _CurvedAnimationDemo extends StatefulWidget {
  const _CurvedAnimationDemo();

  @override
  State<_CurvedAnimationDemo> createState() => _CurvedAnimationDemoState();
}

class _CurvedAnimationDemoState extends State<_CurvedAnimationDemo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _linear = CurvedAnimation(parent: _controller, curve: Curves.linear);
  late final Animation<double> _curved = CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bar(Animation<double> animation, Color color, String label) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 48, child: Text(label, style: const TextStyle(fontSize: 11))),
          Container(
            width: 10 + animation.value * 90,
            height: 10,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _controller.forward(from: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _bar(_linear, Colors.grey, 'linear'),
              const SizedBox(height: 6),
              _bar(_curved, Colors.deepPurple, 'easeInOutBack'),
            ],
          ),
        ),
        const _Hint('Bấm để so sánh 2 curve cùng thời gian'),
      ],
    );
  }
}

/// Mục "*Transition widgets": bấm để Fade + Scale 1 icon vào, minh hoạ
/// FadeTransition/ScaleTransition nhận trực tiếp `Animation<double>`.
class _TransitionWidgetsDemo extends StatefulWidget {
  const _TransitionWidgetsDemo();

  @override
  State<_TransitionWidgetsDemo> createState() => _TransitionWidgetsDemoState();
}

class _TransitionWidgetsDemoState extends State<_TransitionWidgetsDemo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _controller.forward(from: 0),
          child: SizedBox(
            width: 60,
            height: 60,
            child: FadeTransition(
              opacity: _controller,
              child: ScaleTransition(
                scale: _controller,
                child: const Icon(Icons.favorite, color: Colors.pink, size: 48),
              ),
            ),
          ),
        ),
        const _Hint('Bấm để Fade + Scale icon vào'),
      ],
    );
  }
}

/// Mục "Hero": vì Hero THẬT cần 2 route riêng (xem Patterns/Examples có
/// Navigator), ở đây mô phỏng lại hiệu ứng "bay" bằng AnimatedAlign +
/// AnimatedContainer để vẫn thấy được CẢM GIÁC chuyển động mượt tương tự.
class _HeroSimDemo extends StatefulWidget {
  const _HeroSimDemo();

  @override
  State<_HeroSimDemo> createState() => _HeroSimDemoState();
}

class _HeroSimDemoState extends State<_HeroSimDemo> {
  bool _detail = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _detail = !_detail),
          child: Container(
            width: 140,
            height: 90,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: _detail ? Alignment.center : Alignment.topLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: _detail ? 60 : 28,
                height: _detail ? 60 : 28,
                decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
        const _Hint('Mô phỏng Hero: bấm để "bay" từ góc ra giữa'),
      ],
    );
  }
}

/// Mục "Staggered animation (Interval)": 1 controller duy nhất, icon fade
/// vào ở nửa đầu (Interval 0.0-0.5), text slide vào ở nửa sau (0.5-1.0).
class _StaggeredDemo extends StatefulWidget {
  const _StaggeredDemo();

  @override
  State<_StaggeredDemo> createState() => _StaggeredDemoState();
}

class _StaggeredDemoState extends State<_StaggeredDemo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _iconFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
  );
  late final Animation<Offset> _textSlide = Tween<Offset>(
    begin: const Offset(0.4, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _controller.forward(from: 0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _iconFade,
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                ),
                const SizedBox(width: 8),
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                    ),
                    child: const Text('Hoàn tất!', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const _Hint('Bấm để xem icon rồi text hiện lệch nhau'),
      ],
    );
  }
}

class _ListItemData {
  final int id;
  final String label;
  final Color color;

  const _ListItemData(this.id, this.label, this.color);
}

/// Mục "Key trong ListView.builder": so sánh TRỰC TIẾP 2 trường hợp (bật/
/// tắt key) trên CÙNG 1 thao tác xoá, để thấy rõ state "dính" nhầm sang
/// item khác khi thiếu key.
class _ListKeyDemo extends StatefulWidget {
  const _ListKeyDemo();

  @override
  State<_ListKeyDemo> createState() => _ListKeyDemoState();
}

class _ListKeyDemoState extends State<_ListKeyDemo> {
  bool _useKey = false;

  static const _initial = [
    _ListItemData(1, 'Dòng A', Colors.red),
    _ListItemData(2, 'Dòng B', Colors.green),
    _ListItemData(3, 'Dòng C', Colors.blue),
  ];

  List<_ListItemData> _items = List.of(_initial);

  void _removeFirst() {
    if (_items.isEmpty) return;
    setState(() => _items = _items.sublist(1));
  }

  void _reset() {
    setState(() => _items = List.of(_initial));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Dùng key:', style: TextStyle(fontSize: 12)),
            Switch(value: _useKey, onChanged: (v) => setState(() => _useKey = v)),
          ],
        ),
        const SizedBox(
          width: 220,
          child: Text(
            'Bấm ☆ để đánh dấu 1 dòng, rồi "Xoá dòng đầu" và xem dấu ☆ có '
            'đi theo ĐÚNG dòng đó không.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 200,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in _items)
                _FavoriteRow(key: _useKey ? ValueKey(item.id) : null, item: item),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: _items.isEmpty ? null : _removeFirst,
              child: const Text('Xoá dòng đầu', style: TextStyle(fontSize: 11)),
            ),
            TextButton(onPressed: _reset, child: const Text('Reset', style: TextStyle(fontSize: 11))),
          ],
        ),
      ],
    );
  }
}

/// 1 dòng trong [_ListKeyDemo] - cố tình giữ state `_starred` RIÊNG của
/// widget (không nằm trong `_ListItemData`), giống lỗi thường gặp: state
/// UI (đã tick/đã expand) sống trong State của item widget, không phải
/// trong data model.
class _FavoriteRow extends StatefulWidget {
  final _ListItemData item;

  const _FavoriteRow({super.key, required this.item});

  @override
  State<_FavoriteRow> createState() => _FavoriteRowState();
}

class _FavoriteRowState extends State<_FavoriteRow> {
  bool _starred = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Container(width: 14, height: 14, color: widget.item.color),
          const SizedBox(width: 8),
          Text(widget.item.label, style: const TextStyle(fontSize: 12)),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => _starred = !_starred),
            child: Icon(
              _starred ? Icons.star : Icons.star_border,
              size: 18,
              color: Colors.amber.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mục "AnimatedList / AnimatedList.builder": thêm/xoá item THẬT, có
/// animation co giãn + fade mượt qua `insertItem`/`removeItem`.
class _AnimatedListDemo extends StatefulWidget {
  const _AnimatedListDemo();

  @override
  State<_AnimatedListDemo> createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<_AnimatedListDemo> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<Color> _colors = [Colors.red, Colors.green, Colors.blue];
  int _nextColor = 0;

  void _insert() {
    final color = Colors.primaries[_nextColor % Colors.primaries.length];
    _nextColor++;
    _colors.insert(0, color);
    _listKey.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
  }

  void _removeFirst() {
    if (_colors.isEmpty) return;
    final removedColor = _colors.removeAt(0);
    _listKey.currentState!.removeItem(
      0,
      (context, animation) => _buildItem(removedColor, animation),
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildItem(Color color, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Container(
          height: 26,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 140,
          height: 100,
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _colors.length,
            itemBuilder: (context, index, animation) => _buildItem(_colors[index], animation),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: _insert, child: const Text('+ Thêm', style: TextStyle(fontSize: 11))),
            TextButton(onPressed: _removeFirst, child: const Text('- Xoá', style: TextStyle(fontSize: 11))),
          ],
        ),
      ],
    );
  }
}
