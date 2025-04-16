import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool? currentUserText;
  const ChatBubble({super.key, required this.message, this.currentUserText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0, top: 8.0, left: 8.0),
      padding: EdgeInsets.only(
        right: 14.0,
        top: 12.0,
        bottom: 12.0,
        left: 12.0,
      ),
      decoration: BoxDecoration(
        color:
            currentUserText!
                ? Colors.deepPurple.shade600.withAlpha(100)
                : Colors.blueGrey.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: TextStyle(),
        textAlign: currentUserText! ? TextAlign.left : TextAlign.right,
      ),
    );
  }
}
