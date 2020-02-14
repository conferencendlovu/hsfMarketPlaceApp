class Category {
  final String title;
  final String id;

  Category._({this.title, this.id});

  factory Category.fromJson(Map<String, dynamic> json) {
    return new Category._(
      id: json['id'],
      title: json['name'],
    );
  }
}