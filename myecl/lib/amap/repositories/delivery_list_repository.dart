import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myecl/amap/class/delivery.dart';
import 'package:myecl/amap/class/order.dart';
import 'package:myecl/amap/class/product.dart';

class DeliveryListRepository {
  final host = "http://10.0.0.2/8000/";
  final ext = "amap/deliveries/";
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Future<List<Delivery>> getDeliveryList() async {
    final response = await http.get(Uri.parse(host + ext), headers: headers);
    if (response.statusCode == 200) {
      return List<Delivery>.from(
          json.decode(response.body).map((x) => Delivery.fromJson(x)));
    } else {
      throw Exception("Failed to load delivery list");
    }
  }

  Future<bool> createDelivery(Delivery delivery) async {
    final response = await http.post(Uri.parse(host),
        headers: headers, body: json.encode(delivery.toJson()));
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Failed to create delivery");
    }
  }

  Future<bool> updateDelivery(String deliveryId, Delivery delivery) async {
    final response = await http.patch(Uri.parse(host + ext + deliveryId),
        headers: headers, body: json.encode(delivery.toJson()));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to update delivery");
    }
  }

  Future<bool> deleteDelivery(String deliveryId) async {
    final response =
        await http.delete(Uri.parse(host + ext + deliveryId), headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete delivery");
    }
  }

  Future<Delivery> getDelivery(String deliveryId) async {
    final response =
        await http.get(Uri.parse(host + ext + deliveryId), headers: headers);
    if (response.statusCode == 200) {
      return Delivery.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load delivery");
    }
  }
}