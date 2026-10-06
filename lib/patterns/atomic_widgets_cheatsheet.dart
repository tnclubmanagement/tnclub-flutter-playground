import 'package:flutter/material.dart';

import '../widgets/code_panel.dart';

/// Trang tổng hợp (cheat sheet) các khái niệm "nguyên tử" hay dùng nhất khi
/// làm layout: BoxDecoration, BoxShape, BoxShadow, TextStyle,
/// MainAxisAlignment/CrossAxisAlignment, Positioned, Clip...
///
/// Đây CHỈ là trang thông tin tĩnh (giống LibrariesPage): code mẫu bên dưới
/// minh hoạ cú pháp/cách dùng, không chạy thật trong app này.
class AtomicWidgetsCheatsheet extends StatelessWidget {
  const AtomicWidgetsCheatsheet({super.key});

  static const _items = [
    _AtomicInfo(
      name: 'BoxDecoration',
      category: 'Trang trí',
      description:
          'Gộp màu nền, viền, bo góc, gradient, đổ bóng (boxShadow)... vào '
          '1 chỗ, gán cho decoration của Container. Dùng thay cho color '
          'trực tiếp khi cần nhiều hiệu ứng cùng lúc (color trực tiếp và '
          'decoration KHÔNG dùng chung được).',
      snippet: '''
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  ),
)''',
    ),
    _AtomicInfo(
      name: 'BoxShape',
      category: 'Trang trí',
      description:
          'Hình dạng của BoxDecoration: rectangle (mặc định) hoặc circle. '
          'Dùng circle để có hình tròn hoàn hảo mà không cần tự tính '
          'borderRadius theo kích thước - rất tiện cho viền tròn quanh '
          'avatar.',
      snippet: '''
Container(
  width: 72,
  height: 72,
  decoration: const BoxDecoration(
    shape: BoxShape.circle, // không cần borderRadius
    color: Colors.white,
  ),
  child: const CircleAvatar(radius: 32),
)''',
    ),
    _AtomicInfo(
      name: 'BoxShadow',
      category: 'Trang trí',
      description:
          'Đổ bóng cho 1 Box (đặt trong boxShadow của BoxDecoration). '
          'offset lệch bóng theo hướng nào, blurRadius làm bóng mờ dần - '
          'kết hợp 2 cái tạo cảm giác "nổi" (3D) cho card/avatar.',
      snippet: '''
BoxShadow(
  color: Colors.black.withValues(alpha: 0.2),
  blurRadius: 8,      // độ mờ lan ra
  spreadRadius: 1,     // độ "phình" trước khi mờ
  offset: const Offset(0, 3), // lệch xuống dưới 3px
)''',
    ),
    _AtomicInfo(
      name: 'TextStyle',
      category: 'Chữ',
      description:
          'Toàn bộ style của Text nằm trong đây: color, fontSize, '
          'fontWeight, fontStyle (italic)... Text KHÔNG có tham số color/ '
          'padding/margin riêng - color chữ luôn phải nằm trong style.',
      snippet: '''
Text(
  'Ngo Minh Tri',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
)''',
    ),
    _AtomicInfo(
      name: 'MainAxisAlignment / CrossAxisAlignment',
      category: 'Căn chỉnh',
      description:
          'MainAxisAlignment canh theo trục CHÍNH của Row/Column (ngang với '
          'Row, dọc với Column): start/end/center/spaceBetween/spaceAround/'
          'spaceEvenly. CrossAxisAlignment canh theo trục PHỤ (vuông góc).',
      snippet: '''
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // trục ngang
  crossAxisAlignment: CrossAxisAlignment.center,    // trục dọc
  children: [Text('Bài viết'), Text('Followers'), Text('Following')],
)''',
    ),
    _AtomicInfo(
      name: 'Positioned + Clip',
      category: 'Định vị / Cắt hình',
      description:
          'Positioned định vị tuyệt đối theo top/bottom/left/right BÊN '
          'TRONG 1 Stack. Khi cần phần tử tràn ra ngoài Stack (ví dụ '
          'avatar đè mép dưới cover), phải set clipBehavior: Clip.none '
          'trên Stack, nếu không nó sẽ tự cắt mất phần tràn.',
      snippet: '''
Stack(
  clipBehavior: Clip.none, // cho phép tràn ra ngoài Stack
  children: [
    Container(height: 100, color: Colors.blueGrey.shade100),
    Positioned(
      bottom: -32, // tràn xuống dưới nửa đường kính avatar
      left: 0,
      right: 0,
      child: Center(child: CircleAvatar(radius: 32)),
    ),
  ],
)''',
    ),
    _AtomicInfo(
      name: 'Padding vs margin',
      category: 'Khoảng cách',
      description:
          'padding = khoảng đệm BÊN TRONG, có ở nhiều widget (Container, '
          'ElevatedButton.styleFrom, Padding...). margin = khoảng cách BÊN '
          'NGOÀI, CHỈ Container mới có sẵn - mọi widget khác (Text, Icon, '
          'ElevatedButton...) phải tự bọc bằng Padding để tạo hiệu ứng '
          'margin.',
      snippet: '''
// Widget không có margin (vd ElevatedButton) -> bọc Padding:
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: ElevatedButton(onPressed: () {}, child: const Text('Theo dõi')),
)

// Container thì có margin + padding sẵn:
Container(
  margin: const EdgeInsets.all(8),   // khoảng cách với widget xung quanh
  padding: const EdgeInsets.all(16), // khoảng đệm bên trong
  color: Colors.white,
)''',
    ),
    _AtomicInfo(
      name: 'SizedBox full-width trick',
      category: 'Kích thước',
      description:
          'Button/widget mặc định chỉ to vừa đủ nội dung (loose '
          'constraints). Bọc bằng SizedBox(width: double.infinity) để ép '
          'tight constraints, buộc widget con lấp đầy chiều ngang.',
      snippet: '''
SizedBox(
  width: double.infinity,
  height: 48,
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('Theo dõi'),
  ),
)''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atomic widgets cheat sheet')),
      body: SelectionArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Những khái niệm "nguyên tử" lặp đi lặp lại ở gần như mọi '
                  'layout Flutter. Nắm vững những cái này là ghép được phần '
                  'lớn UI thực tế.',
                ),
              );
            }
            return _AtomicCard(info: _items[index - 1]);
          },
        ),
      ),
    );
  }
}

class _AtomicInfo {
  final String name;
  final String category;
  final String description;
  final String snippet;

  const _AtomicInfo({
    required this.name,
    required this.category,
    required this.description,
    required this.snippet,
  });
}

class _AtomicCard extends StatelessWidget {
  final _AtomicInfo info;

  const _AtomicCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    info.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(info.category, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(info.description),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
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
