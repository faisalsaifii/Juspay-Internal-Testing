import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data.dart';

dynamic orderStatus() async {
  var url = Uri.parse(serverUrl + orderId);
  var response = await http.get(url);
  return json.decode(response.body)["status"];
}
