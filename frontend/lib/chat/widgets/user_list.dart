import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final Map<String, dynamic> user;
  const UserList({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        spacing: 15.0,
        children: [
          ClipOval(
            child: Image(
              image: NetworkImage(user['imageUrl']),
              height: 50,
              width: 50,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 2.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name']),
                Text(
                  user['email'],
                  maxLines: 1,
                  // style: TextStyle(),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            onPressed: () {
              print(user['_id']);
            },
            child: Text('Add friend'),
          ),
        ],
      ),
    );
  }
}
