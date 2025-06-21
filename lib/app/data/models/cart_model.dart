import 'product.dart';

class Cart {
  final int userId;
  final List<CartItem> items;

  Cart({required this.userId, required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<CartItem> cartItems = itemsList.map((i) => CartItem.fromJson(i)).toList();
    return Cart(
      userId: json['userId'],
      items: cartItems,
    );
  }
}

class CartItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final bool hasDiscount;
  final List<String> gallery;
  final String discountValue;
  final Details details;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int quantity;

  CartItem({
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
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: (json["price"] as num).toDouble(),
        hasDiscount: json["hasDiscount"],
        gallery: List<String>.from(json["gallery"].map((x) => x)),
        discountValue: json["discountValue"],
        details: Details.fromJson(json["details"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
        quantity: json["quantity"],
      );
}