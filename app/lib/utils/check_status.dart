import './call_order_status.dart';

bool getStatus() {
  String status = orderStatus();
  if (status == "CHARGED") {
    return true;
  } else {
    return false;
  }
}
