import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về PERFORMANCE: tránh rebuild thừa (`const`), load lazy
/// (`ListView.builder`), cách ly phần hay đổi (`RepaintBoundary`), và công
/// cụ đo (DevTools).
class PerformanceCheatsheet extends StatelessWidget {
  const PerformanceCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'const widget - tránh rebuild thừa',
      category: 'const & rebuild',
      description:
          'Khi widget cha rebuild (vd sau `setState`), MỌI widget con '
          'trong `build()` cũng bị gọi lại `build()` - TRỪ widget con nào '
          'được tạo bằng `const` VÀ không đổi gì giữa 2 lần build: Flutter '
          'nhận ra đó là CÙNG 1 instance (so sánh `==`) và bỏ qua, không '
          'build lại. Demo bên dưới đếm số lần `build()` thật của 2 Text '
          'giống nhau - 1 const, 1 không.',
      snippet: '''
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}
class _MyPageState extends State<MyPage> {
  int _tick = 0;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const ExpensiveHeader(),       // const -> KHÔNG rebuild lại
      ExpensiveHeader(),             // thiếu const -> rebuild lại MỖI lần
      ElevatedButton(
        onPressed: () => setState(() => _tick++),
        child: Text('\$_tick'),
      ),
    ]);
  }
}''',
      preview: (_) => const _ConstRebuildDemo(),
    ),
    CheatsheetEntry(
      name: 'ListView.builder - chỉ build item ĐANG HIỂN THỊ (lazy)',
      category: 'Lazy load',
      description:
          '`ListView(children: [...])` build TOÀN BỘ item ngay lập tức, '
          'dù chưa cuộn tới. `ListView.builder` chỉ gọi `itemBuilder` cho '
          'item đang HIỂN THỊ (+ 1 khoảng đệm nhỏ để cuộn êm) - với list '
          'dài hàng nghìn item, đây là sự khác biệt giữa app chạy êm và '
          'app bị giật/tốn RAM. Demo bên dưới đếm đúng số item ĐÃ build '
          'trong lúc bạn cuộn.',
      snippet: '''
// SAI với list dài: build hết 1000 item ngay cả khi chỉ thấy 5 item
ListView(children: List.generate(1000, (i) => ListTile(title: Text('\$i'))))

// ĐÚNG: chỉ build item đang hiển thị
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, i) => ListTile(title: Text('\$i')),
)''',
      preview: (_) => const _LazyBuildDemo(),
    ),
    CheatsheetEntry(
      name: 'RepaintBoundary - cách ly phần hay đổi',
      category: 'Repaint',
      description:
          'Khi 1 phần UI đổi LIÊN TỤC (animation, đồng hồ đếm giờ...), '
          'Flutter mặc định có thể phải vẽ lại (`repaint`) CẢ CÁC WIDGET '
          'XUNG QUANH nó trong cùng 1 "layer". `RepaintBoundary` tách '
          'phần đó ra 1 layer RIÊNG - phần còn lại của màn hình không bị '
          'vẽ lại theo, giảm tải cho GPU.',
      snippet: '''
Column(
  children: [
    const ExpensiveStaticContent(), // KHÔNG đổi, không cần cách ly
    RepaintBoundary(
      child: AnimatedRotatingIcon(), // đổi liên tục -> cách ly riêng 1 layer
    ),
  ],
)''',
      preview: (_) => const _RepaintBoundaryDemo(),
    ),
    CheatsheetEntry(
      name: 'DevTools - đo rebuild/frame thật',
      category: 'Công cụ đo',
      description:
          'Đừng ĐOÁN app chậm ở đâu - mở Flutter DevTools (tab '
          '"Performance"/"Widget Inspector"): "Track widget rebuilds" tô '
          'màu widget nào rebuild MỖI frame (rebuild quá nhiều = nghi '
          'vấn đầu tiên), "Timeline" cho thấy frame nào vượt 16ms (dấu '
          'hiệu giật/lag). Không có cách nào thay thế việc ĐO THẬT bằng '
          'DevTools.',
      snippet: '''
# Chạy app ở debug mode rồi mở DevTools:
flutter run
# Terminal in ra link dạng:
# The Flutter DevTools debugger... is available at: http://127.0.0.1:.../devtools

# Trong DevTools:
# - Bật "Track widget rebuilds" (Performance tab) để xem widget nào rebuild
# - Xem "Timeline" để tìm frame > 16ms (mục tiêu 60fps)''',
      preview: (_) => const _DevToolsDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'Performance cheat sheet',
      intro:
          '3 mục đầu demo chạy THẬT (đếm build() thực sự) để thấy rõ '
          'khác biệt. DevTools là công cụ ngoài app, chỉ minh hoạ tĩnh.',
      items: _items,
    );
  }
}

class _ConstChild extends StatelessWidget {
  const _ConstChild();

  static int builds = 0;

  @override
  Widget build(BuildContext context) {
    builds++;
    return Text('const Text: build() đã gọi $builds lần', style: const TextStyle(fontSize: 11));
  }
}

class _NonConstChild extends StatelessWidget {
  const _NonConstChild();

  static int builds = 0;

  @override
  Widget build(BuildContext context) {
    builds++;
    return Text('Text (không const): build() đã gọi $builds lần', style: const TextStyle(fontSize: 11));
  }
}

class _ConstRebuildDemo extends StatefulWidget {
  const _ConstRebuildDemo();

  @override
  State<_ConstRebuildDemo> createState() => _ConstRebuildDemoState();
}

class _ConstRebuildDemoState extends State<_ConstRebuildDemo> {
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    _ConstChild.builds = 0;
    _NonConstChild.builds = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _ConstChild(),
        _NonConstChild(), // CỐ Ý không const để so sánh
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: () => setState(() => _tick++),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: Text('Rebuild widget cha ($_tick lần)', style: const TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

class _LazyRow extends StatefulWidget {
  final int index;
  final VoidCallback onBuilt;

  const _LazyRow({required this.index, required this.onBuilt});

  @override
  State<_LazyRow> createState() => _LazyRowState();
}

class _LazyRowState extends State<_LazyRow> {
  @override
  void initState() {
    super.initState();
    // Báo "đã build" đúng 1 lần khi item này THỰC SỰ được tạo ra (không
    // phải mỗi lần rebuild) - đặt trong initState là chuẩn cho mục đích này.
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onBuilt());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.indigo.shade50,
      child: Text('Item ${widget.index}', style: const TextStyle(fontSize: 11)),
    );
  }
}

class _LazyBuildDemo extends StatefulWidget {
  const _LazyBuildDemo();

  @override
  State<_LazyBuildDemo> createState() => _LazyBuildDemoState();
}

class _LazyBuildDemoState extends State<_LazyBuildDemo> {
  static const _total = 60;
  final Set<int> _builtIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Đã build: ${_builtIndexes.length} / $_total item', style: const TextStyle(fontSize: 11)),
        const SizedBox(height: 4),
        SizedBox(
          width: 160,
          height: 90,
          child: ListView.builder(
            itemCount: _total,
            itemBuilder: (context, index) => _LazyRow(
              index: index,
              onBuilt: () {
                if (_builtIndexes.add(index) && mounted) setState(() {});
              },
            ),
          ),
        ),
        const CheatsheetHint('Cuộn xuống để thấy số item đã build tăng theo'),
      ],
    );
  }
}

class _RepaintBoundaryDemo extends StatefulWidget {
  const _RepaintBoundaryDemo();

  @override
  State<_RepaintBoundaryDemo> createState() => _RepaintBoundaryDemoState();
}

class _RepaintBoundaryDemoState extends State<_RepaintBoundaryDemo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  bool _isolated = true;
  bool _playing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _playing = !_playing);
    if (_playing) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final spinner = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * 3.14159,
        child: const Icon(Icons.refresh, size: 28, color: Colors.deepOrange),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _isolated ? RepaintBoundary(child: spinner) : spinner,
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          children: [
            const Text('RepaintBoundary:', style: TextStyle(fontSize: 11)),
            Switch(value: _isolated, onChanged: (v) => setState(() => _isolated = v)),
            OutlinedButton(
              onPressed: _togglePlay,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: Text(_playing ? 'Dừng' : 'Chạy', style: const TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const CheatsheetHint('Có/không RepaintBoundary nhìn giống nhau - khác biệt là ở layer GPU (xem DevTools)'),
      ],
    );
  }
}

class _DevToolsDemo extends StatelessWidget {
  const _DevToolsDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.speed, size: 36, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        const Text('flutter run -> mở link DevTools ở terminal', style: TextStyle(fontSize: 11)),
      ],
    );
  }
}
