import 'package:flutter/material.dart';

/// Pattern: ValueNotifier + ValueListenableBuilder
///
/// Thay vì gọi setState() (rebuild NGUYÊN widget chứa State), ta có thể tách
/// riêng 1 giá trị ra thành `ValueNotifier<T>` rồi dùng ValueListenableBuilder
/// để CHỈ rebuild đúng phần UI phụ thuộc vào giá trị đó.
///
/// - setState(): đơn giản, nhưng rebuild cả build() method -> tốn hơn nếu
///   widget có nhiều phần không liên quan đến giá trị thay đổi.
/// - ValueNotifier + ValueListenableBuilder: tách state ra khỏi widget, nhiều
///   widget khác nhau có thể cùng lắng nghe 1 ValueNotifier mà không cần
///   truyền callback qua nhiều lớp (tiền đề cho các lib như provider/riverpod).
class ValueNotifierPattern extends StatefulWidget {
  const ValueNotifierPattern({super.key});

  @override
  State<ValueNotifierPattern> createState() => _ValueNotifierPatternState();
}

class _ValueNotifierPatternState extends State<ValueNotifierPattern> {
  // ValueNotifier sống độc lập với State, không bị huỷ/tạo lại theo build().
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dòng debug này sẽ KHÔNG chạy lại khi bấm nút +1, vì tăng _counter
    // không gọi setState() của widget này -> chứng minh build() cha không
    // bị rebuild, chỉ ValueListenableBuilder bên trong rebuild.
    debugPrint('ValueNotifierPattern.build() chạy lúc: ${DateTime.now()}');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Mỗi lần bấm "+1", chỉ ô số bên dưới rebuild (xem log debugPrint '
          'trong console: build() của cả trang KHÔNG chạy lại).',
        ),
        const SizedBox(height: 16),
        Center(
          child: ValueListenableBuilder<int>(
            valueListenable: _counter,
            builder: (context, value, child) {
              return Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _counter.value--,
              child: const Text('-1'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => _counter.value++,
              child: const Text('+1'),
            ),
          ],
        ),
      ],
    );
  }
}
