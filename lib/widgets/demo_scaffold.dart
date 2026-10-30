import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'code_panel.dart';

/// Scaffold dùng chung cho mọi màn demo: hiển thị widget demo kế bên source
/// code thật của nó (đọc trực tiếp từ asset nên luôn khớp với code bạn sửa).
///
/// - Màn hình rộng (>= 900px, ví dụ chạy web/desktop): chia đôi trái/phải.
/// - Màn hình hẹp (mobile): chuyển sang 2 tab "Demo" / "Code" cho dễ nhìn.
class DemoScaffold extends StatefulWidget {
  final String title;
  final String assetPath;
  final WidgetBuilder bodyBuilder;

  const DemoScaffold({
    super.key,
    required this.title,
    required this.assetPath,
    required this.bodyBuilder,
  });

  @override
  State<DemoScaffold> createState() => _DemoScaffoldState();
}

class _DemoScaffoldState extends State<DemoScaffold> {
  String? _source;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSource();
  }

  Future<void> _loadSource() async {
    try {
      final code = await rootBundle.loadString(widget.assetPath);
      if (mounted) setState(() => _source = code);
    } catch (e) {
      if (mounted) setState(() => _error = 'Không đọc được source: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final demoPanel = widget.bodyBuilder(context);
    final codePanel = CodePanel(source: _source, error: _error);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      // SelectionArea cho phép quét chọn text (kéo chuột bôi đen) xuyên qua
      // cả demo panel và code panel. Đặt trong từng trang (dưới Navigator)
      // để luôn có Overlay ancestor mà SelectableRegion yêu cầu.
      body: SelectionArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            if (isWide) {
              return Row(
                children: [
                  Expanded(child: demoPanel),
                  const VerticalDivider(width: 1),
                  Expanded(child: codePanel),
                ],
              );
            }
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Demo', icon: Icon(Icons.widgets)),
                      Tab(text: 'Code', icon: Icon(Icons.code)),
                    ],
                  ),
                  Expanded(child: TabBarView(children: [demoPanel, codePanel])),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
