class Photo {
  final String title;
  final String thumbnailUrl;
  final String id;
  final String description;
    final String image;

  Photo._({this.title, this.thumbnailUrl,this.id,this.description,this.image});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return new Photo._(
      id: json['id'],
      title: json['name'],
      thumbnailUrl: json['thumbnail'],
      image: json['image'],
      description: json['description']
    );
  }
}