import 'package:flutter/material.dart';

/// Demo: StatelessWidget vs StatefulWidget
///
/// Đây là khái niệm NỀN TẢNG NHẤT của Flutter - nên hiểu trước khi học các
/// demo layout khác (Row/Column/Stack...), vì MỌI demo sau này đều là 1
/// trong 2 loại widget này.
///
/// - StatelessWidget: KHÔNG tự thay đổi theo thời gian - `build()` chỉ chạy
///   lại khi widget cha truyền prop mới xuống. Dùng cho UI tĩnh (Text, Icon,
///   hoặc cả 1 card hiển thị dữ liệu có sẵn).
/// - StatefulWidget: CÓ thể tự thay đổi - giữ 1 object `State` riêng, gọi
///   `setState(() { ... })` để báo Flutter "dữ liệu vừa đổi, vẽ lại UI".
///   Dùng khi cần nhớ 1 giá trị thay đổi theo tương tác (bấm nút, gõ chữ...).
class StatelessVsStatefulDemo extends StatelessWidget {
  const StatelessVsStatefulDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '1. StatelessWidget - "tĩnh", không tự đổi theo thời gian',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const _GreetingCard(name: 'Lan'),
        const SizedBox(height: 4),
        const Text(
          'Card này nhận "name" từ bên ngoài (constructor) và CHỈ hiện lại '
          'khác đi nếu widget cha truyền "name" khác - tự nó không có nút '
          'bấm nào làm nó đổi.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 24),
        const Text(
          '2. StatefulWidget - giữ state riêng, tự thay đổi khi tương tác',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const _CounterCard(),
        const SizedBox(height: 4),
        const Text(
          'Bấm nút "+" - setState() báo Flutter "count vừa đổi, vẽ lại '
          'card này". Không bấm thì card KHÔNG tự đổi (giống Stateless).',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: const Text(
            '💡 Quy tắc chọn nhanh: nếu widget của bạn có BIẾN nào đó sẽ '
            'thay đổi sau khi màn hình đã hiện ra (do bấm nút, load data, '
            'đếm giờ...) -> dùng StatefulWidget. Nếu chỉ hiện dữ liệu có '
            'sẵn, không đổi gì sau đó -> StatelessWidget (nhẹ hơn, Flutter '
            'tối ưu tốt hơn).',
            style: TextStyle(fontSize: 12.5),
          ),
        ),
      ],
    );
  }
}

/// StatelessWidget: không có field nào thay đổi SAU KHI đã tạo - "name" chỉ
/// được gán 1 LẦN DUY NHẤT lúc constructor chạy (field `final`).
class _GreetingCard extends StatelessWidget {
  final String name;

  const _GreetingCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.waving_hand, color: Colors.orange),
            const SizedBox(width: 12),
            Text('Xin chào, $name!', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

/// StatefulWidget: tách làm 2 class - widget "khai báo" (bất biến) và 1
/// object State riêng giữ dữ liệu có thể đổi (`_count`) + logic `setState`.
class _CounterCard extends StatefulWidget {
  const _CounterCard();

  @override
  State<_CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<_CounterCard> {
  // "_count" sống trong State, KHÔNG mất đi giữa các lần build() (khác
  // biến local trong hàm build() thông thường sẽ bị tạo lại mỗi lần).
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.pin, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Text('Đã bấm: $_count lần', style: const TextStyle(fontSize: 16)),
            const Spacer(),
            IconButton.filled(
              onPressed: () {
                // setState: ĐỔI dữ liệu + báo Flutter build() lại Widget
                // này. Quên gọi setState -> _count vẫn đổi trong bộ nhớ
                // nhưng UI KHÔNG vẽ lại, nhìn như nút không hoạt động.
                setState(() => _count++);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
