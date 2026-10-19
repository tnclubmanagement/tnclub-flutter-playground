---
id: api-service
title: "API & Service"
subtitle: "Gọi API, parse JSON và quản lý trạng thái request"
chapter: 2
lesson: 8
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# API & Service

Tách HTTP client, model và repository để UI không biết chi tiết endpoint.

![Sơ đồ tổng quan API & Service](chapter-02-overview.png)

## Luồng chuẩn

1. Client gửi request với timeout và auth header.
2. Repository kiểm tra status code và parse JSON thành model.
3. UI hiển thị loading, success, empty và error.

```dart
try {
  final response = await client.get(uri);
  if (response.statusCode != 200) throw Exception('Request failed');
} catch (error) {
  // ghi log và hiển thị trạng thái lỗi phù hợp
}
```

Debounce ô tìm kiếm, cancel request cũ khi cần và không log token/PII.
