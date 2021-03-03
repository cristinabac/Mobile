import 'package:flutter_app/model/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //for jsonDecode

import 'dart:developer' as developer;

class NetworkApi{
  static const BASE_URL = "http://192.168.0.241:2301/";

  Future<List<Item>> getItems() async {
    http.Response res = await http.get(BASE_URL + "orders");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      return items;
    } else {
      throw "Can't get items.";
    }
  }

  Future<Item> createItem(Item item) async {
    print(item);
    final http.Response response = await http.post(
      BASE_URL + "order",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table': item.table,
        'details': item.details,
        'status': item.status,
        'time': item.time,
        'type': item.type
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      // throw Exception('Failed to create.');
      print("Err in api add");
      return null;
    }
  }

  Future<Item> updateProduct(Item product) async {
    developer.log(
      'log me',
      name: 'my.app.category',
      error: 'BASE_URL + product.real_id: ' + BASE_URL + product.id.toString(),
    );
    final http.Response response = await http.put(
      BASE_URL + product.id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': product.table,
        'price': product.details
      }),
    );

    developer.log(
      'log me',
      name: 'my.app.category',
      error: 'response status code: ' + response.statusCode.toString(),
    );

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product.');
    }
  }

  Future<int> deleteProduct(String id) async {
    final http.Response response = await http.delete(
        BASE_URL + id
    );

    developer.log(
      'log me',
      name: 'my.app.category',
      error: 'response status code: ' + response.statusCode.toString(),
    );

    if (response.statusCode == 200) {
      return 1;
    } else {
      return -1;
      // throw Exception('Failed to delete product.');
    }
  }

}