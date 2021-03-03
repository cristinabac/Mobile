import 'package:flutter/material.dart';
import 'package:flutter_app/model/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //for jsonDecode

import 'dart:developer' as developer;

class NetworkApi{
  static const BASE_URL = "http://192.168.0.241:2224/";

  Future<List<String>> getGenres() async{
    http.Response res = await http.get(BASE_URL + "genres");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<String> items = body.map(
              (dynamic item) => item.toString()).toList();
      return items;
    } else {
      return null;
    }
  }

  Future<List<Item>> getSongs(String genre) async{
    http.Response res = await http.get(BASE_URL + "songs/" + genre);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Item> items = body.map(
              (dynamic item) => Item.fromJson(item)).toList();
      return items;
    } else {
      return null;
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

  Future<List<Item>> getAll() async {
    developer.log("get all api - entered");
    http.Response res = await http.get(BASE_URL + "all");
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