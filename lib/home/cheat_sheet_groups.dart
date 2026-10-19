import 'package:flutter/material.dart';

import '../models/layout_demo.dart';
import 'demo_grid.dart';
import 'section_header.dart';

/// Gom các [LayoutDemo] trong mục Cheat Sheet theo `group` (giữ đúng thứ
/// tự xuất hiện lần đầu của mỗi group trong list), mỗi group có 1 tiêu đề
/// phụ nhỏ (xem [SubSectionHeader]) rồi mới tới lưới thẻ của riêng nó.
/// Item không có `group` (null) được xếp chung vào 1 nhóm "Khác" ở cuối.
class CheatSheetGroups extends StatelessWidget {
  final List<LayoutDemo> cheatSheets;
  final bool isWide;
  final Color accent;

  const CheatSheetGroups({
    super.key,
    required this.cheatSheets,
    required this.isWide,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final groupOrder = <String>[];
    final byGroup = <String, List<LayoutDemo>>{};
    for (final demo in cheatSheets) {
      final group = demo.group ?? 'Khác';
      if (!byGroup.containsKey(group)) {
        groupOrder.add(group);
        byGroup[group] = [];
      }
      byGroup[group]!.add(demo);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groupOrder) ...[
          SubSectionHeader(group),
          const SizedBox(height: 8),
          DemoGrid(
            demos: byGroup[group]!,
            isWide: isWide,
            accent: accent,
            showIndex: true,
            chapterLabel: 'Chapter 2',
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
