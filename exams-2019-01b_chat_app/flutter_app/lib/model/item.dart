
class Item{
  int local_id;
  int id;
  String sender;
  String receiver;
  String text;
  int date;
  String type;

  Item({this.local_id, this.id, this.sender, this.receiver, this.text, this.date, this.type});

  Map<String, dynamic> toMap() {
    return {
      'local_id': local_id,
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'text': text,
      'date': date,
      'type': type
    };
  }

  Item.fromMapObject(Map<String, dynamic> map) {
    this.local_id = map['local_id'];
    this.id = map['id'];
    this.sender = map['sender'];
    this.receiver = map['receiver'];
    this.text = map['text'];
    this.date = map['date'];
    this.type = map['type'];
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        local_id: json['local_id'],
        id: json['id'],
        sender: json['sender'],
        receiver: json['receiver'],
        text: json['text'],
        date: json['date'],
        type: json['type']
    );
  }

  // Implement toString to make it easier to see information about
  // each product when using the print statement.
  @override
  String toString() {
    return 'Item{local id: $local_id, id: $id, sender: $sender, receiver: $receiver, text $text}';
  }
}