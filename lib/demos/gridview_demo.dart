import 'package:flutter/material.dart';

/// Demo: GridView
///
/// - GridView.count: chia lưới với số cột cố định (crossAxisCount).
/// - GridView.builder + SliverGridDelegateWithFixedCrossAxisCount: hiệu quả
///   hơn cho danh sách dài, có thể tùy biến childAspectRatio, spacing...
class GridViewDemo extends StatefulWidget {
  const GridViewDemo({super.key});

  @override
  State<GridViewDemo> createState() => _GridViewDemoState();
}

class _GridViewDemoState extends State<GridViewDemo> {
  double _crossAxisCount = 4;
  double _aspectRatio = 1.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'GridView.count (3 cột):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: GridView.count(
            crossAxisCount: 3,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(9, (index) {
              return Container(
                color: Colors.teal.withValues(alpha: 0.7),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            'GridView.builder: tự chỉnh crossAxisCount '
            '(${_crossAxisCount.round()}) và childAspectRatio '
            '(${_aspectRatio.toStringAsFixed(1)}):',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const SizedBox(width: 100, child: Text('crossAxisCount')),
              Expanded(
                child: Slider(
                  value: _crossAxisCount,
                  min: 1,
                  max: 6,
                  divisions: 5,
                  label: _crossAxisCount.round().toString(),
                  onChanged: (v) => setState(() => _crossAxisCount = v),
                ),
              ),
              SizedBox(
                width: 24,
                child: Text(_crossAxisCount.round().toString()),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const SizedBox(width: 100, child: Text('aspectRatio')),
              Expanded(
                child: Slider(
                  value: _aspectRatio,
                  min: 0.5,
                  max: 3,
                  divisions: 25,
                  label: _aspectRatio.toStringAsFixed(1),
                  onChanged: (v) => setState(() => _aspectRatio = v),
                ),
              ),
              SizedBox(width: 32, child: Text(_aspectRatio.toStringAsFixed(1))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount.round(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: _aspectRatio,
            ),
            itemCount: 40,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.indigo.withValues(alpha: 0.6),
                alignment: Alignment.center,
                child: Text(
                  '#$index',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
