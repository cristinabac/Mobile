import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_route.dart';
import 'edit_route.dart';
import 'model/item.dart';
import 'utils/database_util.dart';

import 'dart:io';

import 'dart:developer' as developer;

import 'utils/network_util.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sqflite/sqflite.dart';

class Section1Route extends StatefulWidget {
  Section1Route();

  @override
  State<StatefulWidget> createState() {
    return Section1RouteState();
  }
}

class Section1RouteState extends State<Section1Route> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  List<Item> items;
  int count = 0;

  Section1RouteState() {}

  @override
  Widget build(BuildContext context1) {
    if (items == null) {
      items = List<Item>();
      updateListView();
    }

    return Scaffold(
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Section 1")),
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
                                                    this.items[index].name);
                                                Navigator.pop(context);
                                              })
                                        ],
                                      );
                                    });
                              },
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => EditRoute(item: this.items[index])),
                                );
                                updateListView();
                              },
                              title: Text(items[index].name),
                              subtitle: Text(items[index].group.toString() +
                                  "\n" +
                                  items[index].year.toString() +
                                  "\n" +
                                  items[index].id.toString()),
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
            )),
      floatingActionButton: Builder(
        builder: (context1) => FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddRoute()),
            );
            updateListView();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> updateListView() async {
    print("update list view");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //has net
      Future<List<Item>> itemsListFuture = networkApi.getItems();
      itemsListFuture.then((productsList) {
        productsList.sort((a,b){
          int cmp = a.group.compareTo(b.group);
          if (cmp != 0) return cmp;
          return a.name.compareTo(b.name);
        });

        setState(() {
          this.items = productsList;
          this.count = productsList.length;
          print("count from server " + this.count.toString());
        });
      });
    } else {
      this.items = List<Item>();
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
}
