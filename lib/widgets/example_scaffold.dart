import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'code_panel.dart';

/// Scaffold dùng chung cho các trang "Examples": khác với [DemoScaffold] (tập
/// trung vào 1 thuộc tính/widget), mỗi Example là 1 layout UI thực tế
/// (profile card, login form, ...) kết hợp nhiều widget layout đã học.
///
/// [bodyBuilder] render "code mồi" (file `*_starter.dart`, khung sườn đã có
/// sẵn, phần chi tiết còn TODO) để người dùng sửa trực tiếp file đó và xem
/// kết quả cập nhật ngay qua hot-reload.
///
/// [answerBuilder] render bản MẪU đã hoàn chỉnh (file `*_example.dart`) -
/// hiển thị trực quan (không chỉ text) kèm source code, cả hai đều giấu sau
/// nút "Hiện đáp án" để người dùng tự code trước khi đối chiếu.
class ExampleScaffold extends StatefulWidget {
  final String title;
  final String task;
  final List<String> hints;
  final String assetPath;
  final WidgetBuilder bodyBuilder;
  final WidgetBuilder answerBuilder;

  const ExampleScaffold({
    super.key,
    required this.title,
    required this.task,
    this.hints = const [],
    required this.assetPath,
    required this.bodyBuilder,
    required this.answerBuilder,
  });

  @override
  State<ExampleScaffold> createState() => _ExampleScaffoldState();
}

class _ExampleScaffoldState extends State<ExampleScaffold> {
  String? _source;
  String? _error;
  bool _showAnswer = false;

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
    final answerPreview = widget.answerBuilder(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      // SelectionArea cho phép quét chọn text xuyên qua cả đề bài, kết quả
      // mẫu và source code. Đặt ở đây (dưới Navigator) để luôn có Overlay
      // ancestor mà SelectableRegion yêu cầu.
      body: SelectionArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final taskPanel = _TaskPanel(
              task: widget.task,
              hints: widget.hints,
              showAnswer: _showAnswer,
              onToggleAnswer: () => setState(() => _showAnswer = !_showAnswer),
            );
            final resultPanel = _ResultPanel(child: demoPanel);
            final codePanel = _showAnswer
                ? _AnswerPanel(
                    preview: answerPreview,
                    source: _source,
                    error: _error,
                  )
                : const _HiddenAnswerPlaceholder();

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          taskPanel,
                          const SizedBox(height: 16),
                          resultPanel,
                        ],
                      ),
                    ),
                  ),
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
                      Tab(text: 'Đề bài & kết quả', icon: Icon(Icons.widgets)),
                      Tab(text: 'Đáp án', icon: Icon(Icons.code)),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              taskPanel,
                              const SizedBox(height: 16),
                              resultPanel,
                            ],
                          ),
                        ),
                        codePanel,
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TaskPanel extends StatelessWidget {
  final String task;
  final List<String> hints;
  final bool showAnswer;
  final VoidCallback onToggleAnswer;

  const _TaskPanel({
    required this.task,
    required this.hints,
    required this.showAnswer,
    required this.onToggleAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Đề bài',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(task),
            if (hints.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Gợi ý:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...hints.map(
                (h) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('•  '),
                      Expanded(child: Text(h)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onToggleAnswer,
              icon: Icon(showAnswer ? Icons.visibility_off : Icons.code),
              label: Text(showAnswer ? 'Ẩn đáp án' : 'Hiện đáp án'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  final Widget child;

  const _ResultPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Code mồi (sửa trực tiếp file *_starter.dart, hot-reload sẽ cập '
          'nhật ở đây để bạn đối chiếu với đề bài):',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ],
    );
  }
}

/// Hiển thị đáp án đầy đủ: bản render trực quan (không chỉ text) của mẫu
/// hoàn chỉnh, kèm source code bên dưới để đối chiếu.
class _AnswerPanel extends StatelessWidget {
  final Widget preview;
  final String? source;
  final String? error;

  const _AnswerPanel({
    required this.preview,
    required this.source,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mẫu (kết quả hoàn chỉnh cần đạt được):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: preview,
          ),
          const SizedBox(height: 16),
          const Text(
            'Source code đáp án:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 400,
            child: CodePanel(source: source, error: error),
          ),
        ],
      ),
    );
  }
}

class _HiddenAnswerPlaceholder extends StatelessWidget {
  const _HiddenAnswerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Hãy tự code trước, rồi bấm "Hiện đáp án" ở bên trái để đối chiếu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
