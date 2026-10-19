---
id: animation
title: "Animation"
subtitle: "Animation mượt và có chủ đích trong Flutter"
chapter: 2
lesson: 4
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Animation

Bắt đầu với implicit animation; chỉ dùng controller khi cần điều khiển timeline hoặc gesture.

![Sơ đồ tổng quan Animation](chapter-02-overview.png)

## Implicit animation

`AnimatedContainer`, `AnimatedOpacity` và `AnimatedSwitcher` tự nội suy thay đổi trong một khoảng thời gian. Đây là lựa chọn tốt cho hover, mở rộng card hoặc đổi trạng thái.

## Explicit animation

Dùng `AnimationController` + `Tween` khi cần lặp, stagger hoặc điều khiển theo scroll. Controller phải được dispose trong `dispose()`. `Hero` dùng để nối cùng một object giữa hai màn hình và cần tag duy nhất.
