import 'package:flutter/material.dart';

/// Pattern: InheritedWidget
///
/// Cách Flutter "chia sẻ" dữ liệu xuống toàn bộ widget con bên dưới mà KHÔNG
/// cần truyền qua constructor của từng widget trung gian (tránh "prop
/// drilling"). Đây chính là cơ chế lõi mà Theme.of(context),
/// MediaQuery.of(context), và các package như provider đều dựa vào.
///
/// 3 mảnh ghép:
/// 1. `CounterScope` (InheritedWidget): giữ `count` + callback `increment`.
/// 2. `CounterScope.of(context)`: widget con gọi để "đọc" dữ liệu, tự động
///    đăng ký rebuild khi `updateShouldNotify` trả về true.
/// 3. 1 StatefulWidget cha bọc ngoài để thực sự giữ state và rebuild lại
///    CounterScope mỗi khi count đổi.
class CounterScope extends InheritedWidget {
  final int count;
  final VoidCallback increment;

  const CounterScope({
    super.key,
    required this.count,
    required this.increment,
    required super.child,
  });

  static CounterScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CounterScope>();
    assert(scope != null, 'Không tìm thấy CounterScope ở trên context này');
    return scope!;
  }

  @override
  bool updateShouldNotify(CounterScope oldWidget) => count != oldWidget.count;
}

class InheritedWidgetPattern extends StatefulWidget {
  const InheritedWidgetPattern({super.key});

  @override
  State<InheritedWidgetPattern> createState() => _InheritedWidgetPatternState();
}

class _InheritedWidgetPatternState extends State<InheritedWidgetPattern> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return CounterScope(
      count: _count,
      increment: () => setState(() => _count++),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Giá trị count được đọc ở 3 widget con nằm sâu nhiều lớp bên '
            'dưới, không có widget trung gian nào cần nhận count qua '
            'constructor:',
          ),
          SizedBox(height: 16),
          _Level1(),
        ],
      ),
    );
  }
}

/// 3 lớp widget lồng nhau, KHÔNG widget nào nhận `count` qua constructor.
class _Level1 extends StatelessWidget {
  const _Level1();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Level 1'), SizedBox(height: 8), _Level2()],
        ),
      ),
    );
  }
}

class _Level2 extends StatelessWidget {
  const _Level2();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [Text('Level 2'), SizedBox(height: 8), _Level3()],
      ),
    );
  }
}

class _Level3 extends StatelessWidget {
  const _Level3();

  @override
  Widget build(BuildContext context) {
    // Đọc trực tiếp từ context, không cần Level1/Level2 "chuyền tay" count.
    final scope = CounterScope.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Text(
            'Level 3 - count: ${scope.count}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: scope.increment, child: const Text('+1')),
        ],
      ),
    );
  }
}
