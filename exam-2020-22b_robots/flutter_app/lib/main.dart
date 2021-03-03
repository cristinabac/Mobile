import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/section_1_route.dart';
import 'package:flutter_app/utils/database_util.dart';
import 'package:flutter_app/utils/network_util.dart';
import 'package:logger/logger.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/io.dart';

import 'dart:io';

import 'model/item.dart';

import 'dart:developer' as developer;

import 'package:connectivity/connectivity.dart';

import 'package:synchronized/synchronized.dart';

import 'section_2_route.dart';

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
  int count = 0;

  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  bool hasInternet = false;

  var logger = Logger();

  var wbsoket;

  BuildContext ctx;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ProgressDialog pr;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final nameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    // wbsoket = IOWebSocketChannel.connect("ws://192.168.0.241:3000")
    //   ..stream.listen((message) {
    //     var item = Item.fromJson(jsonDecode(message));
    //     logger.i("websocket: item - " + item.toString());
    //     _scaffoldKey.currentState.showSnackBar(SnackBar(
    //         content: Text("WebSocket: title-" +
    //             item.id.toString() +
    //             ", date" +
    //             item.details.toString())));
    //   });

    getName();

    pollingGet();
    Timer.periodic(Duration(seconds: 20), (_) => pollingGet());
  }

  getName() async {
    final SharedPreferences prefs = await _prefs;
    String name = (prefs.getString("name") ?? "");
    nameTextController.text = name.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      items = List<Item>();
      updateListView();
    }

    ctx = context;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context1) => Container(
            child: new Column(children: <Widget>[
          new Container(
            child: RaisedButton(
              child: Text("Go to Main Section"),
              onPressed: () async {
                print("pressed button go to section 1");
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Section1Route()),
                );
                // if (result != null) updateListView();
              },
            ),
          ),
          new Container(
            child: RaisedButton(
              child: Text("Go to Age Section"),
              onPressed: () async {
                print("pressed button go to section 2");
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Section2Route()),
                );
                // if (result != null) updateListView();
              },
            ),
          ),
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
                                controller: nameTextController,
                                decoration: InputDecoration(
                                  labelText: 'New name',
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
                              final SharedPreferences prefs = await _prefs;
                              prefs.setString("name", nameTextController.text);
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
            child: Text("Log")
          ))
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
      backgroundColor: Color(0xFFF4E8F4),
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  /// Updates the list view after each operation
  Future<void> updateListView() async {
    // developer.log(
    //   'log me',
    //   name: 'my.app.category',
    //   error: 'in update list view',
    // );
    //
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile ||
    //     connectivityResult == ConnectivityResult.wifi) {
    //   //has net
    //   pr = new ProgressDialog(
    //     _scaffoldKey.currentContext,
    //     type: ProgressDialogType.Normal,
    //     isDismissible: false,
    //     showLogs: true,
    //   );
    //   pr.style(message: "Getting data");
    //   pr.show();
    //   Future<List<Item>> itemsListFuture = networkApi.getItems();
    //   pr.hide();
    //   itemsListFuture.then((productsList) {
    //     setState(() {
    //       this.items = productsList;
    //       this.count = productsList.length;
    //       print("count from server " + this.count.toString());
    //       // print(this.items.toString());
    //     });
    //   });
    //   // pr.hide();
    // } else {
    //   pr = new ProgressDialog(
    //     _scaffoldKey.currentContext,
    //     type: ProgressDialogType.Normal,
    //     isDismissible: false,
    //     showLogs: true,
    //   );
    //   pr.style(message: "Getting data");
    //   pr.show();
    //   final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    //   dbFuture.then((database) {
    //     Future<List<Item>> itemsListFuture = databaseHelper.getProductList();
    //     itemsListFuture.then((productsList) {
    //       setState(() {
    //         this.items = productsList;
    //         this.count = productsList.length;
    //         print("count from db " + this.count.toString());
    //         // print(this.items.toString());
    //       });
    //     });
    //   });
    //   pr.hide();
    // }
    // return this.items;
  }

  Future<void> gotInternetConnection() async {
    //find the products that were added offline (from the offline table)
    //and send them to the server
    // print("GOT INTERNET CONN");
    // Future<List<Item>> productsListFuture =
    //     databaseHelper.getProductListOffline();
    // productsListFuture.then((productsList) async {
    //   for (int i = 0; i < productsList.length; i++) {
    //     Item p = productsList[i];
    //     Item res = await this.networkApi.createItem(p.title, p.date);
    //     // print("add product" + res.toString());
    //     // p.id = res.id; //take the real_id from server
    //     // await this.databaseHelper.updateProduct(p); //add the real_id to the db
    //   }
    //   updateListView();
    // });
    // await databaseHelper.deleteAllOffline();
  }

  pollingGet() async {
    // do the sync stuff every 10 seconds
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile ||
    //     connectivityResult == ConnectivityResult.wifi) {
    //   // print("sync");
    //   Future<List<Item>> itemsListFuture = networkApi.getItemsOld();
    //   databaseHelper.deleteAll();
    //   itemsListFuture.then((productsList) {
    //     print("sync");
    //     print(productsList.length);
    //     for (int i = 0; i < productsList.length; i++)
    //       this.databaseHelper.insertItem(productsList[i]);
    //   });
    // }
  }
}
