import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_1/model/item.dart';
import 'package:model_1/utils/database_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'package:model_1/utils/network_util.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sqflite/sqflite.dart';

class Top10Route extends StatefulWidget {
  Top10Route();

  @override
  State<StatefulWidget> createState() {
    return Top10RouteState();
  }
}

class Top10RouteState extends State<Top10Route> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<Item> items;
  int count = 0;

  Top10RouteState() {}

  @override
  Widget build(BuildContext context1) {
    if (items == null) {
      items = List<Item>();
      updateListView();
    }

    return Scaffold(
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Top 3 de fapt :)))")),
        body: Container(
            child: new Column(
              children: <Widget>[
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
                                            "Are you sure you want to delete this item?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Cancel"),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          FlatButton(
                                              child: Text("Yes!"),
                                              onPressed: () async {
                                                print("deleteeeeee " +
                                                    this.items[index].tablee);
                                                Navigator.pop(context);
                                              })
                                        ],
                                      );
                                    });
                              },
                              onTap: () {
                                print("go to edit" + this.items[index].tablee);
                              },
                              title: Text(items[index].tablee),
                              subtitle: Text(items[index].details +
                                  "\n" +
                                  items[index].id.toString() +
                                  "\n" +
                                  items[index].local_id.toString()),
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                              ),
                            ));
                      }),
                ),
                new Container(
                  child: RaisedButton(
                    child: Text("Refresh list"),
                    onPressed:() {
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
      Future<List<Item>> itemsListFuture = networkApi.getItems();
      // Navigator.pop(context);
      itemsListFuture.then((productsList) {
        //in ordine alfabetica???
        productsList.sort((a,b) => a.tablee.compareTo(b.tablee));
        print(productsList);
        List<Item> res = List<Item>();
        for(int i=0; i<productsList.length; i++) {
          if (i >= 3)
            break;
          else {
            res.add(productsList[i]);
          }
        }
        print(res);
        productsList = res;

        setState(() {
          this.items = productsList;
          this.count = productsList.length;
          print("count from server " + this.count.toString());
          // print(this.items.toString());
        });
      });
    } else {
      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((database) {
        Future<List<Item>> itemsListFuture = databaseHelper.getProductList();
        itemsListFuture.then((productsList) {
          setState(() {
            this.items = productsList;
            this.count = productsList.length;
            print("count from db " + this.count.toString());
            // print(this.items.toString());
          });
        });
      });
    }
  }
}
