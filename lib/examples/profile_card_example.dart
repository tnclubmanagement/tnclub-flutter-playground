import 'package:flutter/material.dart';

/// Example: Profile Card
///
/// Kết hợp Stack (ảnh cover + avatar chồng lên), Column/Row để xếp thông tin,
/// và Wrap cho các "stat" (followers/following/posts) để tự xuống dòng khi
/// màn hình hẹp. Nút "Theo dõi" có state để chuyển thành "Đang theo dõi" và
/// số followers tăng/giảm theo, minh hoạ StatefulWidget + setState() đơn giản.
class ProfileCardExample extends StatefulWidget {
  const ProfileCardExample({super.key});

  @override
  State<ProfileCardExample> createState() => _ProfileCardExampleState();
}

class _ProfileCardExampleState extends State<ProfileCardExample> {
  bool _isFollowing = false;
  int _followers = 2400;

  String _formatFollowers(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toString();
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      _followers += _isFollowing ? 1 : -1;
    });
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          width: 320,
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
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // Ảnh cover
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.indigo],
                      ),
                    ),
                  ),
                  // Avatar đè lên mép dưới của cover, dùng Positioned để lệch
                  // xuống nửa chiều cao avatar.
                  Positioned(
                    top: 100 - 40,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              const Text(
                'Nguyễn Văn A',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Flutter Developer',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('128', 'Bài viết'),
                    _stat(_formatFollowers(_followers), 'Followers'),
                    _stat('180', 'Following'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: _isFollowing
                      ? OutlinedButton(
                          onPressed: _toggleFollow,
                          child: const Text('Đang theo dõi'),
                        )
                      : ElevatedButton(
                          onPressed: _toggleFollow,
                          child: const Text('Theo dõi'),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
