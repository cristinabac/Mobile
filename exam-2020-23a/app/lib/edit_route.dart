import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_1/model/item.dart';
import 'package:model_1/utils/database_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'package:model_1/utils/network_util.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditRoute extends StatefulWidget {
  Item item;
  EditRoute({this.item});

  @override
  State<StatefulWidget> createState() {
    return EditRouteState(this.item);
  }
}

class EditRouteState extends State<EditRoute> {
  Item item;

  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  EditRouteState(Item item) {
    this.item = item;
    titleController = TextEditingController(text: item.tablee);
    dateController = TextEditingController(text: item.details);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  // @override
  // void initState() {
  //   super.initState();
  //   pr = new ProgressDialog(
  //     _scaffoldKey.currentContext,
  //     type: ProgressDialogType.Normal,
  //     isDismissible: false,
  //     showLogs: true,
  //   );
  // }
  //

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
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'title'),
                    )),
                new TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'date'),
                ),
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
                                      item.tablee = titleController.text;
                                      item.details = dateController.text;
                                      await _update(context1, item);
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

  Future<void> _update(BuildContext context, Item item) async {
    Item result;

    pr = new ProgressDialog(
      _scaffoldKey.currentContext,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
    pr.style(message: "Updating");
    pr.show();

    // result = await networkApi.updateProduct(item);
    // print(result);
    //
    // await databaseHelper.updateProduct(item);
    print("updating...");
    await Future.delayed(Duration(seconds: 2));
    pr.hide();

    await _showMaterialDialog("Product " + item.tablee + " updated successfully");
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
