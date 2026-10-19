---
id: deploy-flutter-app
title: "Đóng gói và deploy ứng dụng Flutter"
subtitle: "Từ chạy trên thiết bị thật đến phát hành lên store"
chapter: 1
lesson: 4
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Đóng gói và deploy ứng dụng Flutter

Chạy app trên thiết bị thật và phát hành lên store là hai quy trình khác nhau.
Thiết bị thật phù hợp để kiểm tra; store yêu cầu thêm signing, metadata và
quy trình review.

## Chuẩn bị chung

Trước khi build release, kiểm tra:

- Tên app, bundle identifier và application ID.
- Icon, splash screen và version.
- Permission không cần thiết đã được loại bỏ.
- App không chứa API key, mật khẩu hoặc dữ liệu test.
- Các tính năng quan trọng đã được test trên thiết bị thật.

Version Flutter được khai báo trong `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

Số trước dấu `+` là version hiển thị; số sau dấu `+` là build number và phải
tăng khi upload bản build mới.

## Android

### Chạy thử trên điện thoại

Bật Developer options và USB debugging trên điện thoại, sau đó kiểm tra:

```bash
flutter devices
flutter run -d <android-device-id>
```

### Ký bản release

App Android đưa lên Google Play phải được ký. Tạo keystore một lần và lưu
backup ở nơi an toàn:

```bash
keytool -genkeypair -v \
  -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Không commit keystore, mật khẩu hoặc `android/key.properties` vào repository.
Đặt các file này trong `.gitignore` và dùng secret manager của CI khi build.

### Build Android

Google Play ưu tiên Android App Bundle (`.aab`):

```bash
flutter build appbundle --release
```

Build APK để cài thử hoặc chia sẻ nội bộ:

```bash
flutter build apk --release --split-per-abi
```

Upload file `.aab` lên Google Play Console, sau đó hoàn thành phần listing,
content rating, data safety và testing track trước khi phát hành production.

## iOS

Build iOS cần macOS và Xcode. Mở workspace bằng:

```bash
open ios/Runner.xcworkspace
```

Trong Xcode, chọn target `Runner`, mở **Signing & Capabilities**, chọn Team và
bundle identifier duy nhất. Có thể bật **Automatically manage signing** để
Xcode quản lý certificate và provisioning profile.

Build archive:

```bash
flutter build ipa --release
```

Upload archive lên App Store Connect bằng Xcode Organizer hoặc Transporter.
TestFlight phù hợp để phân phối bản thử nghiệm; phát hành App Store cần hoàn
tất metadata và quy trình review của Apple.

## Debug, profile và release

- **Debug**: có Hot Reload và nhiều kiểm tra, dùng trong lúc phát triển.
- **Profile**: dùng để đo hiệu năng gần với release.
- **Release**: tối ưu cho người dùng cuối, không có debug banner và Hot Reload.

Không gửi bản debug cho người dùng. Trước khi release, kiểm tra kích thước
app, thời gian khởi động, quyền truy cập, crash và hành vi khi mất mạng.

## Checklist trước khi upload

1. Tăng version/build number.
2. Chạy test và kiểm tra trên thiết bị thật.
3. Kiểm tra icon, tên app, screenshot và mô tả store.
4. Xác nhận signing dùng đúng certificate/team.
5. Xóa dữ liệu test và secret khỏi app.
6. Tạo release notes và upload đúng file `.aab` hoặc archive iOS.
7. Gửi bản test nội bộ trước khi phát hành công khai.
