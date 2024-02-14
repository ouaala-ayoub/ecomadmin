import 'dart:convert';

import 'package:ecomadmin/models/core/product.dart';

class Order {
  String? id;
  String? name;
  String? address;
  String? phoneNumber;
  int? quantity;
  String? status;
  Product? product;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Order({
    this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.quantity,
    this.status,
    this.product,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Order(id: $id, name: $name, address: $address, phoneNumber: $phoneNumber, quantity: $quantity, status: $status, product: $product, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Order.fromMap(Map<String, dynamic> data) => Order(
        id: data['_id'] as String?,
        name: data['name'] as String?,
        address: data['address'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        quantity: data['quantity'] as int?,
        status: data['status'] as String?,
        product: Product.fromMap(data['product']),
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
        'name': name,
        'address': address,
        'phoneNumber': phoneNumber,
        'quantity': quantity,
        'status': status,
        'product': product?.toMap(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Order].
  factory Order.fromJson(String data) {
    return Order.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Order] to a JSON string.
  String toJson() => json.encode(toMap());
}
