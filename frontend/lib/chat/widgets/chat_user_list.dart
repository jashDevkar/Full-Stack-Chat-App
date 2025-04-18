import 'package:flutter/material.dart';

class ChatUserList extends StatelessWidget {
  final Map<String, dynamic> friend;
  final void Function()? onPressCallback;
  const ChatUserList({super.key, required this.friend, this.onPressCallback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressCallback,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        margin: EdgeInsets.only(top: 10.0),
        child: Row(
          spacing: 15.0,
          children: [
            ClipOval(
              child: Image(
                image: NetworkImage(friend['imageUrl']),
                height: 50,
                width: 50,
              ),
            ),
            Expanded(
              child: Column(
                spacing: 2.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(friend['name']),
                  Text(
                    friend['email'],
                    maxLines: 1,
                    // style: TextStyle(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            IconButton(
              style: IconButton.styleFrom(
                padding: EdgeInsets.only(right: 10.0),
              ),
              onPressed: onPressCallback,
              icon: Icon(Icons.chat_bubble_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
