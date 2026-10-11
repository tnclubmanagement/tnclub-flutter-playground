import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về lưu dữ liệu LÂU DÀI trên máy (khác với lưu token nhạy
/// cảm - xem Login & Credential cheat sheet dùng flutter_secure_storage).
class LocalStorageCheatsheet extends StatelessWidget {
  const LocalStorageCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'shared_preferences (lưu setting đơn giản)',
      category: 'Key-value đơn giản',
      description:
          'Lưu các giá trị ĐƠN GIẢN (bool/int/double/String/List<String>) '
          'dạng key-value, tồn tại qua các lần MỞ LẠI app (khác biến '
          'thường trong memory - mất khi tắt app). Hay dùng cho setting: '
          'dark mode đang bật/tắt, ngôn ngữ đã chọn, "đã xem hướng dẫn '
          'chưa"...',
      snippet: '''
final prefs = await SharedPreferences.getInstance();

// Lưu
await prefs.setBool('dark_mode', true);

// Đọc lại (vd lúc khởi động app)
final isDark = prefs.getBool('dark_mode') ?? false;

// Xoá
await prefs.remove('dark_mode');''',
      preview: (_) => const _SharedPreferencesDemo(),
    ),
    CheatsheetEntry(
      name: 'KHÔNG lưu token/mật khẩu ở đây',
      category: 'Key-value đơn giản',
      description:
          '`shared_preferences` lưu file THƯỜNG (không mã hoá) - đủ an '
          'toàn cho setting, nhưng KHÔNG phù hợp cho access token, '
          'refresh token, hay mật khẩu (xem lại mục '
          '`flutter_secure_storage` ở Login & Credential cheat sheet - '
          'lưu vào Keychain/Keystore được hệ điều hành mã hoá).',
      snippet: '''
// SAI: token là dữ liệu nhạy cảm, không nên lưu bằng SharedPreferences
await prefs.setString('access_token', token);

// ĐÚNG: dùng flutter_secure_storage (xem Login & Credential cheat sheet)
await secureStorage.write(key: 'access_token', value: token);''',
      preview: (_) => const _NotForSecretsDemo(),
    ),
    CheatsheetEntry(
      name: 'Khi nào cần database thật (sqlite/drift/hive)?',
      category: 'Database local',
      description:
          'Khi dữ liệu có CẤU TRÚC (nhiều bảng/quan hệ) hoặc SỐ LƯỢNG LỚN '
          'cần query/lọc/sắp xếp (vd offline-first: danh sách đơn hàng, '
          'ghi chú, lịch sử chat...) - `shared_preferences` không phù hợp '
          '(không query được, chỉ đọc/ghi theo key). `sqlite`/`drift` cho '
          'SQL thật, `hive`/`isar` cho NoSQL nhanh hơn nhưng kém linh hoạt '
          'khi cần quan hệ giữa nhiều bảng.',
      snippet: '''
// drift (SQL, type-safe) - định nghĩa bảng như class:
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
}

final notes = await db.select(db.notes).get(); // query thật, lọc/sort được

// hive (NoSQL, đơn giản hơn) - lưu object trực tiếp:
final box = await Hive.openBox('notes');
await box.put('note1', Note(title: 'Mua sữa'));''',
      preview: (_) => const _DatabaseComparisonDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: 'Local Storage cheat sheet',
      intro:
          'shared_preferences/drift/hive KHÔNG có trong app demo này - '
          'preview mô phỏng bằng biến trong memory (mất khi hot-reload) '
          'để minh hoạ API, không lưu thật qua lần mở app.',
      items: _items,
    );
  }
}

class _SharedPreferencesDemo extends StatefulWidget {
  const _SharedPreferencesDemo();

  @override
  State<_SharedPreferencesDemo> createState() => _SharedPreferencesDemoState();
}

class _SharedPreferencesDemoState extends State<_SharedPreferencesDemo> {
  bool? _darkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _darkMode == null ? 'Chưa lưu gì' : 'dark_mode = $_darkMode',
          style: const TextStyle(fontSize: 11),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => _darkMode = true),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('setBool(true)', style: TextStyle(fontSize: 11)),
            ),
            OutlinedButton(
              onPressed: () => setState(() => _darkMode = null),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('remove()', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }
}

class _NotForSecretsDemo extends StatelessWidget {
  const _NotForSecretsDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: [
            Icon(Icons.description_outlined, size: 20, color: Colors.grey.shade600),
            const Text('SharedPreferences\n(file thường)', style: TextStyle(fontSize: 10)),
            const SizedBox(width: 10),
            const Icon(Icons.lock, size: 20, color: Colors.green),
            const Text('secure_storage\n(mã hoá OS)', style: TextStyle(fontSize: 10)),
          ],
        ),
        const CheatsheetHint('Token/mật khẩu -> luôn đi bên phải'),
      ],
    );
  }
}

class _DatabaseComparisonDemo extends StatelessWidget {
  const _DatabaseComparisonDemo();

  Widget _row(String name, String note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 60, child: Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
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
        _row('prefs', 'Key-value đơn giản, không query được'),
        _row('drift', 'SQL thật, type-safe, có quan hệ giữa bảng'),
        _row('hive', 'NoSQL nhanh, đơn giản hơn drift'),
      ],
    );
  }
}
