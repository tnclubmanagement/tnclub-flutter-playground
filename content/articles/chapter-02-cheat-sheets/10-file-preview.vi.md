---
id: file-preview
title: "File Preview"
subtitle: "Ảnh, PDF và file picker trong ứng dụng"
chapter: 2
lesson: 10
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# File Preview

File từ người dùng có thể lớn, sai định dạng hoặc không còn tồn tại; UI phải có loading và error state.

![Sơ đồ tổng quan File Preview](chapter-02-overview.png)

## Ảnh

Dùng `Image.network`/`Image.file` với `errorBuilder`, placeholder và kích thước giới hạn. `InteractiveViewer` hỗ trợ zoom/pan nhưng nên giới hạn min/max scale.

## File và PDF

Kiểm tra extension lẫn MIME type, giới hạn dung lượng, và không tự tin tưởng tên file. Khi preview thất bại, hiển thị nút tải lại hoặc mở bằng ứng dụng phù hợp.
