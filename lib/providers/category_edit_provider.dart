import 'package:ecomadmin/models/core/category.dart';
import 'package:ecomadmin/providers/model_page_provider.dart';
import 'package:flutter/material.dart';

class CategoryEditProvider extends ModelPageProvider {
  CategoryEditProvider({required super.helper});
  bool firstTime = true;
  Map<String, dynamic> body = {};

  @override
  fetshModelById(String id) async {
    await super.fetshModelById(id);
    super.model.fold((l) => null, (category) => initiStatus(category));
    firstTime = false;
  }

  initiStatus(Category category) {
    body = {
      'title': TextEditingController(text: category.title),
      'subcategories': category.subcategories!
          .map(
            (subcategory) => TextEditingController(text: subcategory),
          )
          .toList()
    };
  }

  addSubcategory() {
    body['subcategories'].add(TextEditingController());
    notifyListeners();
  }

  removeSubcategoryAtIndex(int index) {
    body['subcategories'].removeAt(index);
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
