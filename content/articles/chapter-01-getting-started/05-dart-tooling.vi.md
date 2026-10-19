---
id: dart-tooling
title: "Dart và Flutter CLI"
subtitle: "Các lệnh cần dùng hằng ngày khi phát triển project"
chapter: 1
lesson: 5
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Dart và Flutter CLI

Terminal giúp bạn cài dependency, format code, tìm lỗi và kiểm tra project
trước khi commit. Nên chạy lệnh từ thư mục gốc, nơi có `pubspec.yaml`.

## Dependency

```bash
flutter pub get
flutter pub add http
flutter pub remove http
flutter pub outdated
```

`flutter pub get` đọc `pubspec.yaml` và cập nhật `.dart_tool/package_config.json`.
Khi thêm package, ưu tiên `flutter pub add` để tự ghi đúng constraint vào
`pubspec.yaml`.

## Format và phân tích code

```bash
dart format .
flutter analyze
dart fix --dry-run
dart fix --apply
```

Chạy `dart format` trước khi commit. `flutter analyze` tìm lỗi type, import
không dùng và nhiều vấn đề có thể phát hiện mà không cần chạy app. Chỉ dùng
`dart fix --apply` sau khi xem kỹ danh sách thay đổi.

## Test và build

```bash
flutter test
flutter test test/home_page_test.dart
flutter test --coverage
flutter build web --release
```

Khi sửa một module, chạy test liên quan trước để phản hồi nhanh, sau đó chạy
toàn bộ `flutter test` trước khi tạo pull request.

## Làm sạch project

```bash
flutter clean
flutter pub get
```

`flutter clean` xóa artifact build và thường không cần chạy sau mỗi lần sửa
code. Chỉ dùng khi cache build hoặc dependency bị lỗi bất thường.

## Nguyên tắc dùng CLI

- Đọc lỗi từ dòng đầu tiên có nguyên nhân, không chỉ nhìn dòng cuối.
- Ghi lại version Flutter bằng `flutter --version` khi báo lỗi môi trường.
- Không commit thư mục `.dart_tool/`, `build/` hoặc secret.
- Dùng `fvm flutter ...` nếu project có cấu hình FVM.
