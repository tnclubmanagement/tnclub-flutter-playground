---
id: navigation
title: "Navigation & Routing"
subtitle: "Điều hướng, truyền dữ liệu và trả kết quả"
chapter: 2
lesson: 6
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Navigation & Routing

Navigator quản lý stack màn hình; route rõ ràng giúp deep link và test dễ hơn.

![Sơ đồ tổng quan Navigation & Routing](chapter-02-overview.png)

## Push và pop

```dart
final result = await Navigator.push<String>(
  context,
  MaterialPageRoute(builder: (_) => const DetailPage()),
);
if (context.mounted && result != null) { /* cập nhật UI */ }
```

`Navigator.pop(context, value)` trả dữ liệu về màn hình trước. Named routes phù hợp app nhỏ; `go_router` đáng cân nhắc khi có deep link, auth redirect và nested navigation.
