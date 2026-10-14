import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../models/layout_demo.dart';

/// Xếp các [DemoTile] thành lưới nhiều cột (Wrap) khi [isWide], mỗi thẻ có
/// chiều rộng cố định nên số cột tự co giãn theo chiều rộng cửa sổ. Khi hẹp
/// (mobile) quay lại list 1 cột full-width như trước.
class DemoGrid extends StatelessWidget {
  final List<LayoutDemo> demos;
  final bool isWide;
  final Color accent;

  const DemoGrid({
    super.key,
    required this.demos,
    required this.isWide,
    required this.accent,
  });

  static const double _cardWidth = 360;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(
        children: demos
            .map((demo) => DemoTile(demo: demo, accent: accent))
            .toList(),
      );
    }
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: demos
          .map(
            (demo) => SizedBox(
              width: _cardWidth,
              child: DemoTile(demo: demo, accent: accent),
            ),
          )
          .toList(),
    );
  }
}

class DemoTile extends StatefulWidget {
  final LayoutDemo demo;
  final Color accent;

  const DemoTile({super.key, required this.demo, required this.accent});

  @override
  State<DemoTile> createState() => _DemoTileState();
}

class _DemoTileState extends State<DemoTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final demo = widget.demo;
    final accent = widget.accent;
    // Nền "bento block" pastel - pha accent vào nền theme (khác nhau giữa
    // light/dark) thay vì màu CỨNG, để vẫn đọc được chữ ở cả 2 mode.
    final blockColor = Color.alphaBlend(
      accent.withValues(alpha: 0.16),
      colorScheme.surface,
    );
    final blockColorHover = Color.alphaBlend(
      accent.withValues(alpha: 0.24),
      colorScheme.surface,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(bottom: 8, top: _hovering ? 0 : 4),
        transform: Matrix4.translationValues(0, _hovering ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: _hovering ? blockColorHover : blockColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(demo.path),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon section tô màu SOLID theo accent riêng - để mỗi
                  // nhóm Demos/Examples/Patterns/Cheat Sheet có nhận diện
                  // riêng, nổi trên nền pastel cùng tông.
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Symbols.widgets,
                      color: Colors.white,
                      size: 22,
                      weight: 300,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demo.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          demo.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (demo.tags.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            // Tag nhuộm màu theo ĐÚNG accent của card (thay
                            // vì màu trung tính rời rạc) - vừa đồng bộ hơn,
                            // vừa đỡ "chìm" trên nền pastel cùng tông.
                            children: demo.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Nút mũi tên tròn kiểu "bento block" (giống ảnh tham
                  // khảo) thay cho chevron mảnh trước đây.
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Symbols.north_east,
                      size: 14,
                      weight: 300,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
