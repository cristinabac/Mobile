import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'add_route.dart';
import 'details_route.dart';
import 'edit_route.dart';
import 'model/item.dart';
import 'utils/database_util.dart';
import 'package:logger/logger.dart';

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

  var logger = Logger();
  var wbsoket;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ProgressDialog pr;

  Section1RouteState() {}

  @override
  void initState() {
    super.initState();
    wbsoket = IOWebSocketChannel.connect("ws://192.168.0.241:2018")
      ..stream.listen((message) {
        var item = Item.fromJson(jsonDecode(message));
        logger.i("websocket: item - " + item.toString());
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text("WebSocket: new exam! name-" + item.name + ", group" + item.group)));
      }, onError: onError);
  }

  onError(err) {
    developer.log("err web socket conn");
  }

  @override
  Widget build(BuildContext context1) {
    if (items == null) {
      items = List<Item>();
      updateListView();
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF4E8F4),
      appBar: AppBar(title: Text("Section 1")),
      body: Container(
          child: new Column(
        children: <Widget>[
          new Container(
            child: Text("List"),
          ),
          new Expanded(
            child: ListView.builder(
                //itemCount: products.length,
                itemCount: count,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                      child: ListTile(
                    onLongPress: () async {},
                    onTap: () async {
                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        //has net
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsRoute(id: this.items[index].id)),
                        );

                      } else{
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("not available offline")));
                      }
                    },
                    title: Text(items[index].id.toString()),
                    subtitle: Text(items[index].name + ", " + items[index].group + ", " + items[index].type),
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
      )),
      floatingActionButton: Builder(
        builder: (context1) => FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).push(
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
      pr = new ProgressDialog(
        _scaffoldKey.currentContext,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true,
      );
      pr.style(message: "Getting data");
      await pr.show();

      List<Item> productsList = await networkApi.getItems();
      // List<Item> productsList = List<Item>();

      setState(() {
        this.items = productsList;
        this.count = productsList.length;
        print("count from server " + this.count.toString());
      });

      await pr.hide();
      if (pr.isShowing()) {
        await pr.hide();
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("you re offline")));
      pr = new ProgressDialog(
        _scaffoldKey.currentContext,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true,
      );
      pr.style(message: "Getting data");
      await pr.show();

      await databaseHelper.initializeDatabase();
      List<Item> productsList = await databaseHelper.getProductList();
      // productsList.sort((a, b) {
      //   int cmp = a.group.compareTo(b.group);
      //   if (cmp != 0) return cmp;
      //   return a.name.compareTo(b.name);
      // });

      setState(() {
        this.items = productsList;
        this.count = productsList.length;
        print("count from db " + this.count.toString());
      });

      await pr.hide();
      if (pr.isShowing()) {
        await pr.hide();
      }
    }
  }
}
