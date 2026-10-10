import 'package:flutter/material.dart';
// import 'package:flutter/widget_previews.dart';

// @Preview(name: 'Chat Bubble Starter', size: Size(400, 600))
// Widget previewChatBubbleStarter() => const ChatBubbleStarter();

/// 🎯 CODE MỒI: Chat Bubble List
///
/// Danh sách tin nhắn mẫu đã có sẵn. Code `itemBuilder` để ra danh sách chat
/// giống "Kết quả mẫu": tin nhắn của "mình" (isMe: true) lệch phải, màu tím;
/// tin nhắn người khác lệch trái, màu trắng; bong bóng không rộng quá ~50%
/// màn hình và có góc bo khác nhau để tạo "mỏ" bong bóng.
class ChatBubbleStarter extends StatelessWidget {
  const ChatBubbleStarter({super.key});

  static const _messages = [
    (text: 'Chào bạn! Layout Flutter học tới đâu rồi?', isMe: false),
    (text: 'Mình vừa học xong Row, Column với Expanded!', isMe: true),
    (text: 'Tốt đó, thử qua Stack với Positioned xem', isMe: false),
    (text: 'Ok để mình thử luôn', isMe: true),
    (text: 'Nhớ kết hợp với GridView và ListView nữa nha', isMe: false),
  ];

  @override
  Widget build(BuildContext context) {
    const borderRadius = 16.0;
    const innerBorderRadius = 4.0;
    return Container(
      color: Colors.grey.shade100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final m = _messages[index];
          // TODO 1: Row với mainAxisAlignment.end nếu m.isMe, ngược lại .start.
          // TODO 2: ConstrainedBox(maxWidth: 50% màn hình) bọc bong bóng.
          // TODO 3: Container bong bóng: màu theo m.isMe, BorderRadius.only(...)
          // với 1 góc nhỏ hơn (4) ở phía người gửi để tạo "mỏ".
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: m.isMe ? Colors.purple : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(borderRadius),
                  topRight: const Radius.circular(borderRadius),
                  bottomLeft: m.isMe ? const Radius.circular(borderRadius) : Radius.circular(innerBorderRadius),
                  bottomRight: m.isMe ? Radius.circular(innerBorderRadius) : const Radius.circular(borderRadius),
                ),
              ),
              child: Text('${m.isMe ? "(mình)" : "(họ)"} ${m.text}'),
            ),
          );
        },
      ),
    );
  }
}
