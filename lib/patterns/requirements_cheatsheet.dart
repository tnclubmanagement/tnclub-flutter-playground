import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Checklist những gì người học nên chuẩn bị trước khi bắt đầu với Flutter.
class RequirementsCheatsheet extends StatelessWidget {
  const RequirementsCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'Kiến thức lập trình cơ bản',
      category: 'Nền tảng nên có',
      description:
          'Không cần giỏi một ngôn ngữ cụ thể, nhưng nên biết biến, kiểu dữ '
          'liệu, hàm, điều kiện, vòng lặp và cách đọc lỗi. Nếu chưa biết, '
          'bạn vẫn có thể học song song trong phần Dart cơ bản.',
      snippet: '''
// Những khái niệm sẽ gặp thường xuyên:
final name = 'Flutter';
if (name.isNotEmpty) {
  print('Hello \$name');
}

for (final item in ['Dart', 'Flutter']) {
  print(item);
}''',
      preview: (_) => const _RequirementPreview(
        icon: Icons.code,
        title: 'Sẵn sàng học code',
        items: ['Biến và kiểu dữ liệu', 'Hàm', 'Điều kiện và vòng lặp'],
      ),
    ),
    CheatsheetEntry(
      name: 'Máy tính và hệ điều hành',
      category: 'Thiết bị',
      description:
          'Bạn cần một máy tính có thể cài Flutter SDK và IDE. Windows, '
          'macOS hoặc Linux đều được. macOS là bắt buộc nếu muốn build và '
          'phát hành ứng dụng iOS.',
      snippet: '''
// Kiểm tra hệ điều hành và kiến trúc máy:
flutter doctor -v

// Flutter hỗ trợ:
// Windows / macOS / Linux''',
      preview: (_) => const _RequirementPreview(
        icon: Icons.laptop_mac,
        title: 'Thiết bị học tập',
        items: [
          'Windows, macOS hoặc Linux',
          'Kết nối Internet',
          'Đủ dung lượng cài SDK',
        ],
      ),
    ),
    CheatsheetEntry(
      name: 'Flutter SDK và IDE',
      category: 'Công cụ cần cài',
      description:
          'Cài Flutter SDK từ flutter.dev và chọn một IDE để viết code. '
          'VS Code nhẹ, dễ bắt đầu; Android Studio có sẵn nhiều công cụ '
          'cho Android. Sau khi cài, chạy `flutter doctor` để kiểm tra.',
      snippet: '''
# Sau khi cài Flutter SDK:
flutter doctor -v

# Kiểm tra thiết bị có thể chạy app:
flutter devices''',
      preview: (_) => const _RequirementPreview(
        icon: Icons.build,
        title: 'Bộ công cụ cơ bản',
        items: [
          'Flutter SDK',
          'VS Code hoặc Android Studio',
          'Flutter và Dart extension',
        ],
      ),
    ),
    CheatsheetEntry(
      name: 'Thiết bị chạy thử ứng dụng',
      category: 'Chạy ứng dụng',
      description:
          'Bạn có thể chạy app trên Chrome để bắt đầu nhanh nhất, hoặc dùng '
          'Android Emulator, iOS Simulator hay điện thoại thật. Người mới '
          'không nhất thiết phải cài tất cả thiết bị ngay từ đầu.',
      snippet: '''
# Cách đơn giản nhất để chạy thử trên trình duyệt:
flutter devices
flutter run -d chrome

# Hoặc chạy trên thiết bị cụ thể:
flutter run -d <device-id>''',
      preview: (_) => const _RequirementPreview(
        icon: Icons.devices,
        title: 'Chọn một thiết bị để bắt đầu',
        items: [
          'Chrome',
          'Android Emulator / điện thoại Android',
          'iOS Simulator trên macOS',
        ],
      ),
    ),
    CheatsheetEntry(
      name: 'Tinh thần học theo từng bước',
      category: 'Cách học',
      description:
          'Flutter có khá nhiều widget và khái niệm. Hãy bắt đầu từ Dart, '
          'widget cơ bản và layout trước, sau đó mới học state, gọi API và '
          'đóng gói ứng dụng. Quan trọng nhất là tự gõ code và thử thay đổi '
          'ví dụ thay vì chỉ đọc.',
      snippet: '''
// Lộ trình gợi ý:
// 1. Dart cơ bản
// 2. Widget và layout
// 3. State và navigation
// 4. API, lưu trữ và testing
// 5. Build và deploy''',
      preview: (_) => const _RequirementPreview(
        icon: Icons.route,
        title: 'Lộ trình học gợi ý',
        items: ['Dart cơ bản', 'Widget và layout', 'State, API và deploy'],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: '✅ Yêu cầu trước khi học',
      intro:
          'Trang này giúp bạn kiểm tra những gì cần chuẩn bị trước khi bắt '
          'đầu học Flutter. Không cần hoàn hảo ngay từ đầu - chỉ cần chuẩn '
          'bị đủ để bắt đầu và học thêm trong quá trình thực hành.',
      items: _items,
    );
  }
}

class _RequirementPreview extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;

  const _RequirementPreview({
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: colorScheme.primary),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(child: Text(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
