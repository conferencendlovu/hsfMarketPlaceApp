class WishNote {
  int id;
  int productId;
  String reminder;
  String note;

  WishNote(this.id, this.note, this.productId,this.reminder);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'note': note,
      'product_id' :productId,
      'reminder' : reminder
    };
    return map;
  }

  WishNote.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    note = map['note'];
    productId = map['product_id'];
    reminder = map['reminder'];
  }
}