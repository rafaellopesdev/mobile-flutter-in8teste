import 'dart:convert';

class Order {
    final List<ProductOrderItem> productsIds;
    final String phone;
    final String street;
    final int number;
    final String neighborhood;
    final String zipCode;
    final String city;
    final String state;
    final String stateName;
    final String observation;
    final double total;

    Order({
        required this.productsIds,
        required this.phone,
        required this.street,
        required this.number,
        required this.neighborhood,
        required this.zipCode,
        required this.city,
        required this.state,
        required this.stateName,
        required this.observation,
        required this.total,
        
    });

    String toJson() => json.encode(toMap());

    Map<String, dynamic> toMap() => {
        "productsIds": List<dynamic>.from(productsIds.map((x) => x.toMap())),
        "phone": int.parse(phone.replaceAll(RegExp(r'\D'), '')),
        "street": street,
        "number": number,
        "neighborhood": neighborhood,
        "zipCode": zipCode,
        "city": city,
        "state": state,
        "stateName": stateName,
        "observation": observation,
        "total": total,
    };
}

class ProductOrderItem {
    final int id;
    final int quantity;

    ProductOrderItem({required this.id, required this.quantity});

    Map<String, dynamic> toMap() => {
        "id": id,
        "quantity": quantity,
    };
}