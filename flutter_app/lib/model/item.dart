
class Item{
  int local_id;
  int id;
  String name;
  String group;
  String details;
  String status;
  int students;
  String type;

  Item({this.local_id,this.id, this.name, this.group, this.details, this.status, this.students, this.type});

  Map<String, dynamic> toMap() {
    return {
      'local_id': local_id,
      'id': id,
      'name': name,
      'group': group,
      'details': details,
      'status': status,
      'students': students,
      'type': type
    };
  }

  Item.fromMapObject(Map<String, dynamic> map) {
    this.local_id = map['local_id'];
    this.id = map['id'];
    this.name = map['name'];
    this.group = map['group'];
    this.details = map['details'];
    this.status = map['status'];
    this.students = map['students'];
    this.type = map['type'];
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        local_id: json['local_id'],
        id: json['id'],
        name: json['name'],
        group: json['group'],
        details: json['details'],
        status: json['status'],
        students: json['students'],
        type: json['type']
    );
  }

  // Implement toString to make it easier to see information about
  // each product when using the print statement.
  @override
  String toString() {
    return 'Item{local id: $local_id, id: $id, name: $name, group: $group, details: $details, status: $status, students: $students, students: $students, type: $type}';
  }
}