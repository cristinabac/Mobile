import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/item.dart';
import 'utils/database_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'utils/network_util.dart';
import 'package:progress_dialog/progress_dialog.dart';

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

  TextEditingController senderController = TextEditingController();
  TextEditingController receiverController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  AddRouteState() {}

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr; // = ProgressDialog(context);


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
                      controller: senderController,
                      decoration: InputDecoration(labelText: 'sender'),
                    )),
                new TextField(
                  controller: receiverController,
                  decoration: InputDecoration(labelText: 'receiver'),
                ),
                new Container(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(labelText: 'text'),
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
                                      Item item = Item(
                                          sender: senderController.text,
                                          receiver: receiverController.text,
                                          text: textController.text,
                                          type: typeController.text);
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
      await pr.show();
      Item result2 = await networkApi.createItem(item);
      await pr.hide();
      if(pr.isShowing())
        await pr.hide();

      if(result2 != null)
        await _showMaterialDialog("Added successfully");
      else
        await _showMaterialDialog("Error adding");
    } else {
      //no internet conn, add only to the local dbs
      // item.id = 0;
      //
      // pr = new ProgressDialog(
      //   _scaffoldKey.currentContext,
      //   type: ProgressDialogType.Normal,
      //   isDismissible: false,
      //   showLogs: true,
      // );
      // pr.style(message: "Adding");
      // await pr.show();
      // int result1 = await databaseHelper.insertItemOffline(item);
      // int result2 = await databaseHelper.insertItem(item);
      // await pr.hide();
      // if(pr.isShowing())
      //   await pr.hide();
      //
      // if(result1 != 0 && result2 != 0)
      //   await _showMaterialDialog("Added successfully");
      // else
      //   await _showMaterialDialog("Error adding");

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
