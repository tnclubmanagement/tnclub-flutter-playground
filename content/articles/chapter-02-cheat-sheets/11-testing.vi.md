---
id: testing
title: "Testing"
subtitle: "Test widget, thao tác người dùng và layout"
chapter: 2
lesson: 11
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Testing

Test nên mô tả hành vi người dùng nhìn thấy thay vì phụ thuộc implementation nội bộ.

![Sơ đồ tổng quan Testing](chapter-02-overview.png)

## Widget test

```dart
testWidgets('button increments', (tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.tap(find.text('Tăng'));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
});
```

Dùng `pump()` cho một frame, `pumpAndSettle()` khi cần chờ animation. Test cả kích thước hẹp để bắt overflow; dùng integration test cho plugin và luồng nhiều màn hình.
