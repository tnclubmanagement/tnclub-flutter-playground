import 'package:flutter/material.dart';

// import 'package:flutter/widget_previews.dart';

// @Preview(name: 'Profile Card Starter')
// Widget previewProfileCardStarter() => const ProfileCardStarter();

/// 🎯 CODE MỒI: Profile Card
///
/// Đây là trang bạn sẽ SỬA TRỰC TIẾP. Khung ngoài (Container trắng, bo góc,
/// đổ bóng) đã viết sẵn, nhiệm vụ của bạn là code các phần đánh dấu TODO bên
/// trong để layout giống với "Kết quả mẫu" ở đề bài (bấm "Hiện đáp án" khi
/// nào bí hoặc muốn đối chiếu).
///
/// Cần làm: ảnh cover (gradient) + avatar tròn đè lên mép dưới cover, tên +
/// chức danh, 3 chỉ số (Bài viết/Followers/Following), nút "Theo dõi".
class ProfileCardStarter extends StatelessWidget {
  const ProfileCardStarter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          width: 320,
          clipBehavior: Clip.antiAlias,
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
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO 1: Ảnh cover (gradient) + avatar tròn đè lên mép dưới.
                // Gợi ý: Stack(clipBehavior: Clip.none) + Positioned.
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.purple, Colors.blue],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -32,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(4), // độ dày viền trắng
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.indigo,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // TODO 2: Tên + chức danh (2 dòng Text).
                const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // hoặc .center tùy layout
                  children: [
                    Text(
                      'Ngo Minh Tri',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4), // khoảng cách nhỏ giữa 2 dòng
                    Text(
                      'Flutter Developer',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),

                // TODO 3: 3 chỉ số (Bài viết / Followers / Following).
                // Gợi ý: Row + mainAxisAlignment.spaceAround.
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '128',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Bài viết',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '1.2K',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Followers',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '356',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Following',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // TODO 4: Nút "Theo dõi" full-width (SizedBox(width: double.infinity)).
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Theo dõi'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
