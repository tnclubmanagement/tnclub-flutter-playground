import 'package:flutter/material.dart';

/// 🎯 CODE MỒI: Login Form
///
/// Khung thẻ trắng bo góc đã viết sẵn. Code các TODO bên trong để ra 1 form
/// đăng nhập giống "Kết quả mẫu": tiêu đề, field Email, field Mật khẩu (có
/// icon ẩn/hiện), dòng "Nhớ tôi" + "Quên mật khẩu?", nút Đăng nhập, dải phân
/// cách "hoặc", nút đăng nhập Google.
class LoginFormStarter extends StatefulWidget {
  const LoginFormStarter({super.key});

  @override
  State<LoginFormStarter> createState() => _LoginFormStarterState();
}

class _LoginFormStarterState extends State<LoginFormStarter> {
  // TODO 0: Thêm các biến state cần thiết, ví dụ:
  // bool _obscurePassword = true;
  // bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // TODO 1: Tiêu đề "Đăng nhập" + dòng phụ "Chào mừng bạn trở lại!".

              // TODO 2: TextField Email (prefixIcon, border: OutlineInputBorder()).

              // TODO 3: TextField Mật khẩu (obscureText, suffixIcon toggle ẩn/hiện).

              // TODO 4: Row chứa Checkbox + "Nhớ tôi", Spacer(), TextButton "Quên mật khẩu?".

              // TODO 5: Nút "Đăng nhập" full-width.

              // TODO 6: Dải phân cách "hoặc": Expanded(Divider) - Text - Expanded(Divider).

              // TODO 7: Nút "Đăng nhập với Google" (OutlinedButton.icon).

              Text('TODO: code UI của bạn vào đây'),
            ],
          ),
        ),
      ),
    );
  }
}
