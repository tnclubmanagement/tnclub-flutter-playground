import 'package:flutter/material.dart';
// import 'package:flutter/widget_previews.dart';

// @Preview(name: 'Login Form Starter')
// Widget previewLoginFormStarter() => const LoginFormStarter();

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
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    var children = [
      // TODO 1: Tiêu đề "Đăng nhập" + dòng phụ "Chào mừng bạn trở lại!".
      const Text(
        'Đăng nhập',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Text(
        'Chào mừng bạn trở lại!',
        style: TextStyle(color: Colors.grey.shade600),
      ),
      const SizedBox(height: 24),

      // TODO 2: TextField Email (prefixIcon, border: OutlineInputBorder()).
      TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          prefixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),

      // TODO 3: TextField Mật khẩu (obscureText: _obscurePassword,
      // suffixIcon là IconButton toggle _obscurePassword qua setState).
      TextField(
        decoration: InputDecoration(
          labelText: 'Mật khẩu đó',
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: OutlineInputBorder(),
        ),
        obscureText: _obscurePassword,
      ),
      const SizedBox(height: 8),

      // TODO 4: Row chứa Checkbox (value: _rememberMe) + Text "Nhớ tôi",
      // Spacer(), rồi TextButton "Quên mật khẩu?".
      Row(
        children: [
          Checkbox(
            value: _rememberMe,
            onChanged: (bool? value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
          ),
          const Text('Nhớ tôi'),
          const Spacer(),
          TextButton(
            onPressed: () {
              // TODO: Xử lý quên mật khẩu
            },
            child: const Text('Quên mật khẩu?'),
          ),
        ],
      ),
      const SizedBox(height: 8),

      // TODO 5: Nút "Đăng nhập" full-width (SizedBox(width: double.infinity)).
      SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Xử lý đăng nhập
          },
          child: const Text('Đăng nhập'),
        ),
      ),
      const SizedBox(height: 24),

      // TODO 6: Dải phân cách "hoặc": Expanded(Divider) - Text - Expanded(Divider).
      Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('hoặc', style: TextStyle(color: Colors.grey)),
          ),
          const Expanded(child: Divider()),
        ],
      ),
      const SizedBox(height: 16),

      // TODO 7: Nút "Đăng nhập với Google" (OutlinedButton.icon).
      SizedBox(
        width: double.infinity, 
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () {
            // TODO: Xử lý đăng nhập với Google
          },
          icon: const Icon(Icons.g_mobiledata),
          label: const Text('Đăng nhập với Google'),
        ),
      )
    ];
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
            children: children,
          ),
        ),
      ),
    );
  }
}
