---
id: dart-syntax
title: "Dart syntax"
subtitle: "Cú pháp Dart cần nhớ khi viết Flutter"
chapter: 2
lesson: 3
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Dart syntax

Null safety, collection, function và async là các phần xuất hiện mỗi ngày trong code Flutter.

![Sơ đồ tổng quan Dart syntax](03-illustration.png)

## Null safety và collection

`String?` có thể null, còn `String` thì không. Dùng `??` cho giá trị dự phòng, `?.` cho truy cập an toàn, và spread `...` để ghép collection.

```dart
final label = user?.name ?? 'Khách';
final items = [header, ...results, if (showFooter) footer];
```

## Async và cascade

Dùng `async`/`await` cho `Future`, luôn xử lý loading và error. Cascade `..` hữu ích khi cấu hình cùng một object nhưng không nên lạm dụng làm code khó đọc.
