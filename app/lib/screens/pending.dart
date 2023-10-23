import 'dart:async';

import 'package:app/screens/failed.dart';
import 'package:app/screens/success.dart';
import 'package:app/utils/call_order_status.dart';
import 'package:flutter/material.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  Timer? timer;
  int count = 0;

  void handleTimerCallback() async {
    if (await orderStatus() == "CHARGED") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()));
    }
    count++;
    if (count >= 1) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const FailedScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => handleTimerCallback());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Pending")),
    );
  }
}
