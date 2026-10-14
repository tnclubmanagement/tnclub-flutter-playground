import 'package:flutter/material.dart';

/// Chế độ sáng/tối hiện tại - để TOÀN CỤC (đổi ở đâu cũng áp dụng ngay cho
/// cả app, xem [ThemeCheatsheet] cho pattern giải thích chi tiết). Dùng
/// `ValueNotifier` + `ValueListenableBuilder` thay vì setState thủ công -
/// đúng pattern đã dạy ở mục Pattern/ValueNotifier của app này.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.light,
);

/// Mỗi nhóm lớn trên trang chủ (Demos/Examples/Patterns/Cheat Sheet) có 1
/// màu "thương hiệu" RIÊNG (không suy ra từ seed color chung) - dùng cho
/// icon section, nền card kiểu "bento block", và viền/bóng khi hover - để
/// mỗi khu vực có cá tính thị giác rõ ràng. Theo đúng bảng màu tham khảo
/// (lavender/cam đất/xám/vàng) - ô "hồng" trong ảnh gốc đổi thành cam đất.
const Map<String, Color> kSectionAccent = {
  'Demos': Color(0xFF7C6FE0), // tím lavender
  'Examples': Color(0xFFC1623D), // cam đất (terracotta) - thay cho hồng
  'Patterns': Color(0xFF64748B), // xám đậm
  'Cheat Sheet': Color(0xFFD4A017), // vàng gold
};
