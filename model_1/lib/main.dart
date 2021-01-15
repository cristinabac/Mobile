import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:model_1/utils/database_util.dart';
import 'package:model_1/utils/network_util.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/io.dart';

import 'dart:io';

import 'add_route.dart';
import 'model/item.dart';

import 'dart:developer' as developer;

import 'package:connectivity/connectivity.dart';

import 'package:synchronized/synchronized.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter model 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter model 1 home page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> items;

  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;

  NetworkApi networkApi = NetworkApi();

  bool hasInternet = false;

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

  var logger = Logger();

  var wbsoket;

  @override
  void initState() {
    super.initState();

    wbsoket = IOWebSocketChannel.connect("ws://192.168.0.241:3000")
      ..stream.listen((message) {
        var item = Item.fromJson(jsonDecode(message));
        logger.i("websocket: item - " + item.toString());
        var snackbar = new SnackBar(
            content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Id: " + item.id.toString()),
            Text("Title: " + item.title),
          ],
        ));
        // _scaffoldKey.currentState.showSnackBar(snackbar);
      });

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    pollingGet();
    Timer.periodic(Duration(seconds: 20), (_) => pollingGet());
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      items = List<Item>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context1) => Container(
            child: new Column(children: <Widget>[
              new Container(
                child: Text("List 1"),
              ),
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
                                          this.items[index].title);
                                      Navigator.pop(context);
                                    })
                              ],
                            );
                          });
                    },
                    onTap: () {
                      print("go to edit" + this.items[index].title);
                    },
                    title: Text(items[index].title),
                    subtitle: Text(items[index].date +
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
            child: Text("List 2"),
          ),
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
                                          this.items[index].title);
                                      Navigator.pop(context);
                                    })
                              ],
                            );
                          });
                    },
                    onTap: () {
                      print("go to edit" + this.items[index].title);
                    },
                    title: Text(items[index].title),
                    subtitle: Text(items[index].date +
                        "\n" +
                        items[index].id.toString() +
                        "\n" +
                        items[index].local_id.toString()),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                    ),
                  ));
                }),
          )
        ])),
      ),
      bottomNavigationBar: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder:
              (BuildContext ctxt, AsyncSnapshot<ConnectivityResult> snapShot) {
            if (!snapShot.hasData) return CircularProgressIndicator();
            var result = snapShot.data;
            switch (result) {
              case ConnectivityResult.none:
                hasInternet = false;
                print("no net");
                return Text("No Internet Connection!");
              case ConnectivityResult.mobile:
                print("yes net mobile");
                if (hasInternet == false) gotInternetConnection();
                hasInternet = true;
                // return Text('You have internet connection, yay :D');
                return Text("");
              case ConnectivityResult.wifi:
                print("yes net wifi");
                if (hasInternet == false) gotInternetConnection();
                hasInternet = true;
                // return Text('You have internet connection, yay :D');
                return Text("");
              default:
                hasInternet = false;
                return Text("No Internet Connection!");
            }
          }),
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
      ),
      backgroundColor: Color(0xFFF4E8F4),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  /// Updates the list view after each operation
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
      // Navigator.pop(context);
      itemsListFuture.then((productsList) {
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
            print(this.items.toString());
          });
        });
      });
    }
  }

  Future<void> gotInternetConnection() async {
    //find the products that were added offline (from the offline table)
    //and send them to the server
    print("GOT INTERNET CONN");
    Future<List<Item>> productsListFuture =
        databaseHelper.getProductListOffline();
    productsListFuture.then((productsList) async {
      for (int i = 0; i < productsList.length; i++) {
        Item p = productsList[i];
        Item res = await this.networkApi.createItem(p.title, p.date);
        // print("add product" + res.toString());
        // p.id = res.id; //take the real_id from server
        // await this.databaseHelper.updateProduct(p); //add the real_id to the db
      }
      updateListView();
    });
  }

  pollingGet() async {
    //do the sync stuff every 10 seconds
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("sync");
      Future<List<Item>> itemsListFuture = networkApi.getItems();
      databaseHelper.deleteAll();
      itemsListFuture.then((productsList) {
        for (int i = 0; i < productsList.length; i++)
          this.databaseHelper.insertItem(productsList[i]);
      });
    }
  }
}
