import 'package:flutter/material.dart';

import '../app_constants.dart';
import 'glass_panel.dart';

/// Khối "Giới thiệu" ở đầu vùng nội dung chính: app này là gì, dùng để làm
/// gì, và gợi ý thứ tự học - để người mới mở app không bị "rơi" thẳng vào
/// 1 danh sách dài không biết bắt đầu từ đâu.
class IntroSection extends StatelessWidget {
  const IntroSection({super.key});

  Widget _step(BuildContext context, String text, Color dotColor) => Padding(
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
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Kính mờ (Liquid Glass) - thay cho gradient 3 màu (tím/xám/vàng) cũ
    // vốn trộn vào nhau nhìn đục, chói. Đồng bộ với sidebar/section panel
    // đã dùng [GlassPanel], để lộ khối màu nền phía sau (BackgroundBlobs)
    // thay vì TỰ áp 1 màu nền chói riêng.
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👋 Flutter Layout Playground',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nơi luyện layout/UI Flutter qua demo chạy thật kèm source code, '
            'bài tập Examples có đáp án, các Pattern tổ chức code hay gặp, và '
            'một bộ Cheat Sheet tra cứu nhanh (widget, Dart syntax, animation, '
            'API, auth, testing, performance, môi trường & FVM...).',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Text(
            'Gợi ý thứ tự học:',
            style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface),
          ),
          const SizedBox(height: 4),
          _step(
            context,
            '1. Demos - nắm widget layout cơ bản (Row/Column/Stack/ListView...)',
            kSectionAccent['Demos']!,
          ),
          _step(
            context,
            '2. Examples - tự làm bài tập layout UI thực tế, đối chiếu đáp án',
            kSectionAccent['Examples']!,
          ),
          _step(
            context,
            '3. Patterns & Cheat Sheet - tra cứu khi cần, không cần học hết 1 lần',
            kSectionAccent['Cheat Sheet']!,
          ),
          const SizedBox(height: 8),
          Text(
            '💡 Dùng ô tìm kiếm/tag ở sidebar bên trái (hoặc mở menu ☰ nếu màn '
            'hình hẹp) để lọc nhanh theo chủ đề.',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
