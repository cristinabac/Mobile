import 'package:flutter_app/model/item.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';


class DatabaseHelper {
  var logger = Logger();

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String itemsTable = 'items_table';
  String colIdLocal = 'local_id';
  String colId = 'id';
  String colSpecs = 'specs';
  String colHeight = 'height';
  String colType = 'type';
  String colAge = 'age';
  String colName = 'name';

  String itemsTableOffline = 'items_table2';

  String dbName = 'ab4.db';


  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $itemsTable($colIdLocal INTEGER PRIMARY KEY AUTOINCREMENT, $colId INTEGER, $colName TEXT, $colSpecs TEXT, $colHeight INTEGER, $colType TEXT, $colAge INTEGER);');
    print("DONE CREATING DB");
    await db.execute('CREATE TABLE $itemsTableOffline($colIdLocal INTEGER PRIMARY KEY AUTOINCREMENT, $colId INTEGER, $colName TEXT, $colSpecs TEXT, $colHeight INTEGER, $colType TEXT, $colAge INTEGER)');
  }

  // Insert Operation: Insert a product object to database
  Future<int> insertItem(Item item) async {
    // logger.i("entered insertItem");
    print("entered insertItem - item: " + item.toString());
    Database db = await this.database;
    var result = await db.insert(itemsTable, item.toMap());
    // logger.i("done insertItem - res: " + result.toString());
    print("done insertItem");
    return result;
  }


  // Update Operation: Update a product object and save it to database
  Future<int> updateProduct(Item item) async {
    var db = await this.database;
    var result = await db.update(itemsTable, item.toMap(), where: '$colId = ?', whereArgs: [item.id]);
    return result;
  }

  // Delete Operation: Delete a product object from database
  Future<int> deleteProduct(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $itemsTable WHERE $colId = $id');
    return result;
  }

  // Get number of product objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $itemsTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> getProductMapList() async {
    Database db = await this.database;
    var result = await db.query(itemsTable);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'book List' [ List<Book> ]
  Future<List<Item>> getProductList() async {
    var productMapList = await getProductMapList(); // Get 'Map List' from database
    int count = productMapList.length;         // Count the number of map entries in db table
    List<Item> productList = List<Item>();
    for (int i = 0; i < count; i++) {
      productList.add(Item.fromMapObject(productMapList[i]));
    }
    return productList;
  }

  //additional offline table

  // Insert Operation: Insert a product object to database - added offline
  Future<int> insertItemOffline(Item item) async {
    print("entered insertItemOffline - item: " + item.toString());
    Database db = await this.database;
    var result = await db.insert(itemsTableOffline, item.toMap());
    print("done insertItemOffline");
    return result;
  }

  Future<List<Map<String, dynamic>>> getProductMapListOffline() async {
    Database db = await this.database;
    var result = await db.query(itemsTableOffline);
    return result;
  }

  Future<List<Item>> getProductListOffline() async {
    var productMapList = await getProductMapListOffline(); // Get 'Map List' from database
    int count = productMapList.length;         // Count the number of map entries in db table
    List<Item> productList = List<Item>();
    for (int i = 0; i < count; i++) {
      productList.add(Item.fromMapObject(productMapList[i]));
    }
    return productList;
  }

  Future<int> deleteAllOffline() async {
    // logger.i("entered deleteAll");
    print("entered deleteAllOffline");
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $itemsTableOffline');
    // logger.i("done deleteAll - res: " + result.toString());
    print("done deleteAllOffline");
    return result;
  }

  Future<int> deleteAll() async {
    // logger.i("entered deleteAll");
    print("entered deleteAll");
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $itemsTable');
    // logger.i("done deleteAll - res: " + result.toString());
    print("done deleteAll");
    return result;
  }



  // basic stuff, creation of db and tables etc

  DatabaseHelper._createInstance(){} // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    // Directory directory = await getApplicationDocumentsDirectory();
    // String path = directory.path + this.dbName;
    // print(path);
    // deleteDatabase(path);  // In case you change some fields

    String dbPath = await getDatabasesPath();

    // Open/create the database at a given path
    var productsDatabase = await openDatabase(join(dbPath, dbName), version: 1, onCreate: _createDb);

    return productsDatabase;
  }




}