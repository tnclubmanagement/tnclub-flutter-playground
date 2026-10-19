---
id: theme
title: "Theme & Dark Mode"
subtitle: "Theme nhất quán, hỗ trợ sáng tối và accessibility"
chapter: 2
lesson: 13
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Theme & Dark Mode

Theme tập trung màu sắc, typography và component defaults để màn hình mới không phải tự chọn style.

![Sơ đồ tổng quan Theme & Dark Mode](13-illustration.png)

## ThemeData

Dùng `ColorScheme.fromSeed` để tạo palette và đọc màu qua `Theme.of(context).colorScheme`. Không hardcode màu trên từng widget nếu đó là màu thương hiệu hoặc trạng thái dùng chung.

## Dark mode

Khai báo `theme`, `darkTheme` và `themeMode`; lưu lựa chọn người dùng nếu cần. Kiểm tra contrast, divider, ảnh và icon ở cả hai mode.
