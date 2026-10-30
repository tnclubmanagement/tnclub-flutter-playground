import 'package:flutter/material.dart';

/// Chế độ sáng/tối hiện tại - để TOÀN CỤC (đổi ở đâu cũng áp dụng ngay cho
/// cả app, xem [ThemeCheatsheet] cho pattern giải thích chi tiết). Dùng
/// `ValueNotifier` + `ValueListenableBuilder` thay vì setState thủ công -
/// đúng pattern đã dạy ở mục Pattern/ValueNotifier của app này.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.light,
);

/// Mỗi nhóm lớn có một accent riêng trong cùng một bảng màu học thuật: xanh
/// navy, đỏ burgundy, xanh slate, vàng ochre và xanh xám. Các màu đủ khác
/// nhau để định hướng nhưng không biến giao diện học tập thành bảng màu pastel.
const Map<String, Color> kSectionAccent = {
  'Demos': Color(0xFF294C68),
  'Examples': Color(0xFF8A4555),
  'Patterns': Color(0xFF3D6B6A),
  'Cheat Sheet': Color(0xFF9A752F),
  'Môi trường & Công cụ': Color(0xFF5B6480),
};
