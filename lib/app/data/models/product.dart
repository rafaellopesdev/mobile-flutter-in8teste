class Product {
    final int id;
    final String name;
    final String description;
    final String price;
    final bool hasDiscount;
    final List<String> gallery;
    final String discountValue;
    final Details details;
    final DateTime updatedAt;
    final DateTime createdAt;

    Product({
        required this.id,
        required this.name,
        required this.description,
        required this.price,
        required this.hasDiscount,
        required this.gallery,
        required this.discountValue,
        required this.details,
        required this.updatedAt,
        required this.createdAt,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        hasDiscount: json["hasDiscount"],
        gallery: List<String>.from(json["gallery"].map((x) => x)),
        discountValue: json["discountValue"],
        details: Details.fromJson(json["details"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
    );
}

class Details {
    final String material;
    final String adjective;

    Details({
        required this.material,
        required this.adjective,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        material: json["material"],
        adjective: json["adjective"],
    );
}