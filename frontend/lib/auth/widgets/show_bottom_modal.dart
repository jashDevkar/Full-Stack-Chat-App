import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future showBottomModal({
  required BuildContext context,
  required void Function(ImageSource source) onTap,
}) {
  final height = MediaQuery.of(context).size.height;
  return showModalBottomSheet(
    elevation: 8.0,
    context: context,
    builder: (context) {
      return SizedBox(
        height: height * 0.25,
        child: Center(
          child: Column(
            spacing: 10.0,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                icon: Icon(Icons.photo_library_sharp, color: Colors.white),
                onPressed: () => onTap(ImageSource.gallery),
                label: Text("Browse gallery"),
              ),
              Row(
                spacing: 5.0,
                children: [
                  Expanded(child: Divider(height: 2)),
                  Text(
                    "OR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                onPressed: () => onTap(ImageSource.camera),
                label: Text("From camera"),
              ),
            ],
          ),
        ),
      );
    },
  );
}
