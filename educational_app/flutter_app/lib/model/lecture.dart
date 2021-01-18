
class Lecture{
  int id;
  String name;

  Lecture({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Lecture.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
        id: json['id'],
        name: json['name'],
    );
  }

  // Implement toString to make it easier to see information about
  // each product when using the print statement.
  @override
  String toString() {
    return 'Lecture{ id: $id, name: $name}';
  }
}