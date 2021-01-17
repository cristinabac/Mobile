import 'package:flutter/material.dart';
import 'package:flutter_app/model/item.dart';
import 'package:flutter_app/model/lecture.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //for jsonDecode

import 'dart:developer' as developer;

class NetworkApi{
  static const BASE_URL = "http://192.168.0.241:2101/";

  Future<Item> createItem(Item item) async {
    developer.log("api create item - item: " + item.toString());
    final http.Response response = await http.post(
      BASE_URL + "message",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'sender': item.sender,
        'receiver': item.receiver,
        'text': item.text,
        'type': item.type,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      developer.log("api create item - done");
      return Item.fromJson(jsonDecode(response.body));
    } else {
      developer.log("api create item - done with err");
      return null;
    }
  }


  Future<List<Item>> getPublic() async {
    developer.log("get all api - entered");
    http.Response res = await http.get(BASE_URL + "public");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      developer.log("get all api - done");
      return items;
    } else {
      developer.log("get all api - done with error");
      return null;
    }
  }

  Future<List<String>> getUsers() async{
    developer.log("get all users - entered");
    http.Response res = await http.get(BASE_URL + "users");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<String> items = body.map(
              (dynamic item) => item.toString()).toList();
      developer.log("get all users - done");
      return items;
    } else {
      developer.log("get all users - done with error");
      return null;
      // throw "Can't get items.";
    }
  }

  Future<List<Item>> getSender(String user) async{
    developer.log("api getSender- entered");
    http.Response res = await http.get(BASE_URL + "sender/" + user);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      developer.log("api getSender - done");
      return items;
    } else {
      developer.log("api getSender - done with error");
      return null;
      // throw "Can't get items.";
    }
  }

  Future<List<Item>> getReceiver(String user) async{
    developer.log("api getReceiver- entered");
    http.Response res = await http.get(BASE_URL + "receiver/" + user);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      developer.log("api getReceiver - done");
      return items;
    } else {
      developer.log("api getReceiver - done with error");
      return null;
      // throw "Can't get items.";
    }
  }

  Future<List<Item>> getItems() async {
    developer.log("get all api - entered");
    http.Response res = await http.get(BASE_URL + "students");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      developer.log("get all api - done");
      return items;
    } else {
      developer.log("get all api - done with error");
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
  //
  // Future<Item> updateItem(Item item) async {
  //   developer.log("update api");
  //   final http.Response response = await http.post(
  //     BASE_URL + "student",
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       'id': item.id,
  //       'name': item.sender,
  //       'group': item.date,
  //       'year': item.year,
  //       'status': item.receiver,
  //       'credits': item.credits
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     developer.log("done update api");
  //     return Item.fromJson(jsonDecode(response.body));
  //   } else {
  //     developer.log("done update api");
  //     print('Failed to update.');
  //     return null;
  //
  //   }
  // }

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

  // Future<Item> createItem(Item item) async {
  //   developer.log("api create item - item: " + item.toString());
  //   final http.Response response = await http.post(
  //     BASE_URL + "create",
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       'name': item.sender,
  //       'group': item.date,
  //       'year': item.year,
  //       'status': item.receiver,
  //       'credits': item.credits
  //     }),
  //   );
  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     developer.log("api create item - done");
  //     return Item.fromJson(jsonDecode(response.body));
  //   } else {
  //     // throw Exception('Failed to create.');
  //     developer.log("api create item - done with err");
  //     return null;
  //   }
  // }

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

  // Future<Item> updateProduct(Item item) async {
  //   developer.log(
  //     'log me',
  //     name: 'my.app.category',
  //     error: 'BASE_URL + product.real_id: ' + BASE_URL + item.id.toString(),
  //   );
  //   final http.Response response = await http.put(
  //     BASE_URL + item.id.toString(),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       'specs': item.date,
  //       'height': item.year,
  //       'type': item.receiver,
  //       'age': item.credits
  //     }),
  //   );
  //
  //   developer.log(
  //     'log me',
  //     name: 'my.app.category',
  //     error: 'response status code: ' + response.statusCode.toString(),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return Item.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to update product.');
  //   }
  // }

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