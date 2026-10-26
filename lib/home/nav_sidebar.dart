import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_constants.dart';
import '../models/layout_demo.dart';

/// Sidebar điều hướng: ô tìm kiếm + chip tag lọc + mục lục (Demos/Examples/
/// Patterns/Cheat Sheet) theo kết quả ĐÃ LỌC - dùng chung cho cả bản hiện
/// cố định (desktop) và bản trong Drawer (mobile).
///
/// Dùng [NavigationDrawer] CHÍNH THỨC của Material 3 (không tự dựng
/// ExpansionTile/ListTile) - đây là component điều hướng dạng danh sách
/// chuẩn Google, có indicator chọn/hover/ripple xịn sẵn, thay vì tự vẽ lại
/// từ đầu. Section/group label là các `Widget` thường chèn giữa các
/// [NavigationDrawerDestination] - [NavigationDrawer] tự biết bỏ qua
/// chúng khi tính index (chỉ đếm các `NavigationDrawerDestination`).
class NavSidebar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<String> allTags;
  final Set<String> selectedTags;
  final ValueChanged<String> onTagToggle;
  final Set<String> expandedSections;
  final ValueChanged<String> onSectionToggle;
  final List<LayoutDemo> demos;
  final List<LayoutDemo> examples;
  final List<LayoutDemo> patterns;
  final List<LayoutDemo> cheatSheets;
  final List<LayoutDemo> environmentTools;

  const NavSidebar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.allTags,
    required this.selectedTags,
    required this.onTagToggle,
    required this.expandedSections,
    required this.onSectionToggle,
    required this.demos,
    required this.examples,
    required this.patterns,
    required this.cheatSheets,
    required this.environmentTools,
  });

  // Style TINH TẾ hơn bản cũ (bỏ chữ IN HOA + badge số nổi bật + icon màu
  // đậm) - gần với mục "Performance" trong ảnh tham khảo: chữ thường,
  // weight vừa phải, icon/chevron trung tính (xám).
  Widget _sectionLabel(
    BuildContext context,
    String title,
    IconData icon,
    int count,
  ) {
    final cs = Theme.of(context).colorScheme;
    final expanded = expandedSections.contains(title);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onSectionToggle(title),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
          child: Row(
            children: [
              Icon(icon, size: 17, weight: 300, color: cs.onSurfaceVariant),
              const SizedBox(width: 8),
              // Bọc title+count trong 1 Expanded DUY NHẤT (thay vì để
              // Flexible(title) với Spacer() cạnh tranh ngang hàng - 2 cái
              // flex bằng nhau sẽ bị Row CHIA ĐÔI khoảng trống, ép title
              // vào đúng nửa đầu dù chữ ngắn vẫn bị "...", còn Spacer luôn
              // chiếm trọn nửa sau -> khoảng trắng thừa, chevron lệch).
              // Expanded này là flex DUY NHẤT của Row ngoài nên chiếm hết
              // khoảng trống còn lại, chevron tự động dính sát mép phải.
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                expanded
                    ? Symbols.keyboard_arrow_up
                    : Symbols.keyboard_arrow_down,
                size: 18,
                weight: 300,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _groupLabel(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(34, 8, 16, 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  Widget _chapterLabel(BuildContext context, String chapter) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(34, 8, 16, 2),
      child: Text(
        chapter,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  /// Gộp 1 section vào [destinations] - tự chèn label section (+ label
  /// từng group con nếu [groupByField]) rồi mới tới các
  /// [NavigationDrawerDestination]. Section rỗng (do bị lọc hết) tự ẩn.
  ///
  /// QUAN TRỌNG: [flatOrder] phải được cập nhật ĐÚNG SONG SONG với
  /// [destinations] - `NavigationDrawer.onDestinationSelected` trả về index
  /// tính theo thứ tự CÁC NavigationDrawerDestination THỰC SỰ xuất hiện
  /// (bỏ qua section đang fold/collapse), nên nếu [flatOrder] lại chứa cả
  /// item của section đang ẩn thì index sẽ lệch, bấm sai trang.
  void _addSection(
    BuildContext context,
    List<Widget> destinations,
    List<LayoutDemo> flatOrder,
    String title,
    IconData icon,
    List<LayoutDemo> items, {
    bool groupByField = false,
    String? chapterLabel,
    Map<int, String>? chapterBreaks,
  }) {
    if (items.isEmpty) return;
    destinations.add(_sectionLabel(context, title, icon, items.length));
    if (!expandedSections.contains(title)) return; // fold: ẩn hết item con

    if (chapterLabel != null) {
      destinations.add(_chapterLabel(context, chapterLabel));
    }

    if (!groupByField) {
      for (var i = 0; i < items.length; i++) {
        final chapter = chapterBreaks?[i];
        if (chapter != null) {
          destinations.add(_chapterLabel(context, chapter));
        }
        final d = items[i];
        flatOrder.add(d);
        destinations.add(_destinationFor(d));
      }
      return;
    }
    final groupOrder = <String>[];
    final byGroup = <String, List<LayoutDemo>>{};
    for (final d in items) {
      final g = d.group ?? 'Khác';
      byGroup
          .putIfAbsent(g, () {
            groupOrder.add(g);
            return [];
          })
          .add(d);
    }
    for (final g in groupOrder) {
      destinations.add(_groupLabel(context, g));
      for (final d in byGroup[g]!) {
        flatOrder.add(d);
        destinations.add(_destinationFor(d));
      }
    }
  }

  NavigationDrawerDestination _destinationFor(LayoutDemo demo) {
    return NavigationDrawerDestination(
      // Bỏ icon riêng cho từng item con (trước là vòng tròn outline) -
      // chỉ còn khoảng trống thụt lề, giống style "chỉ chữ, thụt lề" của
      // mục con dưới "Performance" trong ảnh tham khảo, đỡ rối mắt hơn.
      icon: const SizedBox(width: 2),
      // NavigationDrawerDestination xếp icon+label trong 1 Row KHÔNG có
      // Expanded/Flexible nội bộ - label dài (tiêu đề đầy đủ kèm emoji) sẽ
      // làm Row tràn. Ép width cố định để Text tự ellipsis đúng cách thay
      // vì tràn ra ngoài.
      label: SizedBox(
        width: 204,
        child: Text(
          demo.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final destinations = <Widget>[];
    final flatOrder = <LayoutDemo>[];
    _addSection(
      context,
      destinations,
      flatOrder,
      'Môi trường & Công cụ',
      Symbols.build,
      environmentTools,
      chapterLabel: 'Chapter 1',
    );
    _addSection(
      context,
      destinations,
      flatOrder,
      'Cheat Sheet',
      Symbols.menu_book,
      cheatSheets,
      groupByField: true,
      chapterLabel: 'Chapter 2',
    );
    _addSection(
      context,
      destinations,
      flatOrder,
      'Demos',
      Symbols.widgets,
      demos,
      chapterBreaks: const {0: 'Chapter 3', 1: 'Chapter 4'},
    );
    _addSection(
      context,
      destinations,
      flatOrder,
      'Examples',
      Symbols.assignment,
      examples,
      chapterLabel: 'Chapter 5',
    );
    _addSection(
      context,
      destinations,
      flatOrder,
      'Patterns',
      Symbols.extension,
      patterns,
      chapterLabel: 'Chapter 6',
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Kính mờ (Liquid Glass) cho CẢ sidebar: NavigationDrawer mặc định vẽ
    // nền ĐẶC (opaque) nên phải tự set backgroundColor TRONG SUỐT rồi bọc
    // ngoài bằng BackdropFilter - nếu không blur sẽ không thấy gì (nền đặc
    // của Drawer che mất những gì bị làm mờ phía sau).
    // Margin xung quanh sidebar để kính mờ trông như 1 panel nổi tách khỏi
    // mép màn hình, thay vì dính sát viền (dùng ClipRRect bo góc cho khớp
    // với khoảng margin này, nếu không góc vuông sẽ lạc lõng).
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: NavigationDrawer(
            backgroundColor: Colors.white.withValues(
              alpha: isDark ? 0.06 : 0.45,
            ),
            // -1: không có mục nào "đang chọn" cố định - mỗi lần bấm sẽ MỞ 1
            // trang MỚI (push) chứ không phải chuyển tab trong cùng 1 màn hình.
            selectedIndex: -1,
            onDestinationSelected: (index) =>
                Navigator.of(context).pushNamed(flatOrder[index].path),
            indicatorColor: cs.primaryContainer,
            header: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tên app đóng vai trò "logo" của sidebar - thay cho AppBar
                  // riêng đã bỏ, giống cách 1 dashboard thật gộp luôn tên sản
                  // phẩm vào góc trên sidebar thay vì có cả header lẫn sidebar.
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Flutter Beginner Journey',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: themeModeNotifier,
                        builder: (context, mode, _) {
                          final isDark = mode == ThemeMode.dark;
                          return IconButton(
                            tooltip: isDark
                                ? 'Chuyển sang Light mode'
                                : 'Chuyển sang Dark mode',
                            icon: Icon(
                              isDark ? Symbols.light_mode : Symbols.dark_mode,
                              size: 20,
                              weight: 300,
                            ),
                            visualDensity: VisualDensity.compact,
                            onPressed: () => themeModeNotifier.value = isDark
                                ? ThemeMode.light
                                : ThemeMode.dark,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Symbols.explore,
                        size: 18,
                        weight: 300,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'MỤC LỤC',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: searchController,
                    builder: (context, _) {
                      return TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Tìm trang...',
                          prefixIcon: const Icon(
                            Symbols.search,
                            size: 18,
                            weight: 300,
                          ),
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(
                                    Symbols.close,
                                    size: 16,
                                    weight: 300,
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    onSearchChanged('');
                                  },
                                ),
                          isDense: true,
                          filled: true,
                          fillColor: cs.surfaceContainerHighest,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: cs.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (allTags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Text(
                          'LỌC THEO TAG',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        if (selectedTags.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              for (final t in List<String>.from(selectedTags)) {
                                onTagToggle(t);
                              }
                            },
                            child: Text(
                              'Xoá lọc (${selectedTags.length})',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: cs.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _TagScroller(
                      tags: allTags,
                      selectedTags: selectedTags,
                      onTagToggle: onTagToggle,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Divider(height: 1, color: cs.outlineVariant),
                ],
              ),
            ),
            children: destinations,
          ),
        ),
      ),
    );
  }
}

class _TagScroller extends StatefulWidget {
  final List<String> tags;
  final Set<String> selectedTags;
  final ValueChanged<String> onTagToggle;

  const _TagScroller({
    required this.tags,
    required this.selectedTags,
    required this.onTagToggle,
  });

  @override
  State<_TagScroller> createState() => _TagScrollerState();
}

class _TagScrollerState extends State<_TagScroller> {
  final _scrollController = ScrollController();
  bool _canScrollBack = false;
  bool _canScrollForward = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollButtons);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateScrollButtons();
    });
  }

  @override
  void didUpdateWidget(covariant _TagScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateScrollButtons();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateScrollButtons)
      ..dispose();
    super.dispose();
  }

  void _updateScrollButtons() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final canBack = position.pixels > 0;
    final canForward = position.pixels < position.maxScrollExtent;
    if (canBack != _canScrollBack || canForward != _canScrollForward) {
      setState(() {
        _canScrollBack = canBack;
        _canScrollForward = canForward;
      });
    }
  }

  void _scrollBy(double amount) {
    final target = (_scrollController.offset + amount).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          _TagArrow(
            icon: Icons.chevron_left_rounded,
            enabled: _canScrollBack,
            onPressed: () => _scrollBy(-180),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              itemCount: widget.tags.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final tag = widget.tags[i];
                final selected = widget.selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag, style: const TextStyle(fontSize: 11)),
                  selected: selected,
                  onSelected: (_) => widget.onTagToggle(tag),
                  visualDensity: VisualDensity.compact,
                  showCheckmark: false,
                  backgroundColor: cs.surfaceContainerHighest,
                  selectedColor: cs.primary,
                  side: BorderSide.none,
                  labelStyle: TextStyle(
                    color: selected ? cs.onPrimary : cs.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 4),
          _TagArrow(
            icon: Icons.chevron_right_rounded,
            enabled: _canScrollForward,
            onPressed: () => _scrollBy(180),
          ),
        ],
      ),
    );
  }
}

class _TagArrow extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _TagArrow({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 28,
      height: 32,
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        padding: EdgeInsets.zero,
        iconSize: 19,
        tooltip: icon == Icons.chevron_left_rounded
            ? 'Cuộn sang trái'
            : 'Cuộn sang phải',
        style: IconButton.styleFrom(
          foregroundColor: cs.primary,
          disabledForegroundColor: cs.outlineVariant,
          backgroundColor: cs.surfaceContainerHighest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        icon: Icon(icon),
      ),
    );
  }
}
