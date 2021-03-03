import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/database_util.dart';
import 'package:flutter_app/utils/network_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'package:progress_dialog/progress_dialog.dart';

import 'model/item.dart';

class AddRoute extends StatefulWidget {
  AddRoute();

  @override
  State<StatefulWidget> createState() {
    return AddRouteState();
  }
}

class AddRouteState extends State<AddRoute> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  TextEditingController tableController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  AddRouteState() {}

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(
      _scaffoldKey.currentContext,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
  }


  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Add Item")),
        body: Container(
            child: new Column(
          children: <Widget>[
            new Container(
                child: TextField(
              controller: tableController,
              decoration: InputDecoration(labelText: 'table'),
            )),
            new TextField(
              controller: detailsController,
              decoration: InputDecoration(labelText: 'details'),
            ),
            new Container(
                child: TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'status'),
                )),
            new Container(
                child: TextField(
                  controller: timeController,
                  decoration: InputDecoration(labelText: 'time'),
                )),
            new Container(
                child: TextField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: 'type'),
                )),
            new Container(
              child: RaisedButton(
                child: Text(
                  'Add',
                ),
                onPressed: () async {
                  return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm?"),
                          content:
                              Text("Are you sure you want to add this item?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                                child: Text("Yes!"),
                                onPressed: () async {
                                  Item item;
                                  try {
                                    item = Item(
                                        table: tableController.text,
                                        details: detailsController.text,
                                        status: statusController.text,
                                        time: int.parse(timeController.text),
                                        type: typeController.text);
                                  } on Exception{
                                    item = null;
                                  }
                                  await _add(context1, item);
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

  Future<void> _add(BuildContext context, Item item) async {
    if(item == null) {
      await _showMaterialDialog("Failed to add");
      return;
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //has internet conn

      pr = new ProgressDialog(
        _scaffoldKey.currentContext,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true,
      );
      pr.style(message: "Adding");
      pr.show();
      Item result2 = await networkApi.createItem(item);
      pr.hide();
      // Navigator.pop(context);
      // print("done hide");
      if(result2 != null) {
        item.id = result2.id;
        developer.log(
          'log me',
          name: 'my.app.category',
          error: 'item added to server' + item.toString(),
        );
        await databaseHelper.insertItem(item);

        await _showMaterialDialog("Added successfully");
      }else{
        await _showMaterialDialog("Failed adding");
      }
    } else {
      //no internet conn, add only to the local dbs

      int result1, result2;
      item.id = 0;

      pr = new ProgressDialog(
        _scaffoldKey.currentContext,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true,
      );
      pr.style(message: "Adding");
      pr.show();
      result1 = await databaseHelper.insertItemOffline(item);
      result2 = await databaseHelper.insertItem(item);
      pr.hide();

      if (result1 != 0 && result2 != 0) {
        // Success
        print("add product " + item.toString());
        await _showMaterialDialog("Added successfully");
      } else {
        // Failure
        await _showMaterialDialog("Problem Saving");
      }
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
