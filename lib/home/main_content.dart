import 'package:flutter/material.dart';

import '../app_constants.dart';
import '../models/layout_demo.dart';
import 'cheat_sheet_groups.dart';
import 'demo_grid.dart';
import 'home_page.dart';
import 'intro_section.dart';
import 'progress_ring_card.dart';
import 'section_panel.dart';
import 'stat_strip.dart';

/// Toàn bộ vùng nội dung chính bên phải sidebar (hoặc TOÀN màn hình khi
/// hẹp, sidebar gấp vào Drawer): khối giới thiệu + các section đã lọc theo
/// search/tag hiện tại. Section nào lọc ra rỗng thì tự ẩn, không hiện tiêu
/// đề "trống trơn".
class MainContent extends StatelessWidget {
  final bool isWide;
  final List<LayoutDemo> demos;
  final List<LayoutDemo> examples;
  final List<LayoutDemo> patterns;
  final List<LayoutDemo> cheatSheets;
  final List<LayoutDemo> environmentTools;

  const MainContent({
    super.key,
    required this.isWide,
    required this.demos,
    required this.examples,
    required this.patterns,
    required this.cheatSheets,
    required this.environmentTools,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnyResult =
        demos.isNotEmpty ||
        examples.isNotEmpty ||
        patterns.isNotEmpty ||
        cheatSheets.isNotEmpty ||
        environmentTools.isNotEmpty;
    final shownCount =
        demos.length +
        examples.length +
        patterns.length +
        cheatSheets.length +
        environmentTools.length;
    final totalCount =
        HomePage.demos.length +
        HomePage.examples.length +
        HomePage.patterns.length +
        HomePage.cheatSheets.length +
        HomePage.environmentTools.length;

    // Hero: card giới thiệu (to) + vòng tròn % (nhỏ) nằm CẠNH NHAU như ảnh
    // tham khảo - trên màn hẹp thì xếp dọc lại (Column) cho vừa.
    //
    // CỐ Ý không dùng IntrinsicHeight để ép 2 card cao bằng nhau: nó tính
    // chiều cao "intrinsic" của Text theo 1 cách khác với lúc layout thật
    // (width bị bó hẹp bởi flex), lệch vài pixel là RenderFlex tràn ngay -
    // đây là 1 cạm bẫy kinh điển của IntrinsicHeight. Để mỗi card tự co
    // theo nội dung (align top) an toàn hơn, chấp nhận 2 card cao khác nhau.
    final hero = isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 2, child: IntroSection()),
              const SizedBox(width: 12),
              Expanded(
                child: ProgressRingCard(shown: shownCount, total: totalCount),
              ),
            ],
          )
        : Column(
            children: [
              const IntroSection(),
              const SizedBox(height: 12),
              ProgressRingCard(shown: shownCount, total: totalCount),
            ],
          );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hero,
        const SizedBox(height: 20),
        StatStrip(isWide: isWide),
        const SizedBox(height: 20),

        if (!hasAnyResult)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Không tìm thấy trang phù hợp - thử bỏ bớt từ khoá/tag đang lọc.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

        if (environmentTools.isNotEmpty)
          SectionPanel(
            title: 'Môi trường & Công cụ',
            accent: kSectionAccent['Môi trường & Công cụ']!,
            description:
                'Cài đặt máy, công cụ dòng lệnh và quản lý version Flutter '
                'theo project.',
            child: DemoGrid(
              demos: environmentTools,
              isWide: isWide,
              accent: kSectionAccent['Môi trường & Công cụ']!,
            ),
          ),
        if (cheatSheets.isNotEmpty)
          SectionPanel(
            title: 'Cheat Sheet',
            accent: kSectionAccent['Cheat Sheet']!,
            description:
                'Trang tra cứu nhanh (không phải demo chạy thật): tổng '
                'hợp sẵn syntax/widget hay dùng kèm ví dụ, để tra lại '
                'khi quên. Gom theo nhóm vì danh sách đã khá dài.',
            child: CheatSheetGroups(
              cheatSheets: cheatSheets,
              isWide: isWide,
              accent: kSectionAccent['Cheat Sheet']!,
            ),
          ),
        if (demos.isNotEmpty)
          SectionPanel(
            title: 'Demos',
            accent: kSectionAccent['Demos']!,
            description:
                'Học theo ĐÚNG thứ tự số (1, 2, 3...) trên mỗi thẻ - các '
                'demo sau thường dùng lại khái niệm của demo trước.',
            child: DemoGrid(
              demos: demos,
              isWide: isWide,
              accent: kSectionAccent['Demos']!,
              showIndex: true,
            ),
          ),
        if (examples.isNotEmpty)
          SectionPanel(
            title: 'Examples',
            accent: kSectionAccent['Examples']!,
            description:
                'Layout mẫu kết hợp nhiều widget, kèm đề bài + gợi ý để bạn '
                'tự luyện trước khi xem đáp án.',
            child: DemoGrid(
              demos: examples,
              isWide: isWide,
              accent: kSectionAccent['Examples']!,
            ),
          ),
        if (patterns.isNotEmpty)
          SectionPanel(
            title: 'Patterns',
            accent: kSectionAccent['Patterns']!,
            description:
                'Cách tổ chức code/quản lý state hay gặp, và danh sách các '
                'package phổ biến đáng tìm hiểu thêm.',
            child: DemoGrid(
              demos: patterns,
              isWide: isWide,
              accent: kSectionAccent['Patterns']!,
            ),
          ),
      ],
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(isWide ? 24 : 8),
      child: content,
    );
  }
}
