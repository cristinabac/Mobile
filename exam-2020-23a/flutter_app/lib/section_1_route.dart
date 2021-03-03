import 'package:connectivity/connectivity.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/database_util.dart';
import 'package:flutter_app/utils/network_util.dart';

import 'dart:io';

import 'dart:developer' as developer;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sqflite/sqflite.dart';

import 'add_route.dart';
import 'model/item.dart';

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
    if (items == null) {
      items = List<Item>();
      updateListView();
    }

    return Scaffold(
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Waiter Section")),
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
                                                    this.items[index].table);
                                                Navigator.pop(context);
                                              })
                                        ],
                                      );
                                    });
                              },
                              onTap: () {
                                print("go to edit" + this.items[index].table);
                              },
                              title: Text(items[index].table),
                              subtitle: Text(items[index].details +
                                  "\n" +
                                  items[index].status +
                                  "\n" +
                                  items[index].time.toString() +
                                  "\n" +
                                  items[index].type +
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
              ],
            )),
      floatingActionButton: Builder(
        builder: (context1) => FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddRoute()),
            );
            if (result != null) updateListView();
          },
          child: const Icon(Icons.add),
        ),
      ),);
  }

  Future<void> updateListView() async {
    developer.log(
      'log me',
      name: 'my.app.category',
      error: 'in update list view',
    );

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //has net
      Future<List<Item>> itemsListFuture = networkApi.getItems();
      itemsListFuture.then((productsList) {
        setState(() {
          List<Item> res = List<Item>();
          for(int i=0; i<productsList.length; i++)
            if (productsList[i].status == 'ready')
              res.add(productsList[i]);
          productsList = res;
          this.items = productsList;
          this.count = productsList.length;
          print("count from server " + this.count.toString());
          // print(this.items.toString());
        });
      });
      // pr.hide();
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
