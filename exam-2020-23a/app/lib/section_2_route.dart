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

class Section2Route extends StatefulWidget {
  Section2Route();

  @override
  State<StatefulWidget> createState() {
    return Section2RouteState();
  }
}

class Section2RouteState extends State<Section2Route> {


  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //cand dam click pe un elem din prima lista, in a doua lista vor
  //aparea cele cu titlul mai lung (doar un exemplu....)
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


  DatabaseHelper databaseHelper = DatabaseHelper();

  NetworkApi networkApi = NetworkApi();

  List<Item> items;
  int count = 0;

  List<Item> items2;
  int count2 = 0;

  Section2RouteState() {}

  @override
  Widget build(BuildContext context1) {
    if (items == null || items2 == null) {
      items = List<Item>();
      items2 = List<Item>();
      updateListView();
    }

    return Scaffold(
        backgroundColor: Color(0xFFF4E8F4),
        appBar: AppBar(title: Text("Section 2")),
        body: Container(
            child: new Column(
              children: <Widget>[
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
                              onTap: () {
                                itemTapped(items[index]);
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
                  child: Text("List 2"),
                ),
                new Expanded(
                  child: ListView.builder(
                    //itemCount: products.length,
                      itemCount: count2,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                            child: ListTile(
                              title: Text(items2[index].tablee),
                              subtitle: Text(items2[index].details +
                                  "\n" +
                                  items2[index].id.toString() +
                                  "\n" +
                                  items2[index].local_id.toString()),
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                              ),
                            ));
                      }),
                ),
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

  Future<void> itemTapped(Item item) async {
    print("item " + item.toString() + " tapped");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //has net
      Future<List<Item>> itemsListFuture = networkApi.getItems();
      // Navigator.pop(context);
      itemsListFuture.then((productsList) {
        setState(() {
          List<Item> lst = List<Item>();
          for(int i=0; i<productsList.length; i++)
            if(productsList[i].tablee.length > item.tablee.length)
              lst.add(productsList[i]);
          this.items2 = lst;
          this.count2 = lst.length;
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
            List<Item> lst = List<Item>();
            for(int i=0; i<productsList.length; i++)
              if(productsList[i].tablee.length > item.tablee.length)
                lst.add(productsList[i]);
            this.items2 = lst;
            this.count2 = lst.length;
            print("count from db " + this.count.toString());
            // print(this.items.toString());
          });
        });
      });
    }
  }
}
