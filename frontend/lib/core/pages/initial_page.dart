import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/loader.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Swift chat"), Loader()],
      ),
    );
  }
}
