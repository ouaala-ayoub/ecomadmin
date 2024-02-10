import 'dart:convert';

class Category {
  String? id;
  String? title;
  List<String>? subcategories;
  int? v;

  Category({this.id, this.title, this.subcategories, this.v});

  @override
  String toString() {
    return 'Category(id: $id, title: $title, subcategories: $subcategories, v: $v)';
  }

  factory Category.fromMap(Map<String, dynamic> data) => Category(
        id: data['_id'] as String?,
        title: data['title'] as String?,
        subcategories: (data['subcategories'] as List<dynamic>)
            .map((subcategory) => subcategory as String)
            .toList(),
        v: data['__v'] as int?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'title': title,
        'subcategories': subcategories,
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Category].
  factory Category.fromJson(String data) {
    return Category.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Category] to a JSON string.
  String toJson() => json.encode(toMap());
}
