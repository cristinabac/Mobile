import 'package:flutter_app/model/item.dart';
import 'package:flutter_app/model/lecture.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //for jsonDecode

import 'dart:developer' as developer;

class NetworkApi{
  static const BASE_URL = "http://192.168.0.241:2021/";

  Future<List<Item>> getItems() async {
    http.Response res = await http.get(BASE_URL + "students");
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

  Future<List<Lecture>> getLectures() async {
    http.Response res = await http.get(BASE_URL + "lectures");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Lecture> items = body.map(
              (dynamic item) => Lecture.fromJson(item)).toList();
      return items;
    } else {
      print( "Can't get items.");
      return null;
    }
  }

  Future<Item> updateItem(Item item) async {
    developer.log("update api");
    final http.Response response = await http.post(
      BASE_URL + "student",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id': item.id,
        'name': item.name,
        'group': item.group,
        'year': item.year,
        'status': item.status,
        'credits': item.credits
      }),
    );
    if (response.statusCode == 200) {
      developer.log("done update api");
      return Item.fromJson(jsonDecode(response.body));
    } else {
      developer.log("done update api");
      print('Failed to update.');
      return null;

    }
  }

  Future<int> register(int lectureId, int studId) async {
    developer.log("register api");
    final http.Response response = await http.post(
      BASE_URL + "register",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'lectureId': lectureId,
        'studentId': studId,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      developer.log("done register api");
      return 1;
    } else {
      print("Err in api add");
      developer.log("done register api with err");
      return -1;
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
      BASE_URL + "create",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': item.name,
        'group': item.group,
        'year': item.year,
        'status': item.status,
        'credits': item.credits
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

  Future<int> deleteItem(int id) async {
    developer.log("delete api");
    final http.Response response = await http.delete(
        BASE_URL + "student/" + id.toString()
    );
    if (response.statusCode == 200) {
      developer.log("done delete api");
      return 1;
    } else {
      developer.log("done delete api");
      return -1;
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
        'specs': item.group,
        'height': item.year,
        'type': item.status,
        'age': item.credits
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