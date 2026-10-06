import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:highlight/highlight.dart' show Node, highlight;

/// Panel hiển thị source code (đã tô màu syntax) của 1 file .dart, dùng chung
/// cho [DemoScaffold] và [ExampleScaffold].
class CodePanel extends StatefulWidget {
  final String? source;
  final String? error;

  const CodePanel({super.key, required this.source, required this.error});

  @override
  State<CodePanel> createState() => _CodePanelState();
}

class _CodePanelState extends State<CodePanel> {
  final _verticalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error != null) {
      return Center(
        child: Text(widget.error!, style: const TextStyle(color: Colors.red)),
      );
    }
    final source = widget.source;
    if (source == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      color: githubTheme['root']?.backgroundColor ?? Colors.white,
      child: Scrollbar(
        controller: _verticalController,
        child: SingleChildScrollView(
          controller: _verticalController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16),
              // Dùng Text.rich (không phải HighlightView của package
              // flutter_highlight) vì HighlightView vẽ bằng RichText thô,
              // không tự đăng ký với SelectionRegistrar nên không quét chọn
              // được dù đã nằm trong SelectionArea. Text/Text.rich thì tự
              // đăng ký với SelectionArea bao ngoài nên chọn được text.
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: Colors.black,
                  ),
                  children: highlightSpans(source, 'dart', githubTheme),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Parse + tô màu syntax cú pháp, trả về list TextSpan để đưa vào
/// Text.rich/SelectableText.rich.
///
/// Logic giống hệt `HighlightView._convert` của package flutter_highlight,
/// chỉ khác là không bọc trong RichText thô (xem giải thích ở [CodePanel]).
List<TextSpan> highlightSpans(
  String source,
  String language,
  Map<String, TextStyle> theme,
) {
  final spans = <TextSpan>[];
  var currentSpans = spans;
  final stack = <List<TextSpan>>[];

  void traverse(Node node) {
    if (node.value != null) {
      currentSpans.add(
        node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(text: node.value, style: theme[node.className!]),
      );
    } else if (node.children != null) {
      final tmp = <TextSpan>[];
      currentSpans.add(
        TextSpan(children: tmp, style: theme[node.className ?? '']),
      );
      stack.add(currentSpans);
      currentSpans = tmp;

      for (final child in node.children!) {
        traverse(child);
        if (child == node.children!.last) {
          currentSpans = stack.isEmpty ? spans : stack.removeLast();
        }
      }
    }
  }

  for (final node in highlight.parse(source, language: language).nodes!) {
    traverse(node);
  }
  return spans;
}
