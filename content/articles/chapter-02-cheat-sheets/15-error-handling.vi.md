---
id: error-handling
title: "Error Handling & Crash Reporting"
subtitle: "Bắt lỗi, log và crash reporting có trách nhiệm"
chapter: 2
lesson: 15
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Error Handling & Crash Reporting

Error state cần thân thiện với người dùng nhưng đủ context để developer chẩn đoán.

![Sơ đồ tổng quan Error Handling & Crash Reporting](chapter-02-overview.png)

## Các lớp lỗi

Dùng `try/catch` cho operation dự kiến thất bại, `FlutterError.onError` cho lỗi framework và `runZonedGuarded` cho lỗi async ngoài widget.

Không hiển thị stack trace cho người dùng. Log request id, screen và action cần thiết nhưng phải che token, password và dữ liệu cá nhân. Chỉ gửi crash report sau khi cân nhắc consent và retention.
