import 'package:flutter/material.dart';

import '../app_constants.dart';
import 'glass_panel.dart';

/// Khối "Giới thiệu" ở đầu vùng nội dung chính: app này là gì, dùng để làm
/// gì, và gợi ý thứ tự học - để người mới mở app không bị "rơi" thẳng vào
/// 1 danh sách dài không biết bắt đầu từ đâu.
///
/// "Gợi ý thứ tự học" hiện dưới dạng 1 hàng "chevron" (hình mũi tên, giống
/// style stepper/wizard) tách rời có khoảng cách + đổ bóng (PhysicalShape -
/// tự vẽ shadow khớp đúng hình dạng đã cắt, không dùng ClipPath+Container
/// vì ClipPath cắt luôn cả shadow của widget cha, không ra bóng được) -
/// mỗi mũi tên tự trượt + phóng to + mờ dần khi trang vừa mở (staggered
/// entrance, curve nảy nhẹ `easeOutBack`), và nhô lên khi hover (desktop).
/// Màn hẹp thì xếp dọc (mũi tên chỉ xuống) vì 4 mũi tên ngang sẽ quá chật.
///
/// Nhận [isWide] từ ngoài (giống `MainContent`) thay vì tự dùng
/// `LayoutBuilder` nội bộ - vì `IntroSection` còn bị đặt trong
/// `IntrinsicHeight` (ép cao bằng thẻ StatStrip cạnh nó ở `main_content.
/// dart`), mà `IntrinsicHeight` KHÔNG tương thích với `LayoutBuilder`
/// trong subtree của nó (lỗi "LayoutBuilder does not support returning
/// intrinsic dimensions").
class IntroSection extends StatefulWidget {
  final bool isWide;

  const IntroSection({super.key, required this.isWide});

  @override
  State<IntroSection> createState() => _IntroSectionState();
}

class _IntroSectionState extends State<IntroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _steps = [
    (
      'Môi trường & Công cụ',
      'Cài Flutter, chạy app đầu tiên (nếu bạn chưa từng đụng Flutter, '
          'bắt đầu từ đây)',
    ),
    (
      'Demos',
      'Nắm widget layout cơ bản (Row/Column/Stack/ListView...)',
    ),
    (
      'Examples',
      'Tự làm bài tập layout UI thực tế, đối chiếu đáp án',
    ),
    (
      'Patterns & Cheat Sheet',
      'Tra cứu khi cần, không cần học hết 1 lần',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _colorFor(int index) {
    const keys = [
      'Môi trường & Công cụ',
      'Demos',
      'Examples',
      'Cheat Sheet',
    ];
    return kSectionAccent[keys[index]]!;
  }

  /// Khoảng riêng cho mũi tên thứ [index] trong tổng animation - mũi tên
  /// sau bắt đầu trễ hơn 1 chút tạo hiệu ứng "chạy nối đuôi nhau" thay vì
  /// cùng xuất hiện 1 lúc. `easeOutBack` tạo cảm giác "nảy" nhẹ lúc dừng,
  /// rõ ràng là CÓ animation chứ không chỉ mờ dần đơn thuần.
  Animation<double> _curveFor(int index) {
    final start = index * 0.15;
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, (start + 0.6).clamp(0.0, 1.0), curve: Curves.easeOutBack),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Kính mờ (Liquid Glass) - thay cho gradient 3 màu (tím/xám/vàng) cũ
    // vốn trộn vào nhau nhìn đục, chói. Đồng bộ với sidebar/section panel
    // đã dùng [GlassPanel], để lộ khối màu nền phía sau (BackgroundBlobs)
    // thay vì TỰ áp 1 màu nền chói riêng.
    return GlassPanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👋 Flutter Beginner Journey',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bắt đầu học Flutter từ những nền tảng cơ bản, với:',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          _FeatureBullet(
            icon: '🎬',
            text: 'Demo chạy thật kèm source code',
          ),
          _FeatureBullet(
            icon: '✅',
            text: 'Bài tập Examples có đáp án',
          ),
          _FeatureBullet(
            icon: '🧩',
            text: 'Pattern tổ chức code thường gặp',
          ),
          _FeatureBullet(
            icon: '📖',
            text: 'Cheat Sheet tra cứu nhanh:',
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: const [
                'widget',
                'Dart syntax',
                'animation',
                'API',
                'auth',
                'testing',
                'performance',
                'môi trường & FVM',
              ].map((tag) => _MiniTag(tag)).toList(),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Gợi ý thứ tự học:',
            style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface),
          ),
          const SizedBox(height: 12),
          _ChevronSteps(
            isWide: widget.isWide,
            steps: _steps,
            colorFor: _colorFor,
            curveFor: _curveFor,
          ),
          const SizedBox(height: 10),
          Text(
            '💡 Dùng ô tìm kiếm/tag ở sidebar bên trái (hoặc mở menu ☰ nếu màn '
            'hình hẹp) để lọc nhanh theo chủ đề.',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// 1 dòng tính năng trong phần giới thiệu - icon emoji nhỏ + text, thay
/// cho 1 đoạn văn dài gộp hết các tính năng lại khó đọc.
class _FeatureBullet extends StatelessWidget {
  final String icon;
  final String text;

  const _FeatureBullet({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tag nhỏ (chip bo tròn) cho từng chủ đề trong Cheat Sheet - cố tình thu
/// nhỏ hết mức (font 10.5, padding sát) để 1 hàng Wrap chứa được nhiều tag
/// mà không chiếm quá nhiều chỗ, giống tag lọc bên sidebar.
class _MiniTag extends StatelessWidget {
  final String label;

  const _MiniTag(this.label);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: cs.primary,
        ),
      ),
    );
  }
}

class _ChevronSteps extends StatelessWidget {
  final bool isWide;
  final List<(String, String)> steps;
  final Color Function(int index) colorFor;
  final Animation<double> Function(int index) curveFor;

  // Khoảng cách GIỮA 2 mũi tên liền nhau - tách bạch rõ ràng từng bước
  // thay vì lồng/dính sát vào nhau.
  static const double _gap = 10;

  const _ChevronSteps({
    required this.isWide,
    required this.steps,
    required this.colorFor,
    required this.curveFor,
  });

  @override
  Widget build(BuildContext context) {
    final axis = isWide ? Axis.horizontal : Axis.vertical;
    final children = [
      for (var i = 0; i < steps.length; i++)
        _AnimatedChevron(
          index: i,
          axis: axis,
          color: colorFor(i),
          title: steps[i].$1,
          description: steps[i].$2,
          animation: curveFor(i),
        ),
    ];
    if (axis == Axis.horizontal) {
      return Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: _gap),
            Expanded(child: children[i]),
          ],
        ],
      );
    }
    return Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: _gap),
          children[i],
        ],
      ],
    );
  }
}

