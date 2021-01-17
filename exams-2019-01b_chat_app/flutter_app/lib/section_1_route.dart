import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'add_route.dart';
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

  List<String> users;
  int countUsers =0;

  List<Item> lst3;
  int count3 = 0;

  List<Item> lst4;
  int count4 = 0;

  var logger = Logger();
  var wbsoket;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ProgressDialog pr;

  Section1RouteState() {}

  @override
  void initState() {
    super.initState();
    wbsoket = IOWebSocketChannel.connect("ws://192.168.0.241:2101")
      ..stream.listen((message) {
        var item = Item.fromJson(jsonDecode(message));
        logger.i("websocket: item - " + item.toString());
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text("WebSocket: name-" + item.sender)));
      },
          onError: onError);
  }

  onError(err){
    developer.log("err web socket conn");
  }


  @override
  Widget build(BuildContext context1) {
    if (items == null || users == null || lst3 == null || lst4 == null) {
      items = List<Item>();
      users = List<String>();
      lst3 = List<Item>();
      lst4 = List<Item>();
      updateListView();
    }

    return Scaffold(
      key: _scaffoldKey,
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
                                          this.items[index].sender);
                                      Navigator.pop(context);
                                    })
                              ],
                            );
                          });
                    },
                    onTap: () async {
                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        // await Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           EditRoute(item: this.items[index])),
                        // );
                        // updateListView();
                      }else{
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text("not available offline")));
                      }
                    },
                    title: Text(items[index].sender),
                    subtitle: Text(items[index].receiver +
                        "\n" +
                        items[index].text +
                        "\n" +
                        items[index].date.toString() +
                        "\n" +
                        items[index].id.toString()),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                    ),
                  ));
                }),
          ),


          new Expanded(
            child: ListView.builder(
              //itemCount: products.length,
                itemCount: countUsers,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                      child: ListTile(
                        onLongPress: () async {
                        },
                        onTap: () async {
                          await userTapped(users[index]);
                        },
                        title: Text(users[index]),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                        ),
                      ));
                }),
          ),

          new Expanded(
            child: ListView.builder(
                itemCount: count3,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                      child: ListTile(
                        title: Text(lst3[index].sender + "\n" + lst3[index].receiver + "\n" + lst3[index].text + "\n" + lst3[index].id.toString()),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                        ),
                      ));
                }),
          ),

          new Expanded(
            child: ListView.builder(
                itemCount: count4,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                      child: ListTile(
                        title: Text(lst4[index].sender + "\n" + lst4[index].receiver + "\n" + lst4[index].text + "\n" + lst4[index].id.toString()),
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
      pr = new ProgressDialog(
        _scaffoldKey.currentContext,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true,
      );
      pr.style(message: "Getting data");
      await pr.show();

      List<Item> productsList = await networkApi.getPublic();
      productsList.sort((a, b) {
        return b.date.compareTo(a.date);
      });
      List<Item> res = List<Item>();
      for(int i=0; i<productsList.length; i++) {
        if (i >= 10)
          break;
        else {
          res.add(productsList[i]);
        }
      }
      productsList = res;


      List<String> usersList = await networkApi.getUsers();

      setState(() {
        this.items = productsList;
        this.count = productsList.length;
        print("count from server " + this.count.toString());

        this.users = usersList;
        this.countUsers = usersList.length;
      });

      await pr.hide();
      if (pr.isShowing()) {
        await pr.hide();
      }
    } else {
      // pr = new ProgressDialog(
      //   _scaffoldKey.currentContext,
      //   type: ProgressDialogType.Normal,
      //   isDismissible: false,
      //   showLogs: true,
      // );
      // pr.style(message: "Getting data");
      // await pr.show();
      //
      // await databaseHelper.initializeDatabase();
      // List<Item> productsList = await databaseHelper.getProductList();
      // productsList.sort((a, b) {
      //   int cmp = a.group.compareTo(b.group);
      //   if (cmp != 0) return cmp;
      //   return a.name.compareTo(b.name);
      // });
      //
      // setState(() {
      //   this.items = productsList;
      //   this.count = productsList.length;
      //   print("count from db " + this.count.toString());
      // });
      //
      // await pr.hide();
      // if (pr.isShowing()) {
      //   await pr.hide();
      // }
    }
  }

  Future<void> userTapped(String user) async{

    pr = new ProgressDialog(
      _scaffoldKey.currentContext,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
    pr.style(message: "Getting data");
    await pr.show();

    List<Item> lst = await networkApi.getSender(user);
    List<Item> lst_r = await networkApi.getReceiver(user);

    setState(() {
      this.lst3 = lst;
      this.count3 = lst.length;

      this.lst4 = lst_r;
      this.count4 = lst_r.length;
    });

    await pr.hide();
    if (pr.isShowing()) {
      await pr.hide();
    }
  }
}
