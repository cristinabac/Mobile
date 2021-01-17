import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_1/model/item.dart';
import 'package:model_1/top_10_route.dart';
import 'package:model_1/utils/database_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'package:model_1/utils/network_util.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Section1Route extends StatefulWidget {
  Section1Route();

  @override
  State<StatefulWidget> createState() {
    return Section1RouteState();
  }
}

class Section1RouteState extends State<Section1Route> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Section1RouteState() {}

  // ProgressDialog pr;
  // @override
  // void initState() {
  //   pr = new ProgressDialog(
  //     context,
  //     type: ProgressDialogType.Normal,
  //     isDismissible: false,
  //     showLogs: true,
  //   );
  // }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Add Item")),
        body: Container(
            child: new Column(
              children: <Widget>[
                new Container(
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'title'),
                    )),
                new TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'date'),
                ),
                new Container(
                  child: RaisedButton(
                    child: Text('Add'),
                    onPressed: () {
                      print("add...");
                    },
                  ),
                ),
                new Container(
                  child: RaisedButton(
                    child: Text("See top 10"),
                    onPressed: () async {
                      print("Go to top 10 screen");
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Top10Route()),
                      );
                    },
                  ),
                )
              ],
            )));
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Future<void> _showMaterialDialog(String text) async {
    await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('OK!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
}
