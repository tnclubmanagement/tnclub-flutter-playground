import 'dart:ui';

import 'package:flutter/material.dart';

/// Khối "kính mờ" (liquid glass) dùng chung: làm mờ (blur) những gì ở PHÍA
/// SAU nó rồi phủ 1 lớp màu rất nhạt lên trên - khác hẳn Container nền đặc
/// thường thấy. Cần có thứ gì đó phía sau (xem [BackgroundBlobs]) thì hiệu
/// ứng kính khúc xạ mới thấy rõ, nếu không sẽ chỉ như 1 card mờ bình thường.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final Color? borderColor;

  static const _padding = EdgeInsets.all(16);
  static const _borderRadius = BorderRadius.all(Radius.circular(22));

  const GlassPanel({super.key, required this.child, this.borderColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Alpha thấp hơn ở dark mode vì nền tối dễ "ăn" màu trắng phủ lên hơn -
    // giữ y nguyên ở light mode thì dark mode sẽ bị trắng bệch, mất chất tối.
    final overlayTop = isDark ? 0.08 : 0.78;
    final overlayBottom = isDark ? 0.03 : 0.62;
    return ClipRRect(
      borderRadius: _borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          width: double.infinity,
          padding: _padding,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface
                    .withValues(alpha: overlayTop),
                Theme.of(context).colorScheme.surface
                    .withValues(alpha: overlayBottom),
              ],
            ),
            border: Border.all(
              color:
                  borderColor ??
                  Theme.of(context).colorScheme.outlineVariant
                      .withValues(alpha: isDark ? 0.55 : 0.9),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
