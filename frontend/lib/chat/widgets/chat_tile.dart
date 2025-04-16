import 'package:flutter/material.dart';
import 'package:frontend/chat/widgets/chat_bubble.dart';

class ChatTile extends StatelessWidget {
  final Map<String, dynamic> chat;
  final String currentUserEmail;
  const ChatTile({
    super.key,
    required this.chat,
    required this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          currentUserEmail == chat['senderEmail']
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        ChatBubble(
          message: chat['message'],
          currentUserText: currentUserEmail == chat['senderEmail'],
        ),
      ],
    );
  }
}
