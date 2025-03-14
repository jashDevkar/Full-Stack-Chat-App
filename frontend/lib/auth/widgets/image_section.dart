import 'dart:io';

import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  final File? image;
  final Function() onPressed;
  const ImageSection({super.key, required this.onPressed, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.0,
      children: [
        CircleAvatar(
          radius: 60,
          child: ClipOval(
            child:
                image == null
                    ? Image.asset(
                      "assets/images/user.png",
                      fit: BoxFit.cover,
                      color: Colors.white70,
                      alignment: Alignment.center,
                    )
                    : CircleAvatar(
                      radius: 75,
                      child: ClipOval(child: Image.file(image!)),
                    ),
          ),
        ),

        ElevatedButton.icon(
          icon: Icon(Icons.arrow_drop_down_outlined),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          label: Text(
            image == null ? "select a image" : "Select a different image",
          ),
        ),
      ],
    );
  }
}
