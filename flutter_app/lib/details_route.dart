import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/item.dart';
import 'utils/database_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'utils/network_util.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DetailsRoute extends StatefulWidget {
  int id;
  DetailsRoute({this.id});

  @override
  State<StatefulWidget> createState() {
    return DetailsRouteState(this.id);
  }
}

class DetailsRouteState extends State<DetailsRoute> {
  int id;
  Item item;

  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  TextEditingController nameController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController studentsController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  DetailsRouteState(int id) {
    this.id = id;
    // nameController = TextEditingController(text: item.name);
    // groupController = TextEditingController(text: item.group.toString());
    // yearController = TextEditingController(text: item.year.toString());
    // statusController = TextEditingController(text: item.status);
    // creditsController = TextEditingController(text: item.credits.toString());
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;

  @override
  Widget build(BuildContext context1) {
    getItem();


    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Edit Item")),
        body: Container(
            child: new Column(
              children: <Widget>[
                new Container(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'name'),
                    )),

                new TextField(
                  controller: groupController,
                  decoration: InputDecoration(labelText: 'group'),
                ),

                new Container(
                    child: TextField(
                      controller: detailsController,
                      decoration: InputDecoration(labelText: 'details'),
                    )),

                new Container(
                    child: TextField(
                      controller: statusController,
                      decoration: InputDecoration(labelText: 'status'),
                    )),

                new Container(
                    child: TextField(
                      controller: studentsController,
                      decoration: InputDecoration(labelText: 'students'),
                    )),

                new Container(
                    child: TextField(
                      controller: typeController,
                      decoration: InputDecoration(labelText: 'type'),
                    )),

              ],
            )));
  }

  Future<void> getItem() async {
    // print("update list view");

    pr = new ProgressDialog(
      _scaffoldKey.currentContext,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
    pr.style(message: "getting data");
    await pr.show();

    Item result = await networkApi.getItem(id);
    // Item result;

    await pr.hide();
    if(pr.isShowing())
      await pr.hide();

    if(result != null) {
      // await _showMaterialDialog(" successfully");
      nameController.text = result.name;
       groupController.text=result.group;
       detailsController.text = result.details;
       statusController.text= result.status;
       studentsController.text= result.students.toString();
       typeController.text = result.type;
    } else{
      // await _showMaterialDialog(" failed");
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