/// 1 mũi tên "chevron" - hình được cắt bằng [_ChevronClipper], tự đổ bóng
/// (qua [PhysicalShape]) để có chiều sâu thay vì phẳng lì. Tự trượt vào +
/// phóng to + mờ dần theo [animation] khi xuất hiện lần đầu, và nhô cao
/// hơn (tăng elevation + scale nhẹ) khi rê chuột qua (desktop/web).
class _AnimatedChevron extends StatefulWidget {
  final int index;
  final Axis axis;
  final Color color;
  final String title;
  final String description;
  final Animation<double> animation;

  const _AnimatedChevron({
    required this.index,
    required this.axis,
    required this.color,
    required this.title,
    required this.description,
    required this.animation,
  });

  @override
  State<_AnimatedChevron> createState() => _AnimatedChevronState();
}

class _AnimatedChevronState extends State<_AnimatedChevron> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final axis = widget.axis;
    final shape = PhysicalShape(
      clipper: _ChevronClipper(axis: axis),
      color: widget.color,
      elevation: _hovering ? 10 : 4,
      shadowColor: widget.color.withValues(alpha: 0.6),
      child: Container(
        height: axis == Axis.horizontal ? 72 : null,
        padding: axis == Axis.horizontal
            ? const EdgeInsets.fromLTRB(16, 8, 26, 8)
            : const EdgeInsets.fromLTRB(16, 10, 16, 26),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${widget.index + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: widget.color,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              widget.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: widget.animation,
        builder: (context, child) {
          final t = widget.animation.value;
          final entranceOffset = axis == Axis.horizontal
              ? Offset((1 - t) * -0.3, 0)
              : Offset(0, (1 - t) * -0.3);
          // Scale CÓ THỂ hơi vượt quá 1.0 1 chút do curve easeOutBack "nảy"
          // qua đích rồi mới ổn định - rõ ràng có chuyển động, không chỉ
          // mờ dần đơn thuần. Kẹp opacity (không kẹp scale) vì Opacity chỉ
          // nhận giá trị trong [0, 1].
          final scale = t.clamp(-0.4, 1.4) * 0.3 + 0.7;
          return Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: FractionalTranslation(
              translation: entranceOffset,
              child: Transform.scale(scale: scale, child: child),
            ),
          );
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: _hovering ? 1.04 : 1.0,
          child: shape,
        ),
      ),
    );
  }
}

/// Cắt 1 shape thành hình "chevron" (mũi tên/lá cờ) - đầu nhọn chỉ theo
/// [axis] (phải nếu ngang, xuống nếu dọc), cạnh đối diện phẳng - dùng với
/// [PhysicalShape] để vừa cắt hình vừa đổ bóng đúng theo contour đó.
class _ChevronClipper extends CustomClipper<Path> {
  final Axis axis;

  const _ChevronClipper({required this.axis});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (axis == Axis.horizontal) {
      final notch = size.height * 0.28;
      path.moveTo(0, 0);
      path.lineTo(size.width - notch, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - notch, size.height);
      path.lineTo(0, size.height);
    } else {
      final notch = size.width * 0.14;
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height - notch);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(0, size.height - notch);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _ChevronClipper oldClipper) =>
      oldClipper.axis != axis;
}
