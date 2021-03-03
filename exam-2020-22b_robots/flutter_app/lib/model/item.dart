
class Item{
  int local_id;
  int id;
  String name;
  String specs;
  int height;
  String type;
  int age;

  Item({this.local_id,this.id, this.name, this.specs, this.height, this.type, this.age});

  Map<String, dynamic> toMap() {
    return {
      'local_id': local_id,
      'id': id,
      'name': name,
      'specs': specs,
      'height': height,
      'type': type,
      'age': age
    };
  }

  Item.fromMapObject(Map<String, dynamic> map) {
    this.local_id = map['local_id'];
    this.id = map['id'];
    this.name = map['name'];
    this.specs = map['specs'];
    this.height = map['height'];
    this.type = map['type'];
    this.age = map['age'];
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        local_id: json['local_id'],
        id: json['id'],
        name: json['name'],
        specs: json['specs'],
        height: json['height'],
        type: json['type'],
        age: json['age']
    );
  }

  // Implement toString to make it easier to see information about
  // each product when using the print statement.
  @override
  String toString() {
    return 'Item{local id: $local_id, id: $id, name: $name, specs: $specs, height: $height, type: $type, age: $age}';
  }
}