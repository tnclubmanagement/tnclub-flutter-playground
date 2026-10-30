import 'package:flutter/material.dart';

/// Pattern: Named constructor & Factory constructor
///
/// - Named constructor (`ClassName.name()`): nhiều cách tạo 1 object với bộ
///   tham số đã "đóng gói" sẵn theo ngữ cảnh, dễ đọc hơn so với 1 constructor
///   duy nhất với nhiều tham số optional.
/// - Factory constructor (`factory ClassName.name()`): giống named
///   constructor nhưng được PHÉP trả về object đã tồn tại (cache/singleton)
///   hoặc tự chọn implementation phù hợp, không bắt buộc tạo instance mới.
enum _BadgeKind { success, warning, error }

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const StatusBadge._(this.label, this.color, this.icon);

  // Named constructor: mỗi cái gán sẵn màu/icon phù hợp ngữ nghĩa, người gọi
  // không cần tự nhớ "success thì màu gì, icon gì".
  const StatusBadge.success(String label)
    : this._(label, Colors.green, Icons.check_circle);

  const StatusBadge.warning(String label)
    : this._(label, Colors.orange, Icons.warning_amber);

  const StatusBadge.error(String label)
    : this._(label, Colors.red, Icons.error);

  // Factory constructor: nhận 1 HTTP status code, TỰ QUYẾT ĐỊNH xem nên tạo
  // badge success/warning/error nào - logic chọn lựa nằm trong 1 chỗ duy
  // nhất, nơi gọi không cần biết chi tiết.
  factory StatusBadge.fromHttpCode(int code) {
    final kind = switch (code) {
      >= 200 && < 300 => _BadgeKind.success,
      >= 300 && < 500 => _BadgeKind.warning,
      _ => _BadgeKind.error,
    };
    return switch (kind) {
      _BadgeKind.success => StatusBadge.success('HTTP $code OK'),
      _BadgeKind.warning => StatusBadge.warning('HTTP $code'),
      _BadgeKind.error => StatusBadge.error('HTTP $code Error'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class ConstructorsPattern extends StatefulWidget {
  const ConstructorsPattern({super.key});

  @override
  State<ConstructorsPattern> createState() => _ConstructorsPatternState();
}

class _ConstructorsPatternState extends State<ConstructorsPattern> {
  int _code = 200;

  final List<int> _codes = const [200, 201, 301, 404, 500];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Named constructor: gọi trực tiếp theo ngữ nghĩa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatusBadge.success('Thành công'),
            StatusBadge.warning('Cần chú ý'),
            StatusBadge.error('Lỗi'),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Factory constructor: tự chọn kết quả dựa trên input',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('HTTP code:'),
            const SizedBox(width: 12),
            DropdownButton<int>(
              value: _code,
              items: _codes
                  .map((c) => DropdownMenuItem(value: c, child: Text('$c')))
                  .toList(),
              onChanged: (v) => setState(() => _code = v!),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StatusBadge.fromHttpCode(_code),
      ],
    );
  }
}
