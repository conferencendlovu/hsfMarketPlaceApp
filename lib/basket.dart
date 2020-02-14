// To parse this JSON data, do
//
//     final basket = basketFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

List<Basket> basketFromJson(String str) => List<Basket>.from(json.decode(str).map((x) => Basket.fromJson(x)));

String basketToJson(List<Basket> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Basket {
    String id;
    String name;
    String image;
    String cost;
    String category;
    String description;
    String stock;

    Basket({
        this.id,
        this.name,
        this.image,
        this.cost,
        this.category,
        this.description,
        this.stock,
    });

    factory Basket.fromJson(Map<String, dynamic> json) => Basket(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        cost: json["cost"],
        category: json["category"],
        description: json["description"],
        stock: json["stock"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "cost": cost,
        "category": category,
        "description": description,
        "stock": stock,
    };
}