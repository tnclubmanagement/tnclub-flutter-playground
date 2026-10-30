---
id: auth
title: "Login & Credential"
subtitle: "Đăng nhập, token và auth guard an toàn"
chapter: 2
lesson: 9
language: vi
publishedAt: 2026-10-19
updatedAt: 2026-10-19
flutterVersion: "3.29+"
dartVersion: "3.7+"
---

# Login & Credential

Authentication không chỉ là màn hình login: cần quản lý token, session, refresh và logout sạch.

![Sơ đồ tổng quan Login & Credential](09-illustration.png)

## Token lifecycle

Access token nên có thời hạn ngắn; refresh token cần lưu trong secure storage. Khi API trả 401, refresh một lần rồi retry request, tránh vòng lặp vô hạn.

## Logout

Xóa credential local, reset user state, hủy request nhạy cảm và đưa người dùng về màn hình login. Không hardcode secret trong app và không commit file chứa credential.
