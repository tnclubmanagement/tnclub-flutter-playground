import 'package:flutter/material.dart';

import '../app_constants.dart';

/// Vòng tròn % (donut) - mô phỏng kiểu thẻ "27% Courses rated above 4.5"
/// trong ảnh tham khảo. Ở đây dùng cho con số thật của app: bao nhiêu % số
/// trang đang hiện ra khớp với search/tag đang lọc (100% khi không lọc gì).
class ProgressRingCard extends StatelessWidget {
  final int shown;
  final int total;

  const ProgressRingCard({super.key, required this.shown, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : shown / total;
    final accent = kSectionAccent['Patterns']!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          accent.withValues(alpha: 0.14),
          Theme.of(context).colorScheme.surface,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 7,
                    backgroundColor: accent.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation(accent),
                  ),
                ),
                Text(
                  '${(percent * 100).round()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$shown / $total trang đang hiện',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Theo bộ lọc search/tag hiện tại',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
