import 'package:flutter_app/model/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //for jsonDecode

import 'dart:developer' as developer;

class NetworkApi{
  static const BASE_URL = "http://192.168.0.241:2202/";

  Future<List<Item>> getItems(String typ) async {
    http.Response res = await http.get(BASE_URL + "robots/" + typ);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      return items;
    } else {
      throw "Can't get items.";
    }
  }

  Future<List<Item>> getItemsOld() async {
    http.Response res = await http.get(BASE_URL + "old");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      return items;
    } else {
      print( "Can't get items.");
      return null;
    }
  }

  Future<List<String>> getTypes() async{
    http.Response res = await http.get(BASE_URL + "types");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<String> items = body.map(
              (dynamic item) => item.toString()).toList();
      return items;
    } else {
      return null;
      // throw "Can't get items.";
    }
  }

  Future<Item> createItem(Item item) async {
    print(item);
    final http.Response response = await http.post(
      BASE_URL + "robot",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': item.name,
        'specs': item.specs,
        'height': item.height,
        'type': item.type,
        'age': item.age
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

  Future<Item> updateHeight(int id, int height) async {
    final http.Response response = await http.post(
      BASE_URL + "height",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'height': height,
      }),
    );
    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to update height.');
      return null;

    }
  }

  Future<Item> updateAge(int id, int age) async {
    final http.Response response = await http.post(
      BASE_URL + "age",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'age': age,
      }),
    );
    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to update height.');
      return null;
    }
  }

  Future<Item> updateProduct(Item item) async {
    developer.log(
      'log me',
      name: 'my.app.category',
      error: 'BASE_URL + product.real_id: ' + BASE_URL + item.id.toString(),
    );
    final http.Response response = await http.put(
      BASE_URL + item.id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'specs': item.specs,
        'height': item.height,
        'type': item.type,
        'age': item.age
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