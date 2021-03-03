
class Item{
  int local_id;
  int id;
  String table;
  String details;
  String status;
  int time;
  String type;

  Item({this.local_id,this.id,this.table, this.details, this.status, this.time, this.type});

  Map<String, dynamic> toMap() {
    return {
      'local_id': local_id,
      'id': id,
      'table': table,
      'details': details,
      'status': status,
      'time': time,
      'type': type
    };
  }

  Item.fromMapObject(Map<String, dynamic> map) {
    this.local_id = map['local_id'];
    this.id = map['id'];
    this.table = map['table'];
    this.details = map['details'];
    this.status = map['status'];
    this.time = map['time'];
    this.type = map['type'];
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        local_id: json['local_id'],
        id: json['id'],
        table: json['table'],
        details: json['details'],
        status: json['status'],
        time: json['time'],
        type: json['type']
    );
  }

  // Implement toString to make it easier to see information about
  // each product when using the print statement.
  @override
  String toString() {
    return 'Item{local id: $local_id, id: $id, table: $table, details: $details, status: $status, time: $time, type: $type}';
  }
}