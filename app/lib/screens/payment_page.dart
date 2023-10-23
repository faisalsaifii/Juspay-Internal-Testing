import 'dart:convert';
import 'dart:io';
import 'package:app/screens/pending.dart';
import 'package:app/utils/call_order_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import '../utils/generate_payload.dart';
import './success.dart';
import './failed.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PaymentPage extends StatefulWidget {
  final HyperSDK hyperSDK;
  final String amount;
  const PaymentPage({Key? key, required this.hyperSDK, required this.amount})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var showLoader = true;
  var processCalled = false;
  var paymentSuccess = false;
  var paymentFailed = false;
  var paymentPending = false;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
    } else {
      if (!processCalled) {
        callProcess();
      }
    }

    navigateAfterPayment(context);

    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          var backpressResult = await widget.hyperSDK.onBackPress();

          if (backpressResult.toLowerCase() == "true") {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      },
      child: Container(
        color: Colors.white,
        child: Center(
          child: showLoader ? const CircularProgressIndicator() : Container(),
        ),
      ),
    );
  }

  void callProcess() async {
    processCalled = true;
    var processPayload = await getProcessPayload(widget.amount);
    await widget.hyperSDK.process(processPayload, hyperSDKCallbackHandler);
  }

  void hyperSDKCallbackHandler(MethodCall methodCall) {
    switch (methodCall.method) {
      case "hide_loader":
        setState(() {
          showLoader = false;
        });
        break;
      case "process_result":
        var args = {};

        try {
          args = json.decode(methodCall.arguments);
        } catch (e) {
          print(e);
        }

        var error = args["error"] ?? false;

        var innerPayload = args["payload"] ?? {};

        var status = innerPayload["status"] ?? " ";

        if (!error) {
          switch (status) {
            case "charged":
              {
                // block:start:check-order-status
                // Successful Transaction
                // check order status via S2S API

                // block:end:check-order-status
                setState(() {
                  paymentSuccess = true;
                  paymentFailed = false;
                });
              }
              break;
            case "cod_initiated":
              {
                // User opted for cash on delivery option displayed on the Hypercheckout screen
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
          }
        } else {
          switch (status) {
            case "backpressed":
              {
                // user back-pressed from PP without initiating any txn
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            case "user_aborted":
              {
                // user initiated a txn and pressed back
                // check order status via S2S API
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            case "pending_vbv":
              {
                setState(() {
                  paymentFailed = false;
                  paymentSuccess = false;
                  paymentPending = true;
                });
              }
              break;
            case "authorizing":
              {
                // txn in pending state
                // check order status via S2S API
                setState(() {
                  paymentFailed = false;
                  paymentSuccess = false;
                  paymentPending = true;
                });
              }
              break;
            case "authorization_failed":
              {
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            case "authentication_failed":
              {
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            case "api_failure":
              {
                // txn failed
                // check order status via S2S API
                if (orderStatus()) {
                  setState(() {
                    paymentFailed = false;
                    paymentSuccess = true;
                  });
                } else {
                  setState(() {
                    paymentFailed = true;
                    paymentSuccess = false;
                  });
                }
              }
              break;
            case "new":
              {
                // order created but txn failed
                // check order status via S2S API
                if (orderStatus()) {
                  setState(() {
                    paymentFailed = false;
                    paymentSuccess = true;
                  });
                } else {
                  setState(() {
                    paymentFailed = true;
                    paymentSuccess = false;
                  });
                }
              }
              break;
          }
        }
    }
  }
  // block:end:callback-handler

  void navigateAfterPayment(BuildContext context) {
    if (kIsWeb) {
    } else {
      if (paymentSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SuccessScreen()));
        });
      } else if (paymentFailed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const FailedScreen()));
        });
      } else if (paymentPending) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PendingScreen()));
        });
      }
    }
  }
}
