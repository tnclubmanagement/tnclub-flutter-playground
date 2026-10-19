import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_constants.dart';
import 'home_page.dart';

/// Thay cho dải "bento block" rời rạc + vòng tròn "% đang hiện" TÁCH RIÊNG
/// (2 biểu đồ tròn cạnh nhau nhìn trùng lặp) - giờ GỘP LÀM 1 THẺ DUY NHẤT:
/// biểu đồ donut thể hiện TỶ LỆ số trang giữa các nhóm, kèm chú giải (tên
/// nhóm + số trang) bên dưới. Phần GIỮA donut hiện "$shown/$total" (thay
/// cho vòng tròn % cũ) để vẫn biết đang lọc còn bao nhiêu trang so với
/// tổng.
///
/// LUÔN xếp DỌC (biểu đồ trên, chú giải dưới) - không tự đổi ngang/dọc
/// theo bề rộng nữa: widget này giờ chỉ dùng trong 1 cột HẸP cạnh
/// [IntroSection] (xem `main_content.dart`), và quan trọng hơn - cột đó
/// còn bị bọc `IntrinsicHeight` để ép cao bằng Intro, mà `IntrinsicHeight`
/// KHÔNG tương thích với `LayoutBuilder` bên trong subtree của nó (lỗi
/// "LayoutBuilder does not support returning intrinsic dimensions") - nên
/// phải bỏ hẳn LayoutBuilder, chọn CỐ ĐỊNH 1 cách trình bày.
///
/// Tỷ lệ các lát donut luôn tính theo TỔNG số trang THẬT (không theo kết
/// quả đang lọc) để làm điểm tham chiếu ổn định, không nhảy lung tung
/// theo search/tag - chỉ số "$shown/$total" ở giữa mới phản ánh bộ lọc.
class StatStrip extends StatelessWidget {
  final int shown;

  const StatStrip({super.key, required this.shown});

  static const _items = [
    ('Môi trường & Công cụ', Symbols.build),
    ('Demos', Symbols.widgets),
    ('Examples', Symbols.assignment),
    ('Patterns', Symbols.extension),
    ('Cheat Sheet', Symbols.menu_book),
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
    final cs = Theme.of(context).colorScheme;
    final counts = [for (final (title, _) in _items) _countFor(title)];
    final total = counts.fold<int>(0, (a, b) => a + b);
    final slices = [
      for (var i = 0; i < _items.length; i++)
        (kSectionAccent[_items[i].$1]!, counts[i]),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DonutChart(slices: slices, shown: shown, total: total, size: 140),
          const SizedBox(height: 16),
          _Legend(items: _items, counts: counts),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final List<(String, IconData)> items;
  final List<int> counts;

  const _Legend({required this.items, required this.counts});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Tổng quan nội dung',
          style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: kSectionAccent[items[i].$1],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(items[i].$2, size: 14, color: cs.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    items[i].$1,
                    style: TextStyle(fontSize: 13, color: cs.onSurface),
                  ),
                ),
                Text(
                  '${counts[i]}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: kSectionAccent[items[i].$1],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DonutChart extends StatelessWidget {
  final List<(Color, int)> slices;
  final int shown;
  final int total;
  final double size;

  const _DonutChart({
    required this.slices,
    required this.shown,
    required this.total,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Lọc hết -> hiện "38/38"; đang lọc bớt -> "12/38" để vẫn biết tỷ lệ
    // đang hiện so với tổng (thay cho vòng tròn % riêng trước đây).
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutChartPainter(slices: slices, total: total),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$shown/$total',
                style: TextStyle(
                  fontSize: size * 0.17,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              Text(
                'trang đang hiện',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size * 0.075, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vẽ biểu đồ donut bằng [Canvas.drawArc] - mỗi nhóm 1 cung tròn dày, độ
/// dài cung tỷ lệ với số trang của nhóm đó / tổng, có khoảng hở nhỏ giữa
/// các cung để tách bạch rõ từng nhóm (thay vì dính liền 1 khối tròn).
class _DonutChartPainter extends CustomPainter {
  final List<(Color, int)> slices;
  final int total;

  _DonutChartPainter({required this.slices, required this.total});

  static const _gap = 0.05; // radian

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0) return;
    final strokeWidth = size.shortestSide * 0.22;
    final radius = (size.shortestSide - strokeWidth) / 2;
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);

    var startAngle = -pi / 2;
    for (final (color, count) in slices) {
      if (count <= 0) continue;
      final sweep = (count / total) * (2 * pi) - _gap;
      if (sweep <= 0) continue;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep + _gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      oldDelegate.slices != slices || oldDelegate.total != total;
}
