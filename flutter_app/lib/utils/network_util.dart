import 'package:flutter/material.dart';
import 'package:flutter_app/model/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //for jsonDecode

import 'dart:developer' as developer;

class NetworkApi{
  static const BASE_URL = "http://192.168.0.241:2018/";

  Future<List<Item>> getItems() async {
    developer.log("get all api - entered");
    http.Response res = await http.get(BASE_URL + "exams");
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

  Future<List<Item>> getExams(String group) async {
    developer.log("getExams api - entered");
    http.Response res = await http.get(BASE_URL + "group/" + group);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      developer.log("getExams api - done");
      return items;
    } else {
      developer.log("getExams api - done with error");
      return null;
    }
  }

  Future<List<Item>> getDraft() async {
    developer.log("getDraft api - entered");
    http.Response res = await http.get(BASE_URL + "draft");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      developer.log("getDraft api - done");
      return items;
    } else {
      developer.log("getDraft api - done with error");
      return null;
    }
  }

  Future<Item> createItem(Item item) async {
    developer.log("api create item - item: " + item.toString());
    final http.Response response = await http.post(
      BASE_URL + "exam",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': item.name,
        'group': item.group,
        'details': item.details,
        'type': item.type,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      developer.log("api create item - done");
      return Item.fromJson(jsonDecode(response.body));
    } else {
      // throw Exception('Failed to create.');
      developer.log("api create item - done with err");
      return null;
    }
  }

  Future<Item> getItem(int id) async {
    developer.log("getItem api - entered");
    http.Response res = await http.get(BASE_URL + "exam/" + id.toString());
    if (res.statusCode == 200) {
      developer.log("getItem api - done");
      return Item.fromJson(jsonDecode(res.body));
    } else {
      developer.log("getItem api - done with error");
      return null;
    }
  }


  Future<int> joinPost(int id) async {
    developer.log("joinPost api");
    final http.Response response = await http.post(
      BASE_URL + "join",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      developer.log("done joinPost api");
      return 1;
    } else {
      developer.log("done joinPost api with err");
      return -1;
    }
  }


}