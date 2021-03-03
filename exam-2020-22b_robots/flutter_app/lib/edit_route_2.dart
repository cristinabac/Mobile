import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/item.dart';
import 'utils/database_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'utils/network_util.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditRoute2 extends StatefulWidget {
  Item item;
  EditRoute2({this.item});

  @override
  State<StatefulWidget> createState() {
    return EditRoute2State(this.item);
  }
}

class EditRoute2State extends State<EditRoute2> {
  Item item;

  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  TextEditingController ageController = TextEditingController();

  EditRoute2State(Item item) {
    this.item = item;
    ageController = TextEditingController(text: item.age.toString());
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Edit Item")),
        body: Container(
            child: new Column(
              children: <Widget>[
                new Container(
                    child: TextField(
                      controller: ageController,
                      decoration: InputDecoration(labelText: 'age'),
                    )),
                new Container(
                  child: RaisedButton(
                    child: Text("Update"),
                    onPressed: () async {
                      return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm?"),
                              content:
                              Text("Are you sure you want to update this item?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FlatButton(
                                    child: Text("Yes!"),
                                    onPressed: () async {
                                      await _update(context1, item.id, ageController.text);
                                      Navigator.pop(context);
                                      Navigator.pop(context, item);
                                    })
                              ],
                            );
                          });
                    },
                  ),
                ),
              ],
            )));
  }

  Future<void> _update(BuildContext context,int id, String age) async {

    pr = new ProgressDialog(
      _scaffoldKey.currentContext,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
    pr.style(message: "Updating");
    pr.show();

    int ageInt = int.parse(age);

    Item result = await networkApi.updateAge(id, ageInt);

    pr.hide();

    if(result != null) {
      await _showMaterialDialog("updated successfully");
    } else{
      await _showMaterialDialog("update failed");
    }
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
