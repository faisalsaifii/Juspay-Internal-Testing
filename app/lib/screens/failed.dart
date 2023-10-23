import 'package:flutter/material.dart';

class FailedScreen extends StatelessWidget {
  const FailedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Failed"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.red,
      ),
      body: const Center(
          child: Text(
        "Failed!",
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
