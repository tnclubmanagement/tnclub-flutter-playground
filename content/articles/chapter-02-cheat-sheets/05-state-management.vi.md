---
id: state-management
title: "State Management"
subtitle: "Chọn cách quản lý state phù hợp với kích thước ứng dụng"
chapter: 2
lesson: 5
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# State Management

State cục bộ nên ở gần widget sử dụng; state dùng chung cần một nguồn sự thật rõ ràng.

![Sơ đồ tổng quan State Management](05-illustration.png)

## Từ nhỏ đến lớn

- `setState`: state chỉ thuộc một màn hình hoặc component.
- `ValueNotifier`: state nhỏ, cần rebuild có mục tiêu.
- `ChangeNotifier` + Provider: ứng dụng vừa, API dễ tiếp cận.
- Riverpod hoặc BLoC: dependency/state phức tạp, cần test và tổ chức chặt.

## Nguyên tắc

Không đưa mọi thứ vào global state. Tách model, repository và UI; widget chỉ lắng nghe state và phát event.
