import 'package:flutter/material.dart';

import 'code_panel.dart';

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
/// theo nhóm (tab) - gồm AppBar + TabBar ("Tất cả" + từng category) +
/// TabBarView, mỗi thẻ hiện mô tả + preview chạy thật + code mẫu tô màu.
///
/// Trước đây mỗi trang cheat sheet tự viết lại TOÀN BỘ khung này (AppBar,
/// TabBar, TabBarView, Card...) - viết 1 lần ở đây, các trang mới chỉ cần
/// khai báo [CheatsheetEntry] + preview riêng của nó.
class CheatsheetScaffold extends StatelessWidget {
  final String title;
  final String intro;
  final List<CheatsheetEntry> items;

  const CheatsheetScaffold({
    super.key,
    required this.title,
    required this.intro,
    required this.items,
  });

  List<String> get _categories => items.map((i) => i.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    return DefaultTabController(
      length: categories.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              const Tab(text: 'Tất cả'),
              ...categories.map((c) => Tab(text: c)),
            ],
          ),
        ),
        body: SelectionArea(
          child: TabBarView(
            children: [
              _EntryList(intro: intro, items: items),
              ...categories.map(
                (c) => _EntryList(
                  intro: intro,
                  items: items.where((i) => i.category == c).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
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
