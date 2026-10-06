import 'package:flutter/material.dart';

/// Demo: Stack & Positioned
///
/// - Stack chồng các children lên nhau theo thứ tự (child sau nằm trên child trước).
/// - Positioned định vị tuyệt đối theo các cạnh (top/right/bottom/left) của Stack.
/// - Align/Alignment định vị tương đối không cần biết kích thước chính xác.
class StackDemo extends StatefulWidget {
  const StackDemo({super.key});

  @override
  State<StackDemo> createState() => _StackDemoState();
}

class _StackDemoState extends State<StackDemo> {
  static const double _stackHeight = 220;
  double _top = 8;
  double _left = 8;

  Widget _slider(
    String label,
    double value,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(width: 40, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            min: 0,
            max: max,
            divisions: max.round(),
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Tự chỉnh vị trí Positioned(top, left) của badge màu cam:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _slider(
          'top',
          _top,
          _stackHeight - 24,
          (v) => setState(() => _top = v),
        ),
        _slider('left', _left, 300, (v) => setState(() => _left = v)),
        const SizedBox(height: 8),
        SizedBox(
          height: _stackHeight,
          child: Stack(
            children: [
              Container(color: Colors.blueGrey.shade100),
              Container(
                width: 180,
                height: 180,
                color: Colors.deepPurple.withValues(alpha: 0.7),
                alignment: Alignment.center,
                child: const Text(
                  'Nền (căn giữa Stack)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Positioned(top: 8, left: 8, child: _Badge('top-left')),
              const Positioned(top: 8, right: 8, child: _Badge('top-right')),
              const Positioned(
                bottom: 8,
                left: 8,
                child: _Badge('bottom-left'),
              ),
              const Positioned(
                bottom: 8,
                right: 8,
                child: _Badge('bottom-right'),
              ),
              const Align(
                alignment: Alignment.center,
                child: _Badge('Align.center', color: Colors.orange),
              ),
              Positioned(
                top: _top,
                left: _left,
                child: _Badge(
                  'top:${_top.round()}, left:${_left.round()}',
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Ứng dụng thực tế: avatar + badge thông báo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person, color: Colors.white, size: 32),
            ),
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '9',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge(this.text, {this.color = Colors.black87});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
