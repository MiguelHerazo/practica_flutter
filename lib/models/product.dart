class Product {
  int? id;
  String title;
  String description;
  num price;
  String? brand;
  String? category;
  String? thumbnail;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    this.brand,
    this.category,
    this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        price: json['price'] ?? 0,
        brand: json['brand'],
        category: json['category'],
        thumbnail: json['thumbnail'],
      );

  Map<String, dynamic> toJson() {
    final map = {
      'title': title,
      'description': description,
      'price': price,
    };
    if (brand != null) map['brand'] = brand!;
    if (category != null) map['category'] = category!;
    if (thumbnail != null) map['thumbnail'] = thumbnail!;
    return map;
  }
}
