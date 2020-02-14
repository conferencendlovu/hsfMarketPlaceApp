import 'dart:convert';

List<Users> usersFromJson(String str) => List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
    String id;
    int count;
    String email;

    Users({
        this.id,
        this.count,
        this.email,
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        count: json["count"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "count": count,
        "email": email,
    };
}
