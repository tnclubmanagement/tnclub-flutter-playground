import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';

/// Cheat sheet về DEPLOY app lên thiết bị thật/store: chuẩn bị chung (tên,
/// icon, version), ký app + build cho Android (keystore, AAB/APK, Play
/// Console), build + ký cho iOS (Xcode signing, IPA, TestFlight/App Store
/// Connect - CHỈ làm được trên máy Mac), và checklist trước khi submit.
class DeployCheatsheet extends StatelessWidget {
  const DeployCheatsheet({super.key});

  static final _items = <CheatsheetEntry>[
    CheatsheetEntry(
      name: 'Quy trình deploy tổng quan',
      category: 'Tổng quan',
      description:
          'Deploy "lên thiết bị thật" (cắm dây/cài file build sẵn) và '
          '"lên store" (Play Store/App Store) là 2 việc khác nhau. Cắm dây '
          'chỉ cần build bản debug/release rồi cài trực tiếp - KHÔNG cần ký '
          '(Android) hoặc chỉ cần tài khoản Apple miễn phí (iOS, hạn 7 '
          'ngày). Lên store thì BẮT BUỘC ký đúng cách + có tài khoản nhà '
          'phát triển trả phí (Google Play: 25\$ 1 lần, Apple: 99\$/năm).',
      snippet: '''
# Cắm điện thoại Android qua USB (bật "USB debugging" trong Developer options)
flutter devices              # kiểm tra máy đã nhận diện thiết bị chưa
flutter run --release        # cài thẳng bản release lên máy đang cắm

# iOS: CHỈ build/chạy được trên máy Mac (Xcode là công cụ của Apple,
# không có bản Windows/Linux) - xem thêm mục "Deploy iOS" bên dưới.''',
      preview: (_) => const _OverviewDemo(),
    ),
    CheatsheetEntry(
      name: 'Tên app, icon, version - sửa ở đâu?',
      category: 'Chuẩn bị chung',
      description:
          'Trước khi build bản release, luôn kiểm tra 3 thứ này vì rất dễ '
          'quên: TÊN app hiển thị dưới icon (khai báo RIÊNG cho từng nền '
          'tảng, không nằm trong `pubspec.yaml`), ICON app (dùng package '
          '`flutter_launcher_icons` để sinh icon đúng kích thước cho mọi '
          'độ phân giải thay vì tự thay tay từng file), và VERSION '
          '(`version: 1.0.0+1` trong `pubspec.yaml` - số trước dấu `+` là '
          'bản hiển thị cho người dùng, số sau `+` là "build number" PHẢI '
          'tăng mỗi lần nộp lên store, kể cả khi version trước không đổi).',
      snippet: '''
# pubspec.yaml
version: 1.0.3+7   # 1.0.3 = version hiển thị, 7 = build number (tăng dần)

# Tên app:
#   Android -> android/app/src/main/AndroidManifest.xml (thuộc tính android:label)
#   iOS     -> ios/Runner/Info.plist (khoá CFBundleDisplayName)

# Icon: thêm package rồi chạy lệnh sinh icon cho MỌI độ phân giải 1 lần
flutter pub add flutter_launcher_icons --dev
dart run flutter_launcher_icons''',
      preview: (_) => const _AppIdentityDemo(),
    ),
    CheatsheetEntry(
      name: 'Android: tạo keystore để ký app (1 lần duy nhất)',
      category: 'Deploy Android',
      description:
          'Mọi app Android đưa lên Play Store đều phải được "ký" bằng 1 '
          'file keystore - coi như chữ ký số xác nhận ĐÚNG bạn là người '
          'phát hành app. Tạo 1 LẦN rồi dùng mãi mãi cho các bản cập nhật '
          'sau - MẤT file này hoặc quên mật khẩu thì KHÔNG THỂ cập nhật app '
          'cũ trên store nữa (phải phát hành app mới, mất hết review/cài '
          'đặt cũ). Tuyệt đối KHÔNG commit file keystore hay mật khẩu vào '
          'git - để ngoài repo (hoặc dùng biến môi trường/secret CI).',
      snippet: '''
# Tạo keystore (chạy 1 lần, giữ file .jks này THẬT CẨN THẬN + backup riêng)
keytool -genkey -v -keystore ~/upload-keystore.jks \\
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# android/key.properties (file RIÊNG, thêm vào .gitignore - KHÔNG commit)
storePassword=<mật khẩu keystore>
keyPassword=<mật khẩu key>
keyAlias=upload
storeFile=/đường/dẫn/tới/upload-keystore.jks

# android/app/build.gradle: đọc key.properties rồi gắn vào signingConfigs.release
# (xem code mẫu chi tiết trong tài liệu chính thức flutter.dev/android-release)''',
      preview: (_) => const _KeystoreDemo(),
    ),
    CheatsheetEntry(
      name: 'Android: build & nộp lên Google Play Console',
      category: 'Deploy Android',
      description:
          'Google Play hiện YÊU CẦU định dạng `.aab` (Android App Bundle) '
          'thay vì `.apk` cho app mới - Google tự tách file cài đặt tối ưu '
          'theo từng loại máy, giúp người dùng tải file NHỎ hơn. `.apk` '
          'vẫn dùng được khi cài trực tiếp lên máy (không qua store) hoặc '
          'chia sẻ test thủ công. Sau khi build xong, vào Google Play '
          'Console -> tạo app -> mục "Production" (hoặc "Internal '
          'testing" để test nội bộ trước) -> upload file `.aab`.',
      snippet: '''
flutter build appbundle --release   # ra file .aab để NỘP LÊN Play Store
# -> build/app/outputs/bundle/release/app-release.aab

flutter build apk --release --split-per-abi  # .apk để CÀI TRỰC TIẾP/chia sẻ test
# -> build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (nhẹ hơn vì tách theo CPU)''',
      preview: (_) => const _AndroidBuildDemo(),
    ),
    CheatsheetEntry(
      name: 'iOS: yêu cầu máy Mac + Apple Developer account',
      category: 'Deploy iOS',
      description:
          'Khác hẳn Android: build/ký app iOS BẮT BUỘC cần máy Mac có '
          'Xcode (Apple không cho build trên Windows/Linux). Chạy thử lên '
          'iPhone thật (không qua store) chỉ cần Apple ID MIỄN PHÍ, nhưng '
          'app cài kiểu này tự HẾT HẠN sau 7 ngày phải cài lại. Muốn đưa '
          'lên App Store hoặc TestFlight (test mời người ngoài) thì bắt '
          'buộc có "Apple Developer Program" (99\$/năm) để lấy "Team ID" '
          'và tạo chứng chỉ ký (certificate) + hồ sơ cấp phép '
          '(provisioning profile).',
      snippet: '''
# Mở phần cấu hình iOS bằng Xcode (KHÔNG sửa trực tiếp .pbxproj bằng tay)
open ios/Runner.xcworkspace

# Trong Xcode: chọn target "Runner" -> tab "Signing & Capabilities"
#  - Team: chọn Apple ID (free) hoặc Apple Developer team (trả phí)
#  - Bundle Identifier: dạng com.tencongty.tenapp (duy nhất toàn App Store)
#  - Bật "Automatically manage signing" để Xcode tự lo certificate/profile''',
      preview: (_) => const _IosSigningDemo(),
    ),
    CheatsheetEntry(
      name: 'iOS: build IPA & nộp qua TestFlight/App Store Connect',
      category: 'Deploy iOS',
      description:
          'Build xong file `.ipa` rồi upload lên App Store Connect (web '
          'quản lý app của Apple) qua Xcode (Organizer) hoặc công cụ '
          '`xcrun altool`/Transporter. Nộp xong, có thể gửi qua '
          '"TestFlight" để vài người test trước (duyệt NHANH, vài giờ) '
          'hoặc nộp "App Store" chính thức để public (Apple REVIEW thủ '
          'công, thường 1-3 ngày, có thể bị từ chối nếu vi phạm guideline '
          '- khác Google Play thường duyệt tự động nhanh hơn).',
      snippet: '''
flutter build ipa --release
# -> build/ios/ipa/*.ipa

# Cách 1: mở Xcode Organizer để upload (dễ nhất, có UI)
open build/ios/archive/Runner.xcarchive

# Cách 2: dùng CLI (cần API key tạo sẵn trên App Store Connect)
xcrun altool --upload-app -f build/ios/ipa/*.ipa \\
  -t ios --apiKey <KEY_ID> --apiIssuer <ISSUER_ID>''',
      preview: (_) => const _IosBuildDemo(),
    ),
    CheatsheetEntry(
      name: 'Phân biệt debug / profile / release khi build',
      category: 'Lệnh build thường dùng',
      description:
          '`flutter run` mặc định chạy bản DEBUG: có hỗ trợ Hot Reload, '
          'kèm nhiều assertion/kiểm tra giúp phát hiện lỗi SỚM, nhưng chạy '
          'CHẬM hơn thật - không bao giờ gửi bản debug cho người dùng. '
          'PROFILE: tắt debug overlay, dùng để ĐO hiệu năng cho sát thực '
          'tế (xem thêm DevTools). RELEASE: tối ưu tốc độ + giảm kích '
          'thước file tối đa, dùng cho bản THẬT gửi lên store/người dùng - '
          'luôn test kỹ bản release trước khi nộp vì hành vi có thể khác '
          'bản debug (vd lỗi chỉ xuất hiện ở release).',
      snippet: '''
flutter run                    # debug (mặc định) - Hot Reload, chậm hơn
flutter run --profile          # đo hiệu năng - gần giống release
flutter run --release          # giống hệt bản sẽ gửi cho người dùng

flutter build apk --debug      # ít dùng, chỉ để test build pipeline
flutter build apk --release    # bản THẬT dùng để nộp/phân phối''',
      preview: (_) => const _BuildModeDemo(),
    ),
    CheatsheetEntry(
      name: 'Checklist trước khi submit lên store',
      category: 'Checklist trước khi submit',
      description:
          'Trước khi bấm nộp, kiểm tra lại: (1) đã tăng build number '
          'trong `pubspec.yaml` chưa; (2) icon + tên app đúng chưa; (3) đã '
          'test bản RELEASE (không phải debug) trên thiết bị thật; (4) '
          'điền đủ quyền riêng tư/permission usage description (iOS yêu '
          'cầu giải thích lý do xin quyền camera/location... trong '
          '`Info.plist`, thiếu là bị TỪ CHỐI ngay); (5) có Privacy Policy '
          'URL nếu app có thu thập dữ liệu người dùng (cả 2 store đều yêu '
          'cầu).',
      snippet: '''
# Android: xin quyền khai báo trong AndroidManifest.xml
<uses-permission android:name="android.permission.CAMERA"/>

# iOS: PHẢI có mô tả lý do xin quyền, thiếu dòng này -> Apple từ chối
# ios/Runner/Info.plist
<key>NSCameraUsageDescription</key>
<string>Ứng dụng cần quyền camera để quét mã QR</string>''',
      preview: (_) => const _ChecklistDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CheatsheetScaffold(
      title: '📦 Deploy lên Android & iOS',
      intro:
          'Quy trình đưa app Flutter từ máy dev ra thiết bị thật/store: '
          'chuẩn bị chung (tên, icon, version) -> ký + build riêng cho '
          'Android (keystore, AAB) và iOS (Xcode signing, IPA - CHỈ làm '
          'được trên máy Mac) -> checklist trước khi nộp lên Play Store/'
          'App Store. Trang này không chạy lệnh thật (cần máy thật + '
          'tài khoản developer) - preview minh hoạ lại quy trình/khái '
          'niệm.',
      items: _items,
    );
  }
}

class _OverviewDemo extends StatelessWidget {
  const _OverviewDemo();

