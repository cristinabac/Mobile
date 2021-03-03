import 'package:connectivity/connectivity.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/database_util.dart';
import 'package:flutter_app/utils/network_util.dart';

import 'dart:io';

import 'dart:developer' as developer;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sqflite/sqflite.dart';

import 'add_route.dart';
import 'edit_route.dart';
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

  List<String> types;
  int countTypes = 0;

  List<Item> items;
  int count = 0;

  bool hasInternet = false;

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
    if (items == null || types == null) {
      items = List<Item>();
      types = List<String>();
      updateListView();
    }

    return Scaffold(
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Waiter Section")),
        body: Container(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: Text("Paints list"),
                ),
                new Expanded(
                  child: ListView.builder(
                      itemCount: countTypes,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                            child: ListTile(
                              onTap: () {
                                typeTapped(types[index]);
                              },
                              title: Text(types[index]),
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                              ),
                            ));
                      }),
                ),
                new Expanded(
                  child: ListView.builder(
                      itemCount: count,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                            child: ListTile(
                              onLongPress: () async {},
                              onTap: () async {
                                var connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.mobile ||
                                    connectivityResult == ConnectivityResult.wifi) {
                                  print("go to edit" + this.items[index].specs);
                                  final result = await Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                        builder: (context) => EditRoute(item: this.items[index])),
                                  );
                                  updateListView();
                                }else{
                                  await _showMaterialDialog("Update not available");
                                }
                              },
                              title: Text(items[index].specs),
                              subtitle: Text(items[index].name +
                                  "\n" +
                                  items[index].specs +
                                  "\n" +
                                  items[index].height.toString() +
                                  "\n" +
                                  items[index].type +
                                  "\n" +
                                  items[index].age.toString() +
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
      // bottomNavigationBar: StreamBuilder(
      //     stream: Connectivity().onConnectivityChanged,
      //     builder:
      //         (BuildContext ctxt, AsyncSnapshot<ConnectivityResult> snapShot) {
      //       if (!snapShot.hasData) return CircularProgressIndicator();
      //       var result = snapShot.data;
      //       switch (result) {
      //         case ConnectivityResult.none:
      //           hasInternet = false;
      //           print("no net");
      //           return Text("No Internet Connection!");
      //         case ConnectivityResult.mobile:
      //           print("yes net mobile");
      //           if (hasInternet == false) gotInternetConnection();
      //           hasInternet = true;
      //           // return Text('You have internet connection, yay :D');
      //           return Text("");
      //         case ConnectivityResult.wifi:
      //           print("yes net wifi");
      //           if (hasInternet == false) gotInternetConnection();
      //           hasInternet = true;
      //           // return Text('You have internet connection, yay :D');
      //           return Text("");
      //         default:
      //           hasInternet = false;
      //           return Text("No Internet Connection!");
      //       }
      //     }),
      floatingActionButton: Builder(
        builder: (context1) => FloatingActionButton(
          onPressed: () async {
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi) {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddRoute()),
              );
              if (result != null) updateListView();
            } else{
              await _showMaterialDialog("Not available offline");
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> updateListView() async {
    this.items = List<Item>();
    this.count = 0;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //has net
      Future<List<String>> paintsListFuture = networkApi.getTypes();
      paintsListFuture.then((productsList) {
        setState(() {
          this.types = productsList;
          this.countTypes = productsList.length;
          print("count from server " + this.countTypes.toString());
          print(this.types.toString());
        });
      });
    } else {
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

  void gotInternetConnection() {}

  void typeTapped(String typ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //has net
      Future<List<Item>> itemsListFuture = networkApi.getItems(typ);
      itemsListFuture.then((productsList) {
        setState(() {
          this.items = productsList;
          this.count = productsList.length;
        });
      });
    } else {}
  }
}
