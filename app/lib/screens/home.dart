import 'package:app/screens/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  final HyperSDK hyperSDK;
  const HomeScreen({Key? key, required this.hyperSDK}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    initiateHyperSDK();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Pay"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    hyperSDK: widget.hyperSDK,
                    amount: "1",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initiateHyperSDK() async {
    if (!await widget.hyperSDK.isInitialised()) {
      var initiatePayload = {
        "requestId": const Uuid().v4(),
        "service": "in.juspay.hyperpay",
        "payload": {
          "action": "initiate",
          "merchantId": "ipec",
          "clientId": "ipec",
          "environment": "production"
        }
      };
      await widget.hyperSDK.initiate(initiatePayload, initiateCallbackHandler);
    }
  }

  void hitSession() async {}

  void initiateCallbackHandler(MethodCall methodCall) {
    if (methodCall.method == "initiate_result") {
      // check initiate result
    }
  }
}
