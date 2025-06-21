import 'product.dart';

class ApiResponse {
    final List<Product> products;
    final Pagination pagination;

    ApiResponse({
        required this.products,
        required this.pagination,
    });

    factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );
}

class Pagination {
    final int currentPage;
    final int totalPages;
    final int totalProducts;
    final bool hasNextPage;
    final bool hasPrevPage;
    final int limit;

    Pagination({
        required this.currentPage,
        required this.totalPages,
        required this.totalProducts,
        required this.hasNextPage,
        required this.hasPrevPage,
        required this.limit,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: int.parse(json["currentPage"]),
        totalPages: json["totalPages"],
        totalProducts: json["totalProducts"],
        hasNextPage: json["hasNextPage"],
        hasPrevPage: json["hasPrevPage"],
        limit: int.parse(json["limit"]),
    );
}