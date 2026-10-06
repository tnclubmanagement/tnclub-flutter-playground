import 'package:flutter/material.dart';

/// Demo: EdgeInsets
///
/// EdgeInsets mô tả khoảng cách (offset) cho 4 cạnh trái/phải/trên/dưới, dùng
/// cho padding, margin, v.v. Các constructor hay dùng:
/// - EdgeInsets.all(value): 4 cạnh bằng nhau.
/// - EdgeInsets.symmetric(horizontal:, vertical:): đối xứng theo trục ngang/dọc.
/// - EdgeInsets.only(left:, top:, right:, bottom:): chỉ set cạnh cần, cạnh còn
///   lại mặc định = 0.
/// - EdgeInsets.fromLTRB(left, top, right, bottom): set đủ 4 cạnh theo thứ tự.
/// - EdgeInsets.zero: không có khoảng cách nào cả (không có thông số để chỉnh).
/// - EdgeInsetsDirectional.only(start:, end:): giống only() nhưng "start/end"
///   tự đổi theo hướng chữ (LTR/RTL) thay vì cố định "left/right".
class EdgeInsetsDemo extends StatefulWidget {
  const EdgeInsetsDemo({super.key});

  @override
  State<EdgeInsetsDemo> createState() => _EdgeInsetsDemoState();
}

class _EdgeInsetsDemoState extends State<EdgeInsetsDemo> {
  // EdgeInsets.fromLTRB
  double _left = 16;
  double _top = 16;
  double _right = 16;
  double _bottom = 16;

  // EdgeInsets.all
  double _all = 16;

  // EdgeInsets.symmetric
  double _symHorizontal = 32;
  double _symVertical = 8;

  // EdgeInsets.only
  double _onlyLeft = 40;
  double _onlyTop = 8;

  // EdgeInsetsDirectional.only
  double _directionalStart = 40;

  Widget _slider(
    String label,
    double value,
    ValueChanged<double> onChanged, {
    double max = 60,
  }) {
    return Row(
      children: [
        SizedBox(width: 56, child: Text(label)),
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

  Widget _preview(EdgeInsetsGeometry padding) {
    return Container(
      color: Colors.grey.shade300,
      child: Padding(
        padding: padding,
        child: Container(
          color: Colors.deepPurple,
          alignment: Alignment.center,
          height: 60,
          child: const Text('content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> sliders, Widget preview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...sliders,
        const SizedBox(height: 8),
        preview,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section(
          'EdgeInsets.all(${_all.round()}): cả 4 cạnh bằng nhau',
          [_slider('value', _all, (v) => setState(() => _all = v))],
          _preview(EdgeInsets.all(_all)),
        ),
        const SizedBox(height: 24),
        _section(
          'EdgeInsets.symmetric(horizontal: ${_symHorizontal.round()}, '
          'vertical: ${_symVertical.round()})',
          [
            _slider(
              'horizontal',
              _symHorizontal,
              (v) => setState(() => _symHorizontal = v),
            ),
            _slider(
              'vertical',
              _symVertical,
              (v) => setState(() => _symVertical = v),
            ),
          ],
          _preview(
            EdgeInsets.symmetric(
              horizontal: _symHorizontal,
              vertical: _symVertical,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _section(
          'EdgeInsets.only(left: ${_onlyLeft.round()}, top: '
          '${_onlyTop.round()}): chỉ set cạnh cần, còn lại = 0',
          [
            _slider(
              'left',
              _onlyLeft,
              (v) => setState(() => _onlyLeft = v),
            ),
            _slider('top', _onlyTop, (v) => setState(() => _onlyTop = v)),
          ],
          _preview(EdgeInsets.only(left: _onlyLeft, top: _onlyTop)),
        ),
        const SizedBox(height: 24),
        _section(
          'EdgeInsets.fromLTRB(${_left.round()}, ${_top.round()}, '
          '${_right.round()}, ${_bottom.round()}): set đủ 4 cạnh theo thứ tự '
          'left, top, right, bottom',
          [
            _slider('left', _left, (v) => setState(() => _left = v)),
            _slider('top', _top, (v) => setState(() => _top = v)),
            _slider('right', _right, (v) => setState(() => _right = v)),
            _slider('bottom', _bottom, (v) => setState(() => _bottom = v)),
          ],
          _preview(EdgeInsets.fromLTRB(_left, _top, _right, _bottom)),
        ),
        const SizedBox(height: 24),
        _section(
          'EdgeInsets.zero: không có khoảng cách nào (không có thông số)',
          const [],
          _preview(EdgeInsets.zero),
        ),
        const SizedBox(height: 24),
        Text(
          'EdgeInsetsDirectional.only(start: ${_directionalStart.round()}): '
          'tự đổi left/right theo hướng văn bản (LTR/RTL), hữu ích khi hỗ trợ '
          'đa ngôn ngữ:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _slider(
          'start',
          _directionalStart,
          (v) => setState(() => _directionalStart = v),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Directionality.ltr (bình thường):'),
                  const SizedBox(height: 8),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: _directionalStart,
                        ),
                        child: Container(
                          color: Colors.teal,
                          alignment: Alignment.center,
                          height: 60,
                          child: Text(
                            'start:${_directionalStart.round()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Directionality.rtl (start đổi sang phải):'),
                  const SizedBox(height: 8),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: _directionalStart,
                        ),
                        child: Container(
                          color: Colors.teal,
                          alignment: Alignment.center,
                          height: 60,
                          child: Text(
                            'start:${_directionalStart.round()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
