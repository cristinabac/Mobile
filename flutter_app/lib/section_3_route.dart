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

  TextEditingController groupController = TextEditingController();


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
    // if (lst == null) {
    //   lst = List<Item>();
    //   updateListView();
    // }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Section 3")),
        body: Container(
            child: new Column(
              children: <Widget>[

                new Container(
                    child: TextField(
                      controller: groupController,
                      decoration: InputDecoration(labelText: 'group'),
                    )),

                new Expanded(
                  child: ListView.builder(
                      itemCount: count,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                            child: ListTile(
                              onLongPress: () async {},
                              onTap: () async {
                              },
                              title: Text(lst[index].id.toString()),
                              subtitle: Text(lst[index].name + ", " + lst[index].group + ", " + lst[index].type
                                  + "\n type: " + lst[index].type +
                                  "\n students: " +
                                  lst[index].students.toString()),
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                              ),
                            ));
                      }),
                ),

                new Container(
                  child: RaisedButton(
                    child: Text(
                      'See exams',
                    ),
                    onPressed: () async {
                      lst = List<Item>();
                      updateListView();
                      },
                  ),
                ),


              ],
            )
        ));
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

      String group = groupController.text;
      List<Item> productsList = await networkApi.getExams(group);


      if(productsList != null) {
        productsList.sort((a, b) {
          int cmp = a.type.compareTo(b.type);
          if (cmp != 0) return cmp;
          return b.students.compareTo(a.students);
        });
        setState(() {
          this.lst = productsList;
          this.count = productsList.length;
          print("count from server " + this.count.toString());
        });
      }
      else{
        this.count = 0;
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No exams")));
      }

      await pr.hide();
      if (pr.isShowing()) {
        await pr.hide();
      }

    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("you are offline")));
    }
  }




}
