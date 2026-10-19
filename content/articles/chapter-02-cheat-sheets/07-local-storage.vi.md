---
id: local-storage
title: "Local Storage"
subtitle: "Lưu dữ liệu cục bộ đúng với nhu cầu"
chapter: 2
lesson: 7
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Local Storage

Không phải dữ liệu nào cũng cần database. Xác định kích thước, cấu trúc và vòng đời trước khi chọn package.

![Sơ đồ tổng quan Local Storage](07-illustration.png)

## Lựa chọn

- `shared_preferences`: setting nhỏ dạng key-value, không dùng cho secret.
- Secure storage: token và dữ liệu nhạy cảm.
- SQLite/Drift: dữ liệu quan hệ, query và migration.
- Hive/Isar: object local cần tốc độ và API đơn giản.

Luôn bọc tầng lưu trữ sau repository, version hóa schema và xử lý trường hợp dữ liệu cũ hoặc hỏng.
