import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về các cách QUẢN LÝ STATE hay gặp: từ `setState` nội bộ, tới
/// `ChangeNotifier` chia sẻ giữa nhiều widget (built-in, không cần package),
/// rồi `package:provider` (bọc gọn lại đúng thứ đã tự viết ở mục trước), và
/// khi nào nên nhảy sang Riverpod/Bloc.
///
/// `provider`/`riverpod`/`bloc` KHÔNG có trong pubspec.yaml của app demo
/// này - những mục liên quan chỉ có code mẫu, không có preview chạy thật.
class StateManagementCheatsheet extends StatelessWidget {
  const StateManagementCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'setState - state CỤC BỘ trong 1 widget',
      category: 'Built-in (không cần package)',
      description:
          'Cách đơn giản nhất: state chỉ cần biết bởi 1 `StatefulWidget` '
          'DUY NHẤT (không có widget khác cần đọc/sửa). Gọi `setState()` '
          'để báo Flutter rebuild lại đúng widget đó.',
      snippet: '''
class Counter extends StatefulWidget {
  const Counter({super.key});
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => _count++),
      child: Text('\$_count'),
    );
  }
}''',
      preview: (_) => const _SetStateDemo(),
    ),
    CheatsheetEntry(
      name:
          'ChangeNotifier + AnimatedBuilder (chia sẻ state, KHÔNG cần package)',
      category: 'Built-in (không cần package)',
      description:
          'Khi NHIỀU widget (ở các vị trí khác nhau trong tree) cùng cần '
          'đọc/đổi 1 state - dùng `ChangeNotifier` (built-in `dart:core`/'
          '`foundation`) + `AnimatedBuilder` để LẮNG NGHE nó (vì '
          '`ChangeNotifier` cũng là 1 `Listenable`, giống `AnimationController` '
          'ở Animation cheat sheet). Đây CHÍNH LÀ cơ chế bên dưới của '
          '`package:provider`.',
      snippet: '''
class CartModel extends ChangeNotifier {
  int _itemCount = 0;
  int get itemCount => _itemCount;

  void add() {
    _itemCount++;
    notifyListeners(); // báo cho MỌI widget đang nghe rebuild lại
  }
}

final cart = CartModel(); // 1 instance DUY NHẤT, chia sẻ cho nhiều widget

// Ở bất kỳ đâu trong tree, lắng nghe và rebuild khi cart đổi:
AnimatedBuilder(
  animation: cart,
  builder: (context, _) => Text('Giỏ hàng: \${cart.itemCount}'),
)''',
      preview: (_) => const _ChangeNotifierDemo(),
    ),
    CheatsheetEntry(
      name: 'package:provider (bọc gọn ChangeNotifier)',
      category: 'package:provider',
      description:
          '`provider` làm đúng việc ở mục trên nhưng gọn hơn: '
          '`ChangeNotifierProvider` đặt instance vào tree (tự `dispose()` '
          'khi không cần nữa), `context.watch<T>()`/`Consumer<T>` thay cho '
          'tự viết `AnimatedBuilder`, và `context.read<T>()` để gọi '
          'method mà KHÔNG rebuild khi state đổi.',
      snippet: '''
// 1. Đặt CartModel vào tree (thường ở gần root hoặc trên route cần dùng):
ChangeNotifierProvider(
  create: (context) => CartModel(),
  child: const MyApp(),
)

// 2. Đọc + tự rebuild khi đổi:
Text('Giỏ hàng: \${context.watch<CartModel>().itemCount}')

// 3. Gọi method, KHÔNG cần rebuild widget này:
ElevatedButton(
  onPressed: () => context.read<CartModel>().add(),
  child: const Text('Thêm vào giỏ'),
)''',
      preview: (_) => const _ProviderConceptDemo(),
    ),
    CheatsheetEntry(
      name: 'Khi nào cần Riverpod/Bloc thay vì tự viết?',
      category: 'So sánh & lựa chọn',
      description:
          'ChangeNotifier/Provider đủ cho app NHỎ-VỪA. Khi app lớn hơn, '
          'cân nhắc: `riverpod` (giống provider nhưng không cần '
          'BuildContext để đọc state, dễ test hơn, bắt lỗi lúc compile '
          'thay vì runtime), hoặc `bloc`/`flutter_bloc` (tách rõ '
          '"event -> state" theo luồng 1 chiều, tốt cho team lớn cần quy '
          'ước nghiêm ngặt, đổi lại code "dài dòng" hơn).',
      snippet: '''
// Provider: cần BuildContext, lỗi thiếu Provider chỉ phát hiện lúc RUNTIME
context.watch<CartModel>();

// Riverpod: không cần context, lỗi thiếu Provider phát hiện lúc COMPILE
final cart = ref.watch(cartProvider);

// Bloc: tách riêng Event (hành động) và State (kết quả), 1 chiều rõ ràng
class AddItem extends CartEvent {}
on<AddItem>((event, emit) => emit(state.copyWith(itemCount: state.itemCount + 1)));''',
      preview: (_) => const _ComparisonDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'State Management cheat sheet',
      intro:
          'provider/riverpod/bloc KHÔNG có trong app demo này - 2 mục đầu '
          'chạy THẬT bằng ChangeNotifier built-in (chính là cơ chế provider '
          'dùng bên dưới), 2 mục sau chỉ có code mẫu để so sánh.',
      items: _items,
    );
  }
}

