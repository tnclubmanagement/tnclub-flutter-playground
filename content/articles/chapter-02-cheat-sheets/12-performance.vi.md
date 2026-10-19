---
id: performance
title: "Performance"
subtitle: "Giữ UI mượt và tránh rebuild thừa"
chapter: 2
lesson: 12
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Performance

Đo trước khi tối ưu: DevTools cho biết frame nào chậm và widget nào rebuild quá nhiều.

![Sơ đồ tổng quan Performance](12-illustration.png)

## Checklist

- Dùng `const` cho widget bất biến.
- Dùng builder cho list/grid dài.
- Tách widget để giới hạn vùng rebuild.
- Resize ảnh trước khi decode ảnh lớn.
- Tránh công việc nặng trong `build()`.

`RepaintBoundary` hữu ích cho vùng vẽ độc lập, nhưng không nên thêm mọi nơi. So sánh profile build trước và sau thay đổi.
