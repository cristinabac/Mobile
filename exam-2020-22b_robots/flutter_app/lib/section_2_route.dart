import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'edit_route_2.dart';
import 'model/item.dart';
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

  List<Item> items;
  int count = 0;

  Section2RouteState() {}

  @override
  Widget build(BuildContext context1) {
    if (items == null) {
      items = List<Item>();
      count = 0;
      updateListView();
    }

    return Scaffold(
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Age Section")),
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
                              },
                              onTap: () async {
                                var connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.mobile ||
                                    connectivityResult == ConnectivityResult.wifi) {
                                  print("go to edit" + this.items[index].specs);
                                  final result = await Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                        builder: (context) => EditRoute2(item: this.items[index])),
                                  );
                                  updateListView();
                                }else{
                                  await _showMaterialDialog("Update not available");
                                }
                              },
                              title: Text(items[index].name),
                              subtitle: Text(
                                  items[index].specs +
                                  "\n" +
                                  items[index].age.toString()),
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                              ),
                            ));
                      }),
                ),

              ],
            )));
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
      Future<List<Item>> itemsListFuture = networkApi.getItemsOld();
      itemsListFuture.then((productsList) {
        productsList.sort((a,b) => b.age.compareTo(a.age));
        print(productsList);
        print(productsList.length);
        List<Item> res = List<Item>();
        for(int i=0; i<productsList.length; i++) {
          if (i >= 10)
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
          // print(this.items.toString());
        });
      });
    } else {}
  }
}