  Widget _step(String text, IconData icon, Color color) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Flexible(child: Text(text, style: const TextStyle(fontSize: 11))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sep = Icon(Icons.arrow_downward, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _step('Code xong', Icons.code, Colors.blue),
        sep,
        _step('Chuẩn bị (tên/icon/version)', Icons.tune, Colors.purple),
        sep,
        _step('Ký + build release', Icons.key, Colors.orange),
        sep,
        _step('Nộp Play Store/App Store', Icons.cloud_upload, Colors.green),
      ],
    );
  }
}

class _AppIdentityDemo extends StatefulWidget {
  const _AppIdentityDemo();

  @override
  State<_AppIdentityDemo> createState() => _AppIdentityDemoState();
}

class _AppIdentityDemoState extends State<_AppIdentityDemo> {
  int _build = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.apps, size: 18, color: Colors.indigo),
            SizedBox(width: 6),
            Text('My App', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text('version: 1.0.3+$_build', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: () => setState(() => _build++),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: const Text('Tăng build number trước khi nộp lại', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

class _KeystoreDemo extends StatefulWidget {
  const _KeystoreDemo();

  @override
  State<_KeystoreDemo> createState() => _KeystoreDemoState();
}

class _KeystoreDemoState extends State<_KeystoreDemo> {
  bool _created = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_created)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6)),
            child: const Text(
              'upload-keystore.jks đã tạo.\n'
              '⚠ Giữ file này + mật khẩu CẨN THẬN, backup riêng ngoài git.',
              style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.greenAccent),
            ),
          ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: () => setState(() => _created = true),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: const Text('keytool -genkey ... upload-keystore.jks', style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}

class _AndroidBuildDemo extends StatefulWidget {
  const _AndroidBuildDemo();

  @override
  State<_AndroidBuildDemo> createState() => _AndroidBuildDemoState();
}

class _AndroidBuildDemoState extends State<_AndroidBuildDemo> {
  bool _aab = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButtons(
          isSelected: [_aab, !_aab],
          onPressed: (i) => setState(() => _aab = i == 0),
          constraints: const BoxConstraints(minWidth: 90, minHeight: 28),
          children: const [
            Text('appbundle', style: TextStyle(fontSize: 10)),
            Text('apk', style: TextStyle(fontSize: 10)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(6)),
          child: Text(
            _aab ? 'app-release.aab -> nộp lên Google Play Console' : 'app-release.apk -> cài trực tiếp/chia sẻ test',
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _IosSigningDemo extends StatelessWidget {
  const _IosSigningDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _CheckRow('Chạy trên máy Mac có Xcode'),
        _CheckRow('Có Apple ID (free) hoặc Developer account (99\$/năm)'),
        _CheckRow('Bundle Identifier dạng com.tencongty.tenapp'),
        _CheckRow('Bật "Automatically manage signing"'),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String text;
  const _CheckRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 14, color: Colors.green),
          const SizedBox(width: 6),
          Flexible(child: Text(text, style: const TextStyle(fontSize: 11))),
        ],
      ),
    );
  }
}

