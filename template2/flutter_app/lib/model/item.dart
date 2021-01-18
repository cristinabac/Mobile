
class Item{
  int local_id;
  int id;
  String name;
  int group;
  int year;
  String status;
  int credits;

  Item({this.local_id,this.id, this.name, this.group, this.year, this.status, this.credits});

  Map<String, dynamic> toMap() {
    return {
      'local_id': local_id,
      'id': id,
      'name': name,
      'group': group,
      'year': year,
      'status': status,
      'credits': credits
    };
  }

  Item.fromMapObject(Map<String, dynamic> map) {
    this.local_id = map['local_id'];
    this.id = map['id'];
    this.name = map['name'];
    this.group = map['group'];
    this.year = map['year'];
    this.status = map['status'];
    this.credits = map['credits'];
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        local_id: json['local_id'],
        id: json['id'],
        name: json['name'],
        group: json['group'],
        year: json['year'],
        status: json['status'],
        credits: json['credits']
    );
  }

  // Implement toString to make it easier to see information about
  // each product when using the print statement.
  @override
  String toString() {
    return 'Item{local id: $local_id, id: $id, name: $name, group: $group, year: $year, status: $status, credits: $credits}';
  }
}