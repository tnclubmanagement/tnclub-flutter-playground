import 'package:flutter/material.dart';

import 'glass_panel.dart';
import 'section_header.dart';

/// Khung "panel" bo góc lớn bọc quanh mỗi section (Demos/Examples/Patterns/
/// Cheat Sheet) - để mỗi nhóm trông như 1 khối card RIÊNG BIỆT (giống các
/// panel tách bạch trong ảnh tham khảo) thay vì chỉ là tiêu đề + nội dung
/// trôi nổi liền mạch trên nền trang.
class SectionPanel extends StatelessWidget {
  final String title;
  final Color accent;
  final String? description;
  final Widget child;

  const SectionPanel({
    super.key,
    required this.title,
    required this.accent,
    required this.child,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassPanel(
        borderColor: accent.withValues(alpha: 0.18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title),
            if (description != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(description!),
              ),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}
