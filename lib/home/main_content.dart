import 'package:flutter/material.dart';

import '../app_constants.dart';
import '../models/layout_demo.dart';
import 'cheat_sheet_groups.dart';
import 'demo_grid.dart';
import 'intro_section.dart';
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

    // Hero: card giới thiệu (to) + thẻ thống kê/donut (nhỏ) nằm CẠNH NHAU,
    // CAO BẰNG NHAU (crossAxisAlignment.stretch) - trên màn hẹp thì xếp
    // dọc lại (Column) cho vừa.
    // Trước đây có THÊM 1 vòng tròn "% đang hiện" riêng cạnh Intro VÀ 1
    // thẻ donut khác riêng bên dưới - 2 biểu đồ tròn khác nhau nhìn trùng
    // lặp, giờ gộp làm 1: đưa thẳng StatStrip (đã gồm cả donut lẫn % lọc
    // ở giữa donut) lên cạnh Intro luôn, bỏ hẳn card donut riêng bên dưới.
    //
    // Ép "cao bằng nhau tương đối" bằng `ConstrainedBox(minHeight)` thay vì
    // `IntrinsicHeight` + `stretch`: 2 cách đó ĐÃ THỬ nhưng đều dính lỗi
    // thật (không phải lý thuyết suông) - `stretch` cần chiều cao HỮU HẠN
    // từ parent trong khi Row này nằm trong SingleChildScrollView (chiều
    // cao vô hạn) -> lỗi "forces an infinite height"; còn `IntrinsicHeight`
    // thì tính sai lệch vài pixel so với layout thật (đúng cạm bẫy kinh
    // điển của nó) -> tràn (overflow) ngay khi nội dung dài thêm 1 dòng.
    // `minHeight` AN TOÀN hơn hẳn: chỉ đặt 1 "sàn" chiều cao, không ép
    // CHÍNH XÁC bằng nhau nhưng KHÔNG BAO GIỜ tràn - card nào ngắn hơn chỉ
    // đơn giản có thêm khoảng trắng dưới (xem `mainAxisSize.min` ở Column
    // của `IntroSection`/`StatStrip` để không bị ép giãn nội dung ra).
    const heroMinHeight = 380.0;
    final hero = isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: heroMinHeight),
                  child: IntroSection(isWide: isWide),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: heroMinHeight),
                  child: StatStrip(shown: shownCount),
                ),
              ),
            ],
          )
        : Column(
            children: [
              IntroSection(isWide: isWide),
              const SizedBox(height: 12),
              StatStrip(shown: shownCount),
            ],
          );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hero,
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