class _IosBuildDemo extends StatefulWidget {
  const _IosBuildDemo();

  @override
  State<_IosBuildDemo> createState() => _IosBuildDemoState();
}

class _IosBuildDemoState extends State<_IosBuildDemo> {
  int _step = 0;
  static const _steps = ['flutter build ipa', 'Mở Xcode Organizer', 'Upload App Store Connect', 'Gửi TestFlight/App Store'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _steps.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  i <= _step ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 14,
                  color: i <= _step ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text('${i + 1}. ${_steps[i]}', style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: _step >= _steps.length - 1 ? null : () => setState(() => _step++),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          child: Text(_step >= _steps.length - 1 ? 'Đã nộp xong' : 'Bước tiếp theo', style: const TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

class _BuildModeDemo extends StatefulWidget {
  const _BuildModeDemo();

  @override
  State<_BuildModeDemo> createState() => _BuildModeDemoState();
}

class _BuildModeDemoState extends State<_BuildModeDemo> {
  int _mode = 0;
  static const _labels = ['debug', 'profile', 'release'];
  static const _notes = [
    'Hot Reload, nhiều assertion, CHẬM - chỉ để dev',
    'Tắt debug overlay, dùng để đo hiệu năng',
    'Tối ưu tốc độ/kích thước - bản gửi THẬT cho người dùng',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButtons(
          isSelected: List.generate(3, (i) => i == _mode),
          onPressed: (i) => setState(() => _mode = i),
          constraints: const BoxConstraints(minWidth: 64, minHeight: 28),
          children: _labels.map((l) => Text(l, style: const TextStyle(fontSize: 10))).toList(),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 220,
          child: Text(_notes[_mode], textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}

class _ChecklistDemo extends StatefulWidget {
  const _ChecklistDemo();

  @override
  State<_ChecklistDemo> createState() => _ChecklistDemoState();
}

class _ChecklistDemoState extends State<_ChecklistDemo> {
  final _checked = <int>{};
  static const _items = [
    'Tăng build number',
    'Icon + tên app đúng',
    'Test bản release trên máy thật',
    'Permission usage description (iOS)',
    'Privacy Policy URL (nếu cần)',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _items.length; i++)
          InkWell(
            onTap: () => setState(() => _checked.contains(i) ? _checked.remove(i) : _checked.add(i)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _checked.contains(i) ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 16,
                    color: _checked.contains(i) ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(_items[i], style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
