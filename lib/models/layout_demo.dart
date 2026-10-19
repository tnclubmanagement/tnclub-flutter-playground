import 'package:flutter/material.dart';

class LayoutDemo {
  final String title;
  final String description;
  final String path;
  final WidgetBuilder builder;
  // Chỉ dùng cho mục Cheat Sheet - gom các trang liên quan vào 1 nhóm nhỏ
  // (hiện tiêu đề phụ trên trang chủ) vì danh sách cheat sheet đã khá dài.
  final String? group;
  // Dùng cho search/filter ở sidebar trang chủ - mỗi trang gắn 1-3 tag
  // ngắn, KHÔNG phân biệt hoa/thường khi so khớp (xem _matchesQuery).
  final List<String> tags;
  // Đánh dấu trang "nâng cao" - hiện badge riêng trên card (xem DemoTile)
  // để người mới biết nên tạm bỏ qua, học sau khi đã vững nền tảng.
  final bool advanced;

  const LayoutDemo({
    required this.title,
    required this.description,
    required this.path,
    required this.builder,
    this.group,
    this.tags = const [],
    this.advanced = false,
  });
}
