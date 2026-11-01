import 'package:flutter/material.dart';

/// Demo: ListView
///
/// - ListView.builder: hiệu quả cho danh sách dài, chỉ build item khi cần hiển thị.
/// - ListView.separated: thêm divider/separator giữa các item.
/// - scrollDirection: Axis.horizontal để tạo danh sách cuộn ngang.
class ListViewDemo extends StatefulWidget {
  const ListViewDemo({super.key});

  @override
  State<ListViewDemo> createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  double _horizontalCount = 15;
  double _verticalCount = 30;

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'ListView.builder ngang (horizontal):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _slider(
            'itemCount',
            _horizontalCount,
            1,
            30,
            (v) => setState(() => _horizontalCount = v),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _horizontalCount.round(),
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 8),
                color: Colors.deepPurple.withValues(alpha: 0.6),
                alignment: Alignment.center,
                child: Text(
                  'Item $index',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'ListView.separated dọc (vertical):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _slider(
            'itemCount',
            _verticalCount,
            1,
            60,
            (v) => setState(() => _verticalCount = v),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _verticalCount.round(),
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Dòng số ${index + 1}'),
                subtitle: const Text('ListView.separated builder'),
              );
            },
          ),
        ),
      ],
    );
  }
}