class _SetStateDemo extends StatefulWidget {
  const _SetStateDemo();

  @override
  State<_SetStateDemo> createState() => _SetStateDemoState();
}

class _SetStateDemoState extends State<_SetStateDemo> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$_count',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        OutlinedButton(
          onPressed: () => setState(() => _count++),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: const Text(
            '+1 (chỉ widget này rebuild)',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }
}

/// ChangeNotifier dùng chung giữa 2 "widget con" độc lập trong demo dưới,
/// để thấy rõ: sửa ở nút A, cả 2 nơi hiển thị đều tự cập nhật.
class _CartModel extends ChangeNotifier {
  int _itemCount = 0;
  int get itemCount => _itemCount;

  void add() {
    _itemCount++;
    notifyListeners();
  }

  void reset() {
    _itemCount = 0;
    notifyListeners();
  }
}

class _ChangeNotifierDemo extends StatefulWidget {
  const _ChangeNotifierDemo();

  @override
  State<_ChangeNotifierDemo> createState() => _ChangeNotifierDemoState();
}

class _ChangeNotifierDemoState extends State<_ChangeNotifierDemo> {
  final _cart = _CartModel();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CartBadge(cart: _cart, label: 'Widget A'),
            const SizedBox(width: 16),
            _CartBadge(cart: _cart, label: 'Widget B'),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _cart.add,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: const Text(
            'Thêm vào giỏ (ở ngoài)',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }
}

/// 2 chỗ hiển thị ĐỘC LẬP, không truyền `itemCount` qua constructor - chỉ
/// nghe chung 1 `_cart` để tự cập nhật.
class _CartBadge extends StatelessWidget {
  final _CartModel cart;
  final String label;

  const _CartBadge({required this.cart, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 10)),
          Text(
            '${cart.itemCount}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// "package:provider": mô phỏng context.watch bằng cùng _CartModel, nhấn
/// mạnh code GỌN hơn mục trước (không cần tự viết AnimatedBuilder).
class _ProviderConceptDemo extends StatefulWidget {
  const _ProviderConceptDemo();

  @override
  State<_ProviderConceptDemo> createState() => _ProviderConceptDemoState();
}

class _ProviderConceptDemoState extends State<_ProviderConceptDemo> {
  final _cart = _CartModel();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _cart,
          builder: (context, _) => Text(
            'Giỏ hàng: ${_cart.itemCount}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        const CheatsheetHint('Giống context.watch<CartModel>() của provider'),
        const SizedBox(height: 4),
        OutlinedButton(
          onPressed: _cart.add,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: const Text(
            'context.read<CartModel>().add()',
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _ComparisonDemo extends StatelessWidget {
  const _ComparisonDemo();

  Widget _row(BuildContext context, String name, String note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              name,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(note, style: const TextStyle(fontSize: 11))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(context, 'Provider', 'Đơn giản, cần BuildContext'),
        _row(context, 'Riverpod', 'Không cần context, an toàn lúc compile'),
        _row(context, 'Bloc', '1 chiều rõ ràng, phù hợp team lớn'),
      ],
    );
  }
}
