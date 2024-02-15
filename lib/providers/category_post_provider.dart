import 'package:ecomadmin/providers/model_post_provider.dart';
import 'package:flutter/material.dart';

class CategoryPostProvider extends ModelPostProvider {
  CategoryPostProvider({required super.helper});

  final Map<String, dynamic> _body = {
    'title': TextEditingController(),
    'subcategories': <TextEditingController>[TextEditingController()]
  };

  @override
  Map<String, dynamic> get body => _body;

  addSubcategory() {
    _body['subcategories'].add(TextEditingController());
    notifyListeners();
  }

  removeSubcategoryAtIndex(int index) {
    _body['subcategories'].removeAt(index);
    notifyListeners();
  }

  @override
  Future<Map<String, dynamic>> processData() async {
    return {
      'title': body['title'].text,
      'subcategories': (body['subcategories'] as List<TextEditingController>)
          .map((element) => element.text)
          .toList()
        ..removeWhere((element) => element.isEmpty),
    };
  }
}
