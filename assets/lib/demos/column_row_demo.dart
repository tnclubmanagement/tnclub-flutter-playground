import 'package:flutter/material.dart';

/// Demo: Row & Column
///
/// - Row xếp children theo trục NGANG (main axis = horizontal)
/// - Column xếp children theo trục DỌC (main axis = vertical)
/// - mainAxisAlignment: cách phân bố children theo trục chính
/// - crossAxisAlignment: cách phân bố children theo trục phụ
class ColumnRowDemo extends StatefulWidget {
  const ColumnRowDemo({super.key});

  @override
  State<ColumnRowDemo> createState() => _ColumnRowDemoState();
}

class _ColumnRowDemoState extends State<ColumnRowDemo> {
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.start;
  CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.start;

  final List<MainAxisAlignment> _mainOptions = MainAxisAlignment.values;
  final List<CrossAxisAlignment> _crossOptions = CrossAxisAlignment.values;

  Widget _box(String label, {double height = 50}) {
    return Container(
      width: 60,
      height: height,
      margin: const EdgeInsets.all(4),
      color: Colors.deepPurple.withValues(alpha: 0.6),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'mainAxisAlignment (trục chính của Row = ngang)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<MainAxisAlignment>(
            value: _mainAxisAlignment,
            items: _mainOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: (v) => setState(() => _mainAxisAlignment = v!),
          ),
          const SizedBox(height: 8),
          const Text(
            'crossAxisAlignment (trục phụ của Row = dọc)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<CrossAxisAlignment>(
            value: _crossAxisAlignment,
            items: _crossOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: (v) => setState(() => _crossAxisAlignment = v!),
          ),
          const SizedBox(height: 16),
          const Text('Row:', style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            height: 150,
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: _mainAxisAlignment,
              crossAxisAlignment: _crossAxisAlignment,
              children: [
                _box('1', height: 40),
                _box('2', height: 70),
                _box('3', height: 50),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Column (dùng chính layout tương tự, đổi trục):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            height: 250,
            color: Colors.grey.shade200,
            child: Column(
              mainAxisAlignment: _mainAxisAlignment,
              crossAxisAlignment: _crossAxisAlignment,
              children: [_box('1'), _box('2'), _box('3')],
            ),
          ),
        ],
      ),
    );
  }
}
