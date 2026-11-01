import 'package:flutter/material.dart';

/// Pattern: Extension method
///
/// Extension cho phép "gắn thêm" method/getter vào 1 type có sẵn (num,
/// BuildContext, String, ...) mà không cần kế thừa hay sửa source gốc. Rất
/// hay dùng để viết code layout gọn hơn (ví dụ: `16.heightBox` thay cho
/// `const SizedBox(height: 16)`, hoặc `context.colorScheme` thay cho
/// `Theme.of(context).colorScheme`).
extension SpacingExtension on num {
  /// `16.heightBox` == `SizedBox(height: 16)`
  Widget get heightBox => SizedBox(height: toDouble());

  /// `16.widthBox` == `SizedBox(width: 16)`
  Widget get widthBox => SizedBox(width: toDouble());
}

extension BuildContextExtension on BuildContext {
  /// `context.colorScheme` == `Theme.of(context).colorScheme`
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// `context.textTheme` == `Theme.of(context).textTheme`
  TextTheme get textTheme => Theme.of(this).textTheme;
}

class ExtensionPattern extends StatelessWidget {
  const ExtensionPattern({super.key});

  Widget _demoBox(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Dùng extension context.colorScheme thay vì Theme.of(context)....
        color: context.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: context.textTheme.bodyMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Trước khi có extension (dài, lặp lại Theme.of(context)):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Container không dùng extension',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 16), // thay cho: SizedBox(height: 16)
        const Text(
          'Sau khi có extension (gọn, đọc tự nhiên như tiếng Anh):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _demoBox(context, 'Container dùng context.colorScheme/textTheme'),
        16.heightBox, // <- extension trên num, thay cho SizedBox(height: 16)
        Row(
          children: [
            _demoBox(context, 'Box A'),
            16.widthBox, // <- extension trên num, thay cho SizedBox(width: 16)
            _demoBox(context, 'Box B'),
          ],
        ),
      ],
    );
  }
}
