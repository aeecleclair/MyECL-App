import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myecl/amap/class/order.dart';

class OrderListRepository {
  final host = "http://10.0.2.2:8000/";
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Future<List<Order>> getAllOrders() async {
    final response =
        await http.get(Uri.parse(host + "orders/"), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data.map<Order>((json) => Order.fromJson(json)).toList();
    } else {
      final data = json.decode(response.body);
      throw Exception(data.get('detail'));
    }
  }

  Future<bool> updateOrder(String orderId, Order order) async {
    final response = await http.patch(Uri.parse(host + "orders/" + orderId),
        headers: headers, body: json.encode(order.toJson()));
    if (response.statusCode == 200) {
      return true;
    } else {
      final data = json.decode(response.body);
      throw Exception(data.get('detail'));
    }
  }

  Future<bool> deleteOrder(String orderId) async {
    final response = await http.delete(Uri.parse(host + "orders/" + orderId),
        headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      final data = json.decode(response.body);
      throw Exception(data.get('detail'));
    }
  }

  Future<Order> getOrder(String orderId) async {
    final response =
        await http.get(Uri.parse(host + "orders/" + orderId), headers: headers);
    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      final data = json.decode(response.body);
      throw Exception(data.get('detail'));
    }
  }

  Future<bool> createOrder(Order order) async {
    final response = await http.post(Uri.parse(host + "orders/"),
        headers: headers, body: json.encode(order.toJson()));
    if (response.statusCode == 201) {
      return true;
    } else {
      final data = json.decode(response.body);
      throw Exception(data.get('detail'));
    }
  }
}
