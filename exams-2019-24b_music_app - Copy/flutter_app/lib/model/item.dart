
class Item{
  int local_id;
  int id;
  String title;
  String description;
  String album;
  String genre;
  int year;

  Item({this.local_id,this.id, this.title, this.description, this.album, this.genre, this.year});

  Map<String, dynamic> toMap() {
    return {
      'local_id': local_id,
      'id': id,
      'title': title,
      'description': description,
      'album': album,
      'genre': genre,
      'year': year
    };
  }

  Item.fromMapObject(Map<String, dynamic> map) {
    this.local_id = map['local_id'];
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.album = map['album'];
    this.genre = map['genre'];
    this.year = map['year'];
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        local_id: json['local_id'],
        id: json['id'],
        title: json['title'],
        description: json['description'],
        album: json['album'],
        genre: json['genre'],
        year: json['year']
    );
  }

  // Implement toString to make it easier to see information about
  // each product when using the print statement.
  @override
  String toString() {
    return 'Item{local id: $local_id, id: $id, title: $title}';
  }
}