import 'package:flutter/material.dart';

/// Demo: Wrap
///
/// Khác với Row (sẽ bị overflow nếu children vượt quá chiều rộng), Wrap sẽ tự
/// động đưa children thừa xuống dòng (hoặc cột) kế tiếp.
/// - direction: Axis.horizontal (mặc định) hoặc Axis.vertical
/// - spacing: khoảng cách giữa children trên cùng 1 "run" (dòng/cột)
/// - runSpacing: khoảng cách giữa các "run" với nhau
class WrapDemo extends StatefulWidget {
  const WrapDemo({super.key});

  @override
  State<WrapDemo> createState() => _WrapDemoState();
}

class _WrapDemoState extends State<WrapDemo> {
  double _spacing = 8;
  double _runSpacing = 8;

  Widget _chip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
    );
  }

  Widget _slider(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            min: 0,
            max: 40,
            divisions: 40,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 32, child: Text(value.round().toString())),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tags = [
      'Flutter',
      'Dart',
      'Widget',
      'Row',
      'Column',
      'Stack',
      'Wrap',
      'ListView',
      'GridView',
      'Container',
      'Padding',
      'Margin',
      'Constraints',
      'BoxDecoration',
      'Flexible',
      'Expanded',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Tự chỉnh spacing/runSpacing:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _slider('spacing', _spacing, (v) => setState(() => _spacing = v)),
        _slider(
          'runSpacing',
          _runSpacing,
          (v) => setState(() => _runSpacing = v),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: _spacing,
          runSpacing: _runSpacing,
          children: tags.map(_chip).toList(),
        ),
        const SizedBox(height: 24),
        const Text(
          'So sánh: Row với cùng nội dung sẽ bị overflow (lỗi tràn màn hình):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Bỏ comment đoạn Row dưới đây trong code để tự quan sát lỗi '
          'overflow màu vàng/đen trên UI.',
          style: TextStyle(color: Colors.grey),
        ),
        // Row(
        //   children: tags.map(_chip).toList(),
        // ),
        const SizedBox(height: 24),
        const Text(
          'Wrap theo hướng dọc (direction: Axis.vertical):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Wrap(
            direction: Axis.vertical,
            spacing: _spacing,
            runSpacing: _runSpacing,
            children: tags.take(8).map(_chip).toList(),
          ),
        ),
      ],
    );
  }
}
