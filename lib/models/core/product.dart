import 'dart:convert';

class Product {
  String? id;
  String? title;
  int? price;
  List<dynamic> images;
  String? description;
  String? category;
  String? subcategory;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Product({
    this.id,
    this.title,
    this.price,
    required this.images,
    this.description,
    this.category,
    this.subcategory,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, images: $images, description: $description, category: $category, subcategory: $subcategory, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Product.fromMap(Map<String, dynamic> data) => Product(
        id: data['_id'] as String?,
        title: data['title'] as String?,
        price: data['price'] as int?,
        images: data['images'] as List<dynamic>,
        description: data['description'] as String?,
        category: data['category'] as String?,
        subcategory: data['subcategory'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        v: data['__v'] as int?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'title': title,
        'price': price,
        'images': images,
        'description': description,
        'category': category,
        'subcategory': subcategory,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Product].
  factory Product.fromJson(String data) {
    return Product.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Product] to a JSON string.
  String toJson() => json.encode(toMap());
}
