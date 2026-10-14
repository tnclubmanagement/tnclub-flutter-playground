import 'package:flutter/material.dart';

/// Chế độ sáng/tối hiện tại - để TOÀN CỤC (đổi ở đâu cũng áp dụng ngay cho
/// cả app, xem [ThemeCheatsheet] cho pattern giải thích chi tiết). Dùng
/// `ValueNotifier` + `ValueListenableBuilder` thay vì setState thủ công -
/// đúng pattern đã dạy ở mục Pattern/ValueNotifier của app này.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.light,
);

/// Mỗi nhóm lớn trên trang chủ (Demos/Examples/Patterns/Cheat Sheet/Môi
/// trường & Công cụ) có 1 màu "thương hiệu" RIÊNG (không suy ra từ seed
/// color chung) - dùng cho icon section, nền card kiểu "bento block", và
/// viền/bóng khi hover - để mỗi khu vực có cá tính thị giác rõ ràng. Bảng
/// màu PASTEL nhẹ nhàng, tươi nhưng không gắt (xanh dương/san hô/ngọc
/// bích/vàng bơ/tím oải hương) - thay cho bộ màu đậm (tím/cam đất/xám/
/// vàng gold) cũ bị chê quá xỉn.
const Map<String, Color> kSectionAccent = {
  'Demos': Color(0xFF7C93F0), // xanh dương pastel (periwinkle)
  'Examples': Color(0xFFF0836E), // hồng san hô (coral) pastel
  'Patterns': Color(0xFF5FB3A6), // xanh ngọc (teal) pastel
  'Cheat Sheet': Color(0xFFF2C14E), // vàng bơ (butter yellow) pastel
  'Môi trường & Công cụ': Color(0xFFB08BD6), // tím oải hương (lilac) pastel
};
