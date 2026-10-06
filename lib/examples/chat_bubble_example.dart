import 'package:flutter/material.dart';

/// Example: Chat Bubble List
///
/// Kết hợp ListView.builder với Align/Row (mainAxisAlignment) để đẩy bong
/// bóng chat của "mình" sang phải và của người khác sang trái, dùng
/// ConstrainedBox để bong bóng không bao giờ rộng quá 75% màn hình.
class ChatBubbleExample extends StatelessWidget {
  const ChatBubbleExample({super.key});

  static const _messages = [
    (text: 'Chào bạn! Layout Flutter học tới đâu rồi?', isMe: false),
    (text: 'Mình vừa học xong Row, Column với Expanded!', isMe: true),
    (text: 'Tốt đó, thử qua Stack với Positioned xem', isMe: false),
    (text: 'Ok để mình thử luôn', isMe: true),
    (text: 'Nhớ kết hợp với GridView và ListView nữa nha', isMe: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final m = _messages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment:
                  m.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: m.isMe ? Colors.deepPurple : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(m.isMe ? 16 : 4),
                        bottomRight: Radius.circular(m.isMe ? 4 : 16),
                      ),
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(
                        color: m.isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
