import 'package:flutter/material.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import './screens/home.dart';

void main() {
  final hyperSDK = HyperSDK();
  runApp(MyApp(hyperSDK: hyperSDK));
}

class MyApp extends StatelessWidget {
  final HyperSDK hyperSDK;
  const MyApp({Key? key, required this.hyperSDK}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        hyperSDK: hyperSDK,
      ),
    );
  }
}
