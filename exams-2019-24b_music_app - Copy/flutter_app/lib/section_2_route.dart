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

class Section2Route extends StatefulWidget {
  Section2Route();

  @override
  State<StatefulWidget> createState() {
    return Section2RouteState();
  }
}

class Section2RouteState extends State<Section2Route> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final logController = TextEditingController();

  List<Item> lst;
  int count;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;

  Section2RouteState() {}

  @override
  void initState() {
    super.initState();
    getLog();
  }

  getLog() async {
    final SharedPreferences prefs = await _prefs;
    int id = (prefs.getInt("id") ?? "");
    logController.text = id.toString();
  }

  @override
  Widget build(BuildContext context1) {
    if (lst == null) {
      lst = List<Item>();
      count = 0;
      updateListView();
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Section 2")),
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
                                          labelText: 'New id',
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
                                      prefs.setInt(
                                          "id", int.parse(logController.text));
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
            new Expanded(
              child: ListView.builder(
                  itemCount: count,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                        child: ListTile(
                      onLongPress: () async {},
                      onTap: () async {},
                      title: Text(lst[index].toString()),
                      subtitle: Text(lst[index].toString()),
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                      ),
                    ));
                  }),
            ),
            new Container(
              child: RaisedButton(
                child: Text("Refresh list"),
                onPressed: () {
                  updateListView();
                },
              ),
            )
          ],
        )));
  }


  Future<void> updateListView() async {
    print("update list view");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //has net
      pr = new ProgressDialog(
        _scaffoldKey.currentContext,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true,
      );
      pr.style(message: "Getting data");
      await pr.show();

      List<Item> productsList = await networkApi.getAll();

      setState(() {
        this.lst = productsList;
        this.count = productsList.length;
        print("count from server " + this.count.toString());
      });

      await pr.hide();
      if (pr.isShowing()) {
        await pr.hide();
      }

    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("you are offline")));
      // if(lst == null) {
      //   setState(() {
      //     this.lst = List<Lecture>();
      //     this.count = 0;
      //     print("reinitialize lst");
      //   });
      // }
      // else{
      //   setState(() {
      //     this.lst = lst;
      //     this.count = lst.length;
      //     print("count from local storage " + this.count.toString());
      //   });
      // }
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
