
class Item{
  int local_id;
  int id;
  String title;
  String date;

  Item({this.local_id,this.id,this.title, this.date});

  Map<String, dynamic> toMap() {
    return {
      'local_id': local_id,
      'id': id,
      'title': title,
      'date': date,
    };
  }

  Item.fromMapObject(Map<String, dynamic> map) {
    this.local_id = map['local_id'];
    this.id = map['id'];
    this.title = map['title'];
    this.date = map['date'];
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        local_id: json['local_id'],
        id: json['id'],
        title: json['title'],
        date: json['date']
    );
  }

  // Implement toString to make it easier to see information about
  // each product when using the print statement.
  @override
  String toString() {
    return 'Item{local id: $local_id, id: $id, name: $title, date: $date}';
  }
}