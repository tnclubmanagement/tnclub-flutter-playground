import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_constants.dart';
import 'home_page.dart';

/// Dải "bento block" màu đậm hiện tổng số trang theo mỗi nhóm - lấy cảm
/// hứng từ các ô thống kê màu nổi bật (vàng/xám/cam đất) trong ảnh tham
/// khảo. Luôn hiện TỔNG số trang thật (không theo kết quả đang lọc) để
/// làm điểm tham chiếu ổn định, không nhảy số theo search/tag.
class StatStrip extends StatelessWidget {
  final bool isWide;

  const StatStrip({super.key, required this.isWide});

  static const _items = [
    ('Demos', Symbols.widgets),
    ('Examples', Symbols.assignment),
    ('Patterns', Symbols.extension),
    ('Cheat Sheet', Symbols.menu_book),
    ('Môi trường & Công cụ', Symbols.build),
  ];

  static int _countFor(String title) => switch (title) {
    'Demos' => HomePage.demos.length,
    'Examples' => HomePage.examples.length,
    'Patterns' => HomePage.patterns.length,
    'Cheat Sheet' => HomePage.cheatSheets.length,
    _ => HomePage.environmentTools.length,
  };

  @override
  Widget build(BuildContext context) {
    final tiles = _items.map((item) {
      final (title, icon) = item;
      return StatTile(title: title, icon: icon, count: _countFor(title));
    }).toList();

    // Màn rộng: 4 ô giãn ĐỀU hết chiều ngang (Expanded), không còn width cố
    // định để trống khoảng thừa như trước. Màn hẹp: Wrap 2 ô/hàng vì 4
    // Expanded cạnh nhau sẽ quá chật.
    if (isWide) {
      // Mỗi StatTile đã tự set height:120 cố định rồi nên KHÔNG cần
      // IntrinsicHeight để ép bằng nhau (tránh đúng cạm bẫy tràn layout đã
      // gặp ở hero row trước đó).
      return Row(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            Expanded(child: tiles[i]),
          ],
        ],
      );
    }
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: tiles.map((t) => SizedBox(width: 160, child: t)).toList(),
    );
  }
}

class StatTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;

  const StatTile({
    super.key,
    required this.title,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final accent = kSectionAccent[title]!;
    // Chữ trên nền SOLID cần tương phản tốt - vàng (Cheat Sheet) sáng nên
    // dùng chữ đen, 3 màu còn lại tối hơn nên dùng chữ trắng.
    final onAccent = title == 'Cheat Sheet' ? Colors.black : Colors.white;
    return Container(
      width: double.infinity,
      height: 120,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // Icon THIN (outline) khổ lớn làm HÌNH NỀN mờ, ló ra góc dưới
          // phải - thay cho icon nhỏ rời rạc phía trên như bản cũ.
          Positioned(
            right: -14,
            bottom: -18,
            // weight: 150 - icon THẬT SỰ mảnh (Material Symbols cho phép
            // chỉnh độ dày nét 100-700, khác hẳn Icons mặc định của Flutter
            // vốn chỉ có 1 độ dày cố định không chỉnh được).
            child: Icon(
              icon,
              size: 110,
              weight: 150,
              color: onAccent.withValues(alpha: 0.22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: onAccent,
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: onAccent.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
