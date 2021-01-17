// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'model/item.dart';
// import 'utils/database_util.dart';
//
// import 'dart:io';
//
// import 'dart:developer' as developer;
//
// import 'utils/network_util.dart';
// import 'package:progress_dialog/progress_dialog.dart';
//
// class EditRoute extends StatefulWidget {
//   Item item;
//   EditRoute({this.item});
//
//   @override
//   State<StatefulWidget> createState() {
//     return EditRouteState(this.item);
//   }
// }
//
// class EditRouteState extends State<EditRoute> {
//   Item item;
//
//   DatabaseHelper databaseHelper = DatabaseHelper();
//
//   NetworkApi networkApi = NetworkApi();
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController groupController = TextEditingController();
//   TextEditingController yearController = TextEditingController();
//   TextEditingController statusController = TextEditingController();
//   TextEditingController creditsController = TextEditingController();
//
//   EditRouteState(Item item) {
//     this.item = item;
//      nameController = TextEditingController(text: item.sender);
//      groupController = TextEditingController(text: item.date.toString());
//      yearController = TextEditingController(text: item.year.toString());
//      statusController = TextEditingController(text: item.receiver);
//      creditsController = TextEditingController(text: item.credits.toString());
//   }
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   ProgressDialog pr;
//
//   @override
//   Widget build(BuildContext context1) {
//     return Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: Color(0xFFF4E8F4),
//         appBar: AppBar(title: Text("Edit Item")),
//         body: Container(
//             child: new Column(
//               children: <Widget>[
//                 new Container(
//                     child: TextField(
//                       controller: nameController,
//                       decoration: InputDecoration(labelText: 'name'),
//                     )),
//                 new Container(
//                     child: TextField(
//                       controller: groupController,
//                       decoration: InputDecoration(labelText: 'group'),
//                     )),
//                 new Container(
//                     child: TextField(
//                       controller: yearController,
//                       decoration: InputDecoration(labelText: 'year'),
//                     )),
//                 new Container(
//                     child: TextField(
//                       controller: statusController,
//                       decoration: InputDecoration(labelText: 'status'),
//                     )),
//                 new Container(
//                     child: TextField(
//                       controller: creditsController,
//                       decoration: InputDecoration(labelText: 'credits'),
//                     )),
//                 new Container(
//                   child: RaisedButton(
//                     child: Text("Update"),
//                     onPressed: () async {
//                       return await showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text("Confirm?"),
//                               content:
//                               Text("Are you sure you want to update this item?"),
//                               actions: <Widget>[
//                                 FlatButton(
//                                   child: Text("Cancel"),
//                                   onPressed: () => Navigator.pop(context),
//                                 ),
//                                 FlatButton(
//                                     child: Text("Yes!"),
//                                     onPressed: () async {
//                                       item.sender = nameController.text;
//                                       item.date = int.parse(groupController.text);
//                                       // item.year = int.parse(yearController.text);
//                                       item.receiver = statusController.text;
//                                       // item.credits = int.parse(creditsController.text);
//                                       await _update(context1, item);
//                                       Navigator.pop(context);
//                                       Navigator.pop(context, item);
//                                     })
//                               ],
//                             );
//                           });
//                     },
//                   ),
//                 ),
//                 new Container(
//                   child: RaisedButton(
//                     child: Text("Delete"),
//                     onPressed: () async {
//                       return await showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text("Confirm?"),
//                               content:
//                               Text("Are you sure you want to update this item?"),
//                               actions: <Widget>[
//                                 FlatButton(
//                                   child: Text("Cancel"),
//                                   onPressed: () => Navigator.pop(context),
//                                 ),
//                                 FlatButton(
//                                     child: Text("Yes!"),
//                                     onPressed: () async {
//                                       await _delete(context1, item.id);
//                                       Navigator.pop(context);
//                                       Navigator.pop(context, item);
//                                     })
//                               ],
//                             );
//                           });
//                     },
//                   ),
//                 ),
//               ],
//             )));
//   }
//
//   Future<void> _update(BuildContext context, Item item) async {
//     pr = new ProgressDialog(
//       _scaffoldKey.currentContext,
//       type: ProgressDialogType.Normal,
//       isDismissible: false,
//       showLogs: true,
//     );
//     pr.style(message: "Updating");
//     await pr.show();
//     Item result = await networkApi.updateItem(item);
//     await pr.hide();
//     if(pr.isShowing())
//       await pr.hide();
//
//     if(result != null) {
//       await _showMaterialDialog("updated successfully");
//     } else{
//       await _showMaterialDialog("update failed");
//     }
//   }
//
//   Future<void> _showMaterialDialog(String text) async {
//     await showDialog(
//         context: context,
//         builder: (_) => new AlertDialog(
//           title: new Text(text),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('OK!'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         ));
//   }
//
//   Future<void> _delete(BuildContext context1, int id) async {
//     pr = new ProgressDialog(
//       _scaffoldKey.currentContext,
//       type: ProgressDialogType.Normal,
//       isDismissible: false,
//       showLogs: true,
//     );
//     pr.style(message: "Deleting");
//     await pr.show();
//
//     int result = await networkApi.deleteItem(id);
//
//     await pr.hide();
//     if(pr.isShowing())
//       await pr.hide();
//
//     if(result != -1) {
//       await _showMaterialDialog("deleted successfully");
//     } else{
//       await _showMaterialDialog("delete failed");
//     }
//   }
// }
