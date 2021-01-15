import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_1/model/item.dart';
import 'package:model_1/utils/database_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'package:model_1/utils/network_util.dart';
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

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  AddRouteState() {}

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
        body: ListView(children: <Widget>[
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'title'),
          ),
          TextField(
            controller: dateController,
            decoration: InputDecoration(labelText: 'date'),
          ),
          Row(
            children: <Widget>[
              Expanded(
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
                                        title: titleController.text,
                                        date: dateController.text);
                                    await _add(context1, item);
                                    Navigator.pop(context);
                                    // Navigator.pop(context); //bc of the pr??
                                    Navigator.pop(context, item);
                                  })
                            ],
                          );
                        });
                  },
                ),
              ),
            ],
          )
        ]));
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

  Future<void> _add(BuildContext context, Item item) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //has internet conn

      String date = new DateTime.now().toString();
      print(date);
      // this.pr.style(message: "Adding");
      // this.pr.show();
      // showLoaderDialog(context);
      // ProgressDialog pr = new ProgressDialog(
      //       context,
      //       type: ProgressDialogType.Normal,
      //       isDismissible: false,
      //       showLogs: true,
      //     );
      // pr.style(message: "Adding");
      // pr.show();
      Item result2 = await networkApi.createItem(item.title, date);
      // pr.hide();
      // Navigator.pop(context);
      // print("done hide");
      item.id = result2.id;

      developer.log(
        'log me',
        name: 'my.app.category',
        error: 'item added to server' + item.toString(),
      );

      int result3 = await databaseHelper.insertItem(item);

      await _showMaterialDialog("Added successfully");
    } else {
      //no internet conn, add only to the local dbs

      int result1, result2;
      item.id = 0;
      String date = new DateTime.now().toString();
      item.date = date;
      result1 = await databaseHelper.insertItemOffline(item);
      result2 = await databaseHelper.insertItem(item);

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
