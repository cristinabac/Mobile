import 'package:flutter/material.dart';
import 'package:flutter_app/model/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //for jsonDecode

import 'dart:developer' as developer;

class NetworkApi{
  static const BASE_URL = "http://192.168.0.241:2021/";

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

}