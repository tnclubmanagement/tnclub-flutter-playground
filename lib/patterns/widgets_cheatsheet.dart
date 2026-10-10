import 'package:flutter/material.dart';

/// Trang tổng hợp (cheat sheet) dạng BẢNG các widget hay dùng nhất, liệt kê
/// nhanh: hình minh hoạ (render thật), constructor mẫu, dùng để làm gì, và
/// đặc điểm riêng (có padding/margin/background sẵn không, có cuộn được
/// không, cần ancestor gì...) - những thứ hay phải tra lại khi mới học.
///
/// Khác với các cheat sheet khác (chỉ có code mẫu dạng text), trang này
/// RENDER THẬT 1 ví dụ nhỏ cho mỗi widget (cột "Minh hoạ") để thấy ngay hình
/// dạng, không chỉ đọc mô tả.
class WidgetsCheatsheet extends StatelessWidget {
  const WidgetsCheatsheet({super.key});

  static final _rows = <_WidgetInfo>[
    // ---- Layout (sắp xếp vị trí/kích thước) ----
    _WidgetInfo(
      name: 'Container',
      category: 'Layout',
      constructor: 'Container(padding, margin, decoration, child)',
      usage: 'Khung đa năng: vừa trang trí (màu/bo góc/border/đổ bóng) vừa '
          'canh khoảng cách, thường dùng khi cần NHIỀU thứ cùng lúc trên '
          '1 widget.',
      special: 'CÓ padding + margin sẵn. CÓ background (qua color HOẶC '
          'decoration, KHÔNG dùng chung được 2 cái).',
      preview: (_) => Container(
        width: 64,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
        ),
        alignment: Alignment.center,
        child: const Text('Box', style: TextStyle(fontSize: 11)),
      ),
    ),
    _WidgetInfo(
      name: 'Padding',
      category: 'Layout',
      constructor: 'Padding(padding: EdgeInsets.all(8), child: ...)',
      usage: 'Thêm khoảng đệm quanh 1 widget KHÔNG có padding riêng (Text, '
          'Icon, ElevatedButton...).',
      special: 'CHỈ có padding. Không màu/border/margin.',
      preview: (_) => Container(
        color: Colors.orange.shade100,
        padding: const EdgeInsets.all(8),
        child: Container(width: 30, height: 20, color: Colors.deepPurple),
      ),
    ),
    _WidgetInfo(
      name: 'SizedBox',
      category: 'Layout',
      constructor: 'SizedBox(width: 100, height: 40, child: ...)',
      usage: 'Ép kích thước cố định cho child, HOẶC tạo khoảng trống rỗng '
          'thay cho Container rỗng.',
      special: 'Không padding/margin/màu. width/height: double.infinity để '
          'lấp đầy theo trục đó.',
      preview: (_) => Container(
        width: 60,
        height: 32,
        color: Colors.teal.shade200,
        alignment: Alignment.center,
        child: const Text('60x32', style: TextStyle(fontSize: 9)),
      ),
    ),
    _WidgetInfo(
      name: 'Center / Align',
      category: 'Layout',
      constructor: 'Align(alignment: Alignment.topRight, child: ...)',
      usage: 'Canh vị trí child trong không gian cha. Center = canh giữa '
          'cả 2 trục. Align = canh theo Alignment tuỳ chỉnh.',
      special: 'Không padding/màu. Cha phải có kích thước xác định.',
      preview: (_) => Container(
        width: 64,
        height: 44,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: const Align(
          alignment: Alignment.topRight,
          child: _Dot(color: Colors.red),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Row / Column',
      category: 'Layout',
      constructor: 'Row(mainAxisAlignment, crossAxisAlignment, children: [...])',
      usage: 'Sắp nhiều widget theo 1 trục: Row = ngang, Column = dọc. '
          'Widget layout CƠ BẢN nhất.',
      special: 'Không padding/margin/màu. Tràn nếu children vượt quá '
          'không gian -> cần Expanded/Flexible hoặc bọc scroll.',
      preview: (_) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final c in [Colors.red, Colors.green, Colors.blue])
            Container(
              width: 14,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: c.shade200,
            ),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'Stack + Positioned',
      category: 'Layout',
      constructor: 'Stack(children: [..., Positioned(top: 0, right: 0, child: ...)])',
      usage: 'Chồng nhiều widget LÊN NHAU (layer), Positioned định vị '
          'tuyệt đối theo top/bottom/left/right.',
      special: 'Mặc định CẮT phần tràn ra ngoài - cần Clip.none nếu muốn '
          'Positioned tràn ra ngoài Stack.',
      preview: (_) => SizedBox(
        width: 60,
        height: 40,
        child: Stack(
          children: [
            Container(color: Colors.blueGrey.shade100),
            const Positioned(top: 2, right: 2, child: _Dot(color: Colors.red, size: 10)),
          ],
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Expanded / Flexible',
      category: 'Layout',
      constructor: 'Expanded(flex: 1, child: ...)',
      usage: 'CHỈ dùng được làm con trực tiếp của Row/Column. Chiếm hết '
          'khoảng còn lại theo tỉ lệ flex.',
      special: 'Expanded = Flexible(fit: FlexFit.tight).',
      preview: (_) => SizedBox(
        width: 70,
        height: 20,
        child: Row(
          children: [
            Expanded(flex: 1, child: Container(color: Colors.indigo.shade200)),
            Expanded(flex: 2, child: Container(color: Colors.indigo.shade400)),
          ],
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Wrap',
      category: 'Layout',
      constructor: 'Wrap(spacing: 8, runSpacing: 8, children: [...])',
      usage: 'Giống Row nhưng TỰ XUỐNG DÒNG khi hết chỗ ngang, tránh lỗi '
          'overflow.',
      special: 'spacing = khoảng NGANG cùng dòng, runSpacing = khoảng GIỮA '
          'các dòng.',
      preview: (_) => SizedBox(
        width: 60,
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (var i = 0; i < 6; i++)
              Container(width: 14, height: 14, color: Colors.green.shade200),
          ],
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Spacer',
      category: 'Layout',
      constructor: 'Spacer(flex: 1)',
      usage: 'Chiếm khoảng trống linh hoạt trong Row/Column để đẩy các '
          'widget khác ra 2 đầu.',
      special: 'Tương đương Expanded(child: SizedBox()).',
      preview: (_) => const SizedBox(
        width: 70,
        height: 16,
        child: Row(
          children: [
            _Dot(color: Colors.blue, size: 12),
            Spacer(),
            _Dot(color: Colors.blue, size: 12),
          ],
        ),
      ),
    ),
    // ---- Cuộn (Scroll) ----
    _WidgetInfo(
      name: 'ListView.builder',
      category: 'Cuộn (Scroll)',
      constructor: 'ListView.builder(itemCount: n, itemBuilder: (ctx, i) => ...)',
      usage: 'Danh sách CUỘN được, builder chỉ tạo widget cho item ĐANG '
          'HIỂN THỊ (lazy) - hiệu quả với list dài.',
      special: 'Tự co hết không gian cha cấp (cần Expanded trong Column).',
      preview: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++)
            Container(
              width: 70,
              height: 10,
              margin: const EdgeInsets.symmetric(vertical: 1.5),
              color: Colors.grey.shade300,
            ),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'GridView.builder',
      category: 'Cuộn (Scroll)',
      constructor: 'GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: ...)',
      usage: 'Lưới item cuộn được, nhiều cột/hàng - thường dùng cho grid '
          'sản phẩm/ảnh.',
      special: 'gridDelegate quyết định số cột (fixed) hoặc kích thước tối '
          'đa mỗi ô.',
      preview: (_) => SizedBox(
        width: 44,
        height: 44,
        child: GridView.count(
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: [
            for (final c in [Colors.purple, Colors.pink, Colors.amber, Colors.cyan])
              Container(color: c.shade200),
          ],
        ),
      ),
    ),
    _WidgetInfo(
      name: 'SingleChildScrollView',
      category: 'Cuộn (Scroll)',
      constructor: 'SingleChildScrollView(child: Column(children: [...]))',
      usage: 'Cho phép CUỘN khi nội dung vượt quá chiều cao màn hình, tránh '
          '"RenderFlex overflowed".',
      special: 'KHÔNG lazy (build hết toàn bộ child 1 lần) - list rất dài '
          'nên dùng ListView.',
      preview: (_) => const Icon(Icons.swap_vert_circle_outlined, size: 32, color: Colors.grey),
    ),
    // ---- Hiển thị nội dung ----
    _WidgetInfo(
      name: 'Text',
      category: 'Hiển thị nội dung',
      constructor: "Text('Nội dung', style: TextStyle(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis)",
      usage: 'Hiển thị chữ. maxLines + overflow: ellipsis để cắt "..." khi '
          'chữ dài tràn dòng.',
      special: 'KHÔNG có màu/padding riêng - màu chữ phải nằm trong '
          '`style: TextStyle(color: ...)`.',
      preview: (_) => const Text('Aa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    ),
    _WidgetInfo(
      name: 'Icon',
      category: 'Hiển thị nội dung',
      constructor: 'Icon(Icons.favorite, size: 24, color: Colors.red)',
      usage: 'Hiển thị icon có sẵn trong Material Icons.',
      special: 'size/color set trực tiếp trên Icon, không cần style riêng.',
      preview: (_) => const Icon(Icons.favorite, size: 32, color: Colors.red),
    ),
    _WidgetInfo(
      name: 'Image',
      category: 'Hiển thị nội dung',
      constructor: "Image.network(url, fit: BoxFit.cover)",
      usage: 'Hiển thị ảnh từ network/asset/memory/file. `fit` quyết định '
          'ảnh co/cắt thế nào khi khung khác tỉ lệ ảnh gốc.',
      special: 'Cần set width/height nếu không muốn ảnh tự co theo kích '
          'thước gốc.',
      preview: (_) => Container(
        width: 44,
        height: 44,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image, color: Colors.white),
      ),
    ),
    _WidgetInfo(
      name: 'CircleAvatar',
      category: 'Hiển thị nội dung',
      constructor: 'CircleAvatar(radius: 32, backgroundImage: NetworkImage(url))',
      usage: 'Avatar tròn - ảnh đại diện user, hoặc fallback hiển thị chữ '
          '(initials) khi chưa có ảnh.',
      special: 'radius quyết định kích thước (đường kính = radius * 2).',
      preview: (_) => const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.deepPurple,
        child: Text('T', style: TextStyle(color: Colors.white)),
      ),
    ),
    _WidgetInfo(
      name: 'Card',
      category: 'Hiển thị nội dung',
      constructor: 'Card(elevation: 2, margin: EdgeInsets.all(8), child: ...)',
      usage: 'Khung "thẻ" Material: nền trắng, bo góc, đổ bóng sẵn - hay '
          'dùng làm item trong list/grid.',
      special: 'CÓ margin mặc định, nhưng KHÔNG CÓ padding sẵn.',
      preview: (_) => const Card(
        elevation: 3,
        margin: EdgeInsets.zero,
        child: SizedBox(width: 60, height: 34),
      ),
    ),
    _WidgetInfo(
      name: 'Divider',
      category: 'Hiển thị nội dung',
      constructor: 'Divider(height: 1, thickness: 1, color: Colors.grey)',
      usage: 'Đường kẻ ngang phân chia nội dung (VerticalDivider = kẻ '
          'dọc).',
      special: '`height` là khoảng không gian TỔNG, độ dày thật là '
          '`thickness`.',
      preview: (_) => const SizedBox(
        width: 70,
        child: Divider(thickness: 2, color: Colors.deepPurple),
      ),
    ),
    // ---- Trang trí / cắt hình ----
    _WidgetInfo(
      name: 'ClipRRect / ClipOval',
      category: 'Trang trí / Cắt hình',
      constructor: 'ClipRRect(borderRadius: BorderRadius.circular(12), child: ...)',
      usage: 'Cắt child theo hình bo góc hoặc tròn/oval - hay dùng bo góc '
          'cho Image (Image không có borderRadius riêng).',
      special: 'Chỉ cắt HIỂN THỊ, không đổi kích thước/layout thật.',
      preview: (_) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(width: 40, height: 40, color: Colors.amber),
      ),
    ),
    _WidgetInfo(
      name: 'DecoratedBox',
      category: 'Trang trí / Cắt hình',
      constructor: 'DecoratedBox(decoration: BoxDecoration(...), child: ...)',
      usage: 'Giống phần "decoration" của Container nhưng KHÔNG có '
          'padding/margin/constraints.',
      special: 'Không padding/margin - chỉ vẽ decoration quanh child.',
      preview: (_) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.pink, Colors.orange]),
        ),
        child: const SizedBox(width: 56, height: 32),
      ),
    ),
    // ---- Input & tương tác ----
    _WidgetInfo(
      name: 'ElevatedButton / TextButton / OutlinedButton',
      category: 'Input & tương tác',
      constructor: 'ElevatedButton(onPressed: () {}, child: Text("Xác nhận"))',
      usage: 'Nút bấm Material. Elevated = nổi (hành động chính). Text = '
          'phẳng. Outlined = có viền, không nền.',
      special: 'onPressed: null -> nút tự disabled (mờ, không bấm được).',
      preview: (_) => ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          textStyle: const TextStyle(fontSize: 12),
        ),
        child: const Text('OK'),
      ),
    ),
    _WidgetInfo(
      name: 'IconButton',
      category: 'Input & tương tác',
      constructor: 'IconButton(icon: Icon(Icons.close), onPressed: () {})',
      usage: 'Nút chỉ chứa icon - có vùng bấm lớn hơn kích thước icon hiển '
          'thị để dễ bấm trên mobile.',
      special: 'Có padding mặc định quanh icon, không cần tự bọc Padding.',
      preview: (_) => IconButton(
        onPressed: () {},
        icon: const Icon(Icons.close),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    ),
    _WidgetInfo(
      name: 'TextField',
      category: 'Input & tương tác',
      constructor: 'TextField(controller: ..., decoration: InputDecoration(labelText: "Email"))',
      usage: 'Ô nhập liệu text. `controller` đọc/set giá trị từ code, '
          '`decoration` set label/hint/icon/viền.',
      special: 'obscureText: true để ẩn chữ. Cần dispose() controller để '
          'tránh leak.',
      preview: (_) => const SizedBox(
        width: 90,
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          style: TextStyle(fontSize: 12),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Checkbox / Switch / Radio',
      category: 'Input & tương tác',
      constructor: 'Checkbox(value: checked, onChanged: (v) => setState(() => checked = v!))',
      usage: 'Chọn boolean/lựa chọn. Checkbox/Switch = on-off. Radio = '
          'chọn 1 trong nhiều (cùng `groupValue`).',
      special: 'Widget "có điều khiển" - PHẢI tự lưu state và cập nhật '
          'trong onChanged.',
      preview: (_) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: true, onChanged: (_) {}),
          Transform.scale(
            scale: 0.8,
            child: Switch(value: true, onChanged: (_) {}),
          ),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'GestureDetector / InkWell',
      category: 'Input & tương tác',
      constructor: 'InkWell(onTap: () {}, child: ...)',
      usage: 'Bắt cử chỉ chạm cho widget KHÔNG có sẵn onTap (Container, '
          'Text, Image...).',
      special: 'InkWell có hiệu ứng "ripple" nhưng CẦN Material ancestor, '
          'nếu không dùng GestureDetector (không hiệu ứng).',
      preview: (_) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 50,
            height: 30,
            alignment: Alignment.center,
            color: Colors.blue.shade100,
            child: const Text('Tap', style: TextStyle(fontSize: 11)),
          ),
        ),
      ),
    ),
    // ---- Cấu trúc trang ----
    _WidgetInfo(
      name: 'Scaffold',
      category: 'Cấu trúc trang',
      constructor: 'Scaffold(appBar: AppBar(...), body: ..., floatingActionButton: ...)',
      usage: 'Khung trang chuẩn Material: tự xử lý vị trí AppBar/body/FAB/'
          'BottomNavigationBar/Drawer.',
      special: 'body tự tránh vùng bị AppBar che, nhưng KHÔNG tự tránh '
          'notch/status bar - cần SafeArea.',
      preview: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 70, height: 12, color: Colors.deepPurple),
          Container(width: 70, height: 30, color: Colors.grey.shade200),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'AppBar',
      category: 'Cấu trúc trang',
      constructor: 'AppBar(title: Text("Trang chủ"), actions: [IconButton(...)])',
      usage: 'Thanh tiêu đề trên cùng, dùng làm `appBar:` của Scaffold.',
      special: 'Chiều cao cố định (kToolbarHeight), tự thêm padding tránh '
          'status bar.',
      preview: (_) => Container(
        width: 70,
        height: 18,
        color: Colors.deepPurple,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: const Text(
          'AppBar',
          style: TextStyle(color: Colors.white, fontSize: 9),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'SafeArea',
      category: 'Cấu trúc trang',
      constructor: 'SafeArea(child: ...)',
      usage: 'Tự thêm padding tránh các vùng "không an toàn" của thiết bị '
          '(notch, status bar, home indicator...).',
      special: 'Chỉ cần bọc NGOÀI CÙNG 1 lần gần root, không cần lồng '
          'nhiều lớp.',
      preview: (_) => const Icon(Icons.phone_iphone, size: 32, color: Colors.grey),
    ),
  ];

  static List<String> get _categories =>
      _rows.map((r) => r.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Widget cheat sheet'),
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
              _WidgetTable(rows: _rows),
              ..._categories.map(
                (c) => _WidgetTable(
                  rows: _rows.where((r) => r.category == c).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WidgetInfo {
  final String name;
  final String category;
  final String constructor;
  final String usage;
  final String special;
  final WidgetBuilder preview;

  const _WidgetInfo({
    required this.name,
    required this.category,
    required this.constructor,
    required this.usage,
    required this.special,
    required this.preview,
  });
}

/// Bảng nhiều cột dùng [Table] (tự tính chiều cao mỗi dòng theo nội dung,
/// không cần tự quản chiều cao như Row thường). Bọc 2 lớp scroll: NGANG khi
/// tổng chiều rộng cột vượt màn hình hẹp, DỌC khi danh sách dài hơn chiều
/// cao khả dụng - thiếu 1 trong 2 là nguyên nhân hay gặp gây
/// "RenderFlex overflowed".
class _WidgetTable extends StatelessWidget {
  final List<_WidgetInfo> rows;

  const _WidgetTable({required this.rows});

  static const _colWidths = <int, TableColumnWidth>{
    0: FixedColumnWidth(96), // Minh hoạ
    1: FixedColumnWidth(170), // Widget
    2: FixedColumnWidth(260), // Constructor mẫu
    3: FixedColumnWidth(260), // Dùng để làm gì
    4: FixedColumnWidth(260), // Đặc điểm riêng
  };

  static const _headers = ['Minh hoạ', 'Widget', 'Constructor mẫu', 'Dùng để làm gì', 'Đặc điểm riêng'];

  @override
  Widget build(BuildContext context) {
    final totalWidth = _colWidths.values
        .map((w) => (w as FixedColumnWidth).value)
        .reduce((a, b) => a + b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      // Cuộn DỌC - thiếu lớp này thì nội dung dài sẽ bị overflow.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // Cuộn NGANG khi màn hình hẹp hơn tổng chiều rộng cột.
        child: SizedBox(
          width: totalWidth,
          child: Table(
            columnWidths: _colWidths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.08),
                ),
                children: [
                  for (final h in _headers) _cell(h, isHeader: true),
                ],
              ),
              for (final r in rows)
                TableRow(
                  children: [
                    _previewCell(r.preview),
                    _cell(r.name, bold: true),
                    _cell(r.constructor, monospace: true),
                    _cell(r.usage),
                    _cell(r.special),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cell(String text, {bool isHeader = false, bool bold = false, bool monospace = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        text,
        style: isHeader
            ? const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)
            : TextStyle(
                fontFamily: monospace ? 'monospace' : null,
                fontSize: monospace ? 12.5 : 14,
                fontWeight: bold ? FontWeight.w600 : null,
              ),
      ),
    );
  }

  Widget _previewCell(WidgetBuilder preview) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: SizedBox(
          width: 80,
          height: 56,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Builder(builder: preview),
          ),
        ),
      ),
    );
  }
}

/// Chấm tròn nhỏ dùng làm "đánh dấu vị trí" trong vài hình minh hoạ
/// (Align/Stack/Spacer) cho gọn, khỏi lặp lại Container(decoration: ...).
class _Dot extends StatelessWidget {
  final Color color;
  final double size;

  const _Dot({required this.color, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
