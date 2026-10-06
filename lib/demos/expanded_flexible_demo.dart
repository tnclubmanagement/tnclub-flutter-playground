import 'package:flutter/material.dart';

/// Demo: Expanded & Flexible
///
/// - Expanded = Flexible(fit: FlexFit.tight) -> buộc child chiếm hết không gian
///   còn lại theo tỉ lệ `flex`.
/// - Flexible(fit: FlexFit.loose) -> child có thể nhỏ hơn không gian được cấp,
///   chỉ chiếm tối đa phần được chia.
class ExpandedFlexibleDemo extends StatefulWidget {
  const ExpandedFlexibleDemo({super.key});

  @override
  State<ExpandedFlexibleDemo> createState() => _ExpandedFlexibleDemoState();
}

class _ExpandedFlexibleDemoState extends State<ExpandedFlexibleDemo> {
  double _flex1 = 1;
  double _flex2 = 2;
  double _flex3 = 1;

  Widget _tile(String label, Color color) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _slider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(width: 56, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            min: 1,
            max: 5,
            divisions: 4,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 24, child: Text(value.round().toString())),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Tự chỉnh flex (${_flex1.round()} : ${_flex2.round()} : '
          '${_flex3.round()}):',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        _slider('flex 1', _flex1, (v) => setState(() => _flex1 = v)),
        _slider('flex 2', _flex2, (v) => setState(() => _flex2 = v)),
        _slider('flex 3', _flex3, (v) => setState(() => _flex3 = v)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: _flex1.round(),
              child: _tile('flex:${_flex1.round()}', Colors.red),
            ),
            Expanded(
              flex: _flex2.round(),
              child: _tile('flex:${_flex2.round()}', Colors.green),
            ),
            Expanded(
              flex: _flex3.round(),
              child: _tile('flex:${_flex3.round()}', Colors.blue),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Flexible (loose) vs Expanded (tight):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text(
          'Flexible.loose cho phép child nhỏ hơn không gian được chia '
          '(ở đây child có width cố định 60, không bị kéo giãn).',
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                width: 60,
                color: Colors.orange,
                padding: const EdgeInsets.all(12),
                alignment: Alignment.center,
                child: const Text(
                  'loose',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: _tile('Expanded (tight) - luôn lấp đầy', Colors.purple),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Kết hợp Expanded với Column:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Column(
            children: [
              Expanded(flex: 2, child: _tile('flex:2', Colors.teal)),
              Expanded(flex: 1, child: _tile('flex:1', Colors.indigo)),
            ],
          ),
        ),
      ],
    );
  }
}
