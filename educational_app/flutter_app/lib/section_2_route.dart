import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/item.dart';
import 'model/lecture.dart';
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

  List<Lecture> lst;
  int count = 0;

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
      lst = List<Lecture>();
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

            new Expanded(
              child: ListView.builder(
                //itemCount: products.length,
                  itemCount: count,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                        child: ListTile(
                          onLongPress: () async {
                            return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm?"),
                                    content: Text(
                                        "Are you sure you want to register to this course?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Cancel"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      FlatButton(
                                          child: Text("Yes!"),
                                          onPressed: () async {
                                            await _register(context1, lst[index]);
                                            Navigator.pop(context);
                                          })
                                    ],
                                  );
                                });
                          },
                          onTap: () async {},
                          title: Text(lst[index].name),
                          subtitle: Text(lst[index].id.toString()),
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                          ),
                        ));
                  }),
            ),

          ],
        )
        ));
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

  Future<void> updateListView() async {
    print("update list view");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //has net
      Future<List<Lecture>> itemsListFuture = networkApi.getLectures();
      itemsListFuture.then((productsList) {
        setState(() {
          this.lst = productsList;
          this.count = productsList.length;
          print("count from server " + this.count.toString());
        });
      });
    } else {
      this.lst = List<Lecture>();
      this.count = 0;
      // final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      // dbFuture.then((database) {
      //   Future<List<Item>> itemsListFuture = databaseHelper.getProductList();
      //   itemsListFuture.then((productsList) {
      //     setState(() {
      //       this.items = productsList;
      //       this.count = productsList.length;
      //       print("count from db " + this.count.toString());
      //       // print(this.items.toString());
      //     });
      //   });
      // });
    }
  }

  Future<void> _register(BuildContext context, Lecture lecture) async {

    final SharedPreferences prefs = await _prefs;
    int id = (prefs.getInt("id") ?? "");

    pr = new ProgressDialog(
      _scaffoldKey.currentContext,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
    pr.style(message: "Registering");
    pr.show();
    int result = await networkApi.register(lecture.id, id);
    pr.hide();

    if(result != -1) {
      await _showMaterialDialog(" successfully");
    } else{
      await _showMaterialDialog(" failed");
    }
  }

}
