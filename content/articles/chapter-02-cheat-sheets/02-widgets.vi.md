---
id: widgets
title: "Widget cheat sheet"
subtitle: "Tra nhanh các widget giao diện thường dùng"
chapter: 2
lesson: 2
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Widget cheat sheet

Chọn widget theo trách nhiệm: hiển thị, bố cục, nhập liệu, cuộn hoặc phản hồi thao tác.

![Sơ đồ tổng quan Widget cheat sheet](chapter-02-overview.png)

## Nhóm widget chính

- `Text`, `Icon`, `Image`: hiển thị nội dung.
- `Row`, `Column`, `Stack`, `Wrap`: bố cục.
- `ListView`, `GridView`: danh sách cuộn.
- `Scaffold`, `AppBar`, `BottomNavigationBar`: khung màn hình.
- `TextField`, `Checkbox`, `DropdownButton`: nhập liệu.

## Quy tắc chọn

Dùng `ListView.builder` cho danh sách dài, `Wrap` khi item cần tự xuống dòng và `Expanded` khi child cần nhận phần không gian còn lại. Tránh dùng `ListView` lồng nhau nếu chưa kiểm soát constraints.
