import 'package:flutter/material.dart';

/// Demo: Container & Constraints
///
/// Nguyên tắc vàng của Flutter layout: "Constraints go down. Sizes go up.
/// Parent sets position."
/// - Parent truyền BoxConstraints (min/max width & height) xuống child.
/// - Child tự quyết định size của mình trong giới hạn đó, rồi báo lại cho parent.
/// - Container có width/height cố định sẽ "ăn" constraints đó nếu parent cho phép.
class ContainerConstraintsDemo extends StatefulWidget {
  const ContainerConstraintsDemo({super.key});

  @override
  State<ContainerConstraintsDemo> createState() =>
      _ContainerConstraintsDemoState();
}

class _ContainerConstraintsDemoState extends State<ContainerConstraintsDemo> {
  double _padding = 16;
  double _margin = 16;

  double _minWidth = 100;
  double _maxWidth = 200;
  double _minHeight = 60;

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label)),
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Tự chỉnh padding/margin:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _slider(
          'padding',
          _padding,
          0,
          40,
          (v) => setState(() => _padding = v),
        ),
        _slider('margin', _margin, 0, 40, (v) => setState(() => _margin = v)),
        const SizedBox(height: 8),
        Container(
          color: Colors.grey.shade300,
          child: Container(
            margin: EdgeInsets.all(_margin), // khoảng trống BÊN NGOÀI
            padding: EdgeInsets.all(_padding), // khoảng trống BÊN TRONG
            color: Colors.deepPurple,
            child: Text(
              'margin=${_margin.round()} (tách khỏi nền xám)\n'
              'padding=${_padding.round()} (tách khỏi nội dung)',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Tự chỉnh BoxConstraints: min/max width & height',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _slider(
          'minWidth',
          _minWidth,
          0,
          300,
          (v) => setState(() => _minWidth = v),
        ),
        _slider(
          'maxWidth',
          _maxWidth,
          0,
          300,
          (v) => setState(() => _maxWidth = v),
        ),
        _slider(
          'minHeight',
          _minHeight,
          0,
          150,
          (v) => setState(() => _minHeight = v),
        ),
        const SizedBox(height: 8),
        Container(
          color: Colors.grey.shade200,
          child: ConstrainedBox(
            // maxWidth luôn >= minWidth để tránh BoxConstraints không hợp lệ
            // khi người dùng kéo 2 slider độc lập (vd minWidth=100 > maxWidth=99).
            constraints: BoxConstraints(
              minWidth: _minWidth,
              maxWidth: _maxWidth < _minWidth ? _minWidth : _maxWidth,
              minHeight: _minHeight,
            ),
            child: Container(
              // width: double.infinity để Container LUÔN cố lấp đầy chiều
              // rộng tối đa cho phép -> maxWidth/minWidth mới thực sự hiện
              // rõ trên hình (nếu không có dòng này, Container sẽ chỉ co lại
              // vừa đủ nội dung Text và maxWidth sẽ không có tác dụng thấy
              // được khi lớn hơn độ rộng nội dung).
              width: double.infinity,
              color: Colors.teal,
              alignment: Alignment.center,
              child: Text(
                'Nội dung ngắn\n(minWidth:${_minWidth.round()}, '
                'maxWidth:${_maxWidth.round()},\nminHeight:${_minHeight.round()})',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Container có width cố định NHƯNG nằm trong parent hẹp hơn '
          '-> parent (ví dụ Expanded/Row) vẫn có thể giới hạn kích thước thực tế:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 150, // parent giới hạn 150
          child: Container(
            width: 400, // child muốn 400 nhưng bị constraints ép lại
            height: 60,
            color: Colors.orange,
            alignment: Alignment.center,
            child: const Text(
              'width:400 nhưng parent chỉ cho 150',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'UnconstrainedBox: bỏ qua constraints của parent (có thể gây overflow)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 150,
          height: 60,
          child: UnconstrainedBox(
            child: Container(
              width: 250,
              color: Colors.red,
              alignment: Alignment.center,
              child: const Text(
                'width:250 thực sự',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
