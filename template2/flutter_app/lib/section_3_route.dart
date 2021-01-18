import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/item.dart';
import 'utils/database_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'utils/network_util.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sqflite/sqflite.dart';

class Section3Route extends StatefulWidget {
  Section3Route();

  @override
  State<StatefulWidget> createState() {
    return Section3RouteState();
  }
}

class Section3RouteState extends State<Section3Route> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();


  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final logController = TextEditingController();

  List<Item> lst;
  int count = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;

  Section3RouteState() {}

  @override
  void initState() {
    super.initState();
    getLog();
  }

  getLog() async {
    final SharedPreferences prefs = await _prefs;
    String name = (prefs.getString("name") ?? "");
    logController.text = name.toString();
  }


  @override
  Widget build(BuildContext context1) {
    if (lst == null) {
      lst = List<Item>();
      // updateListView();
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Section 3")),
        body: Container(
            child: new Column(
              children: <Widget>[
                new Container(
                    child: RaisedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Text('Login'),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Form(
                                      child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            controller: logController,
                                            decoration: InputDecoration(
                                              labelText: 'New name',
                                              icon: Icon(Icons.account_box),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    RaisedButton(
                                        child: Text("Save"),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          final SharedPreferences prefs =
                                          await _prefs;
                                          prefs.setString(
                                              "name", logController.text);
                                          print(prefs.getString("name"));
                                        }),
                                    RaisedButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ],
                                );
                              });
                        },
                        child: Text("Log"))),



              ],
            )
        ));
  }



}
