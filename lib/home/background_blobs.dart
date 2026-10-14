import 'dart:ui';

import 'package:flutter/material.dart';

import '../app_constants.dart';

/// Vài khối màu lớn, làm mờ (blur) sẵn, đặt PHÍA SAU toàn bộ nội dung trang
/// chủ - để các [GlassPanel] (sidebar, section panel) phía trên có gì đó
/// để "khúc xạ" qua lớp kính mờ, đúng tinh thần hiệu ứng Liquid Glass thay
/// vì kính mờ phủ lên nền trắng/xám trơn (nhìn chỉ như card mờ vô nghĩa).
class BackgroundBlobs extends StatelessWidget {
  const BackgroundBlobs({super.key});

  Widget _blob(Color color, double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // IgnorePointer để các khối màu trang trí này KHÔNG chặn tương tác
    // (bấm/cuộn) của nội dung thật nằm phía trên.
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -80,
            child: _blob(kSectionAccent['Demos']!, 280),
          ),
          Positioned(
            top: 160,
            right: -120,
            child: _blob(kSectionAccent['Examples']!, 320),
          ),
          Positioned(
            bottom: -120,
            left: 200,
            child: _blob(kSectionAccent['Cheat Sheet']!, 260),
          ),
          Positioned(
            bottom: 40,
            right: 120,
            child: _blob(kSectionAccent['Patterns']!, 220),
          ),
        ],
      ),
    );
  }
}
