import 'package:flutter/material.dart';

import 'code_panel.dart';

/// Key gắn vào `ListView` của nav category dọc (dùng trong cả
/// [CheatsheetScaffold] lẫn [CategoryFilterScaffold]) - để test scope đúng
/// `ListTile` của nav, tránh nhầm với `ListTile` khác xuất hiện trong nội
/// dung demo (vd preview của AnimatedList).
const cheatsheetCategoryNavKey = Key('cheatsheetCategoryNav');

/// Ngưỡng width nav category chuyển từ sidebar cố định sang gấp vào Drawer
/// (xem [_CategoryNavScaffold]) - export ra để test dùng chung, tránh lặp
/// lại số "700" ở nhiều nơi.
const cheatsheetNavWideBreakpoint = 700.0;

/// 1 mục trong [CheatsheetScaffold]: tên, nhóm (để lọc theo tab), mô tả,
/// code mẫu, và 1 preview chạy thật (hoặc mô phỏng nếu cần package ngoài).
class CheatsheetEntry {
  final String name;
  final String category;
  final String description;
  final String snippet;
  final WidgetBuilder preview;

  const CheatsheetEntry({
    required this.name,
    required this.category,
    required this.description,
    required this.snippet,
    required this.preview,
  });
}

/// Khung dùng CHUNG cho mọi trang "cheat sheet" dạng danh sách thẻ có lọc
/// theo nhóm - gồm AppBar + nav DỌC bên trái ("Tất cả" + từng category) +
/// nội dung bên phải, mỗi thẻ hiện mô tả + preview chạy thật + code mẫu tô
/// màu.
///
/// Trước đây mỗi trang cheat sheet tự viết lại TOÀN BỘ khung này (AppBar,
/// TabBar, TabBarView, Card...) - viết 1 lần ở đây, các trang mới chỉ cần
/// khai báo [CheatsheetEntry] + preview riêng của nó.
class CheatsheetScaffold extends StatefulWidget {
  final String title;
  final String intro;
  final List<CheatsheetEntry> items;

  const CheatsheetScaffold({
    super.key,
    required this.title,
    required this.intro,
    required this.items,
  });

  @override
  State<CheatsheetScaffold> createState() => _CheatsheetScaffoldState();
}

class _CheatsheetScaffoldState extends State<CheatsheetScaffold> {
  int _selectedIndex = 0;

  List<String> get _categories =>
      widget.items.map((i) => i.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    final labels = ['Tất cả', ...categories];
    final visibleItems = _selectedIndex == 0
        ? widget.items
        : widget.items
            .where((i) => i.category == categories[_selectedIndex - 1])
            .toList();

    return _CategoryNavScaffold(
      title: widget.title,
      labels: labels,
      selectedIndex: _selectedIndex,
      onSelect: (index) => setState(() => _selectedIndex = index),
      body: _EntryList(intro: widget.intro, items: visibleItems),
    );
  }
}

/// Khung dùng chung bên trong cho cả [CheatsheetScaffold] lẫn
/// [CategoryFilterScaffold]: AppBar + nav category - cố định bên trái khi
/// màn hình đủ rộng, gấp vào [Drawer] khi hẹp (dùng [LayoutBuilder] thay vì
/// `MediaQuery`, nhất quán với cách `HomePage` tự co sidebar theo
/// `constraints.maxWidth` - và để test được qua `setSurfaceSize`).
class _CategoryNavScaffold extends StatelessWidget {
  final String title;
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Widget body;

  const _CategoryNavScaffold({
    required this.title,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= cheatsheetNavWideBreakpoint;

        Widget buildNavList(BuildContext navContext) => Material(
          color: Theme.of(navContext).colorScheme.surfaceContainerLow,
          child: ListView.builder(
            key: cheatsheetCategoryNavKey,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: labels.length,
            itemBuilder: (itemContext, index) {
              final selected = index == selectedIndex;
              return ListTile(
                selected: selected,
                selectedTileColor:
                    Theme.of(itemContext).colorScheme.primaryContainer,
                title: Text(
                  labels[index],
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  onSelect(index);
                  // Màn hình hẹp: nav nằm trong Drawer - đóng lại sau khi
                  // chọn. Màn hình rộng: nav cố định, không có gì để đóng.
                  if (!isWide) Navigator.pop(itemContext);
                },
              );
            },
          ),
        );

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          drawer: isWide ? null : Drawer(child: Builder(builder: buildNavList)),
          body: SelectionArea(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(width: 220, child: Builder(builder: buildNavList)),
                      const VerticalDivider(width: 1),
                      Expanded(child: body),
                    ],
                  )
                : body,
          ),
        );
      },
    );
  }
}

class _EntryList extends StatelessWidget {
  final String intro;
  final List<CheatsheetEntry> items;

  const _EntryList({required this.intro, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(intro),
          );
        }
        return _EntryCard(info: items[index - 1]);
      },
    );
  }
}

class _EntryCard extends StatelessWidget {
  final CheatsheetEntry info;

  const _EntryCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(info.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(label: Text(info.category, style: const TextStyle(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 8),
            Text(info.description, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Text(
              '▶ Xem trực tiếp (bấm vào demo bên dưới):',
              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(builder: info.preview),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: CodePanel(source: info.snippet, error: null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Khung AppBar + nav DỌC bên trái theo category - dùng cho các trang cheat
/// sheet có cấu trúc dữ liệu RIÊNG (không theo [CheatsheetEntry], vd bảng so
/// sánh widget/syntax) nhưng vẫn cần lọc theo category giống
/// [CheatsheetScaffold]. [bodyBuilder] nhận `null` khi đang ở "Tất cả", hoặc
/// tên category đang chọn.
class CategoryFilterScaffold extends StatefulWidget {
  final String title;
  final List<String> categories;
  final Widget Function(String? category) bodyBuilder;

  const CategoryFilterScaffold({
    super.key,
    required this.title,
    required this.categories,
    required this.bodyBuilder,
  });

  @override
  State<CategoryFilterScaffold> createState() =>
      _CategoryFilterScaffoldState();
}

class _CategoryFilterScaffoldState extends State<CategoryFilterScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final labels = ['Tất cả', ...widget.categories];
    final selectedCategory =
        _selectedIndex == 0 ? null : widget.categories[_selectedIndex - 1];

    return _CategoryNavScaffold(
      title: widget.title,
      labels: labels,
      selectedIndex: _selectedIndex,
      onSelect: (index) => setState(() => _selectedIndex = index),
      body: widget.bodyBuilder(selectedCategory),
    );
  }
}

/// Caption nhỏ gợi ý hành động dưới mỗi demo - dùng chung cho các preview
/// của mọi trang cheat sheet mới (tránh lặp lại cùng 1 đoạn Text style).
class CheatsheetHint extends StatelessWidget {
  final String text;

  const CheatsheetHint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
