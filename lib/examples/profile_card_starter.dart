import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'Profile Card Starter')
Widget previewProfileCardStarter() => const ProfileCardStarter();

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
                Stack(
                  children: [
                    Container(color: Colors.blueGrey.shade100,width: double.infinity),
                    const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person, color: Colors.white, size: 32),
            ),
                    Container(
                      width: double.infinity,
                      color: Colors.deepPurple.withValues(alpha: 0.7),
                      
                      child: const Text(
                        'Nền (căn giữa Stack)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // TODO 1: Ảnh cover (gradient) + avatar tròn đè lên mép dưới.
                // Gợi ý: Stack(clipBehavior: Clip.none) + Positioned.

                // TODO 2: Tên + chức danh (2 dòng Text).

                // TODO 3: 3 chỉ số (Bài viết / Followers / Following).
                // Gợi ý: Row + mainAxisAlignment.spaceAround.

                // TODO 4: Nút "Theo dõi" full-width (SizedBox(width: double.infinity)).
                Text('TODO: code UI của bạn vào đây'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
