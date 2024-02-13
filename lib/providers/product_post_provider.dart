import 'package:dartz/dartz.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/category.dart';
import 'package:ecomadmin/models/helpers/model_helper.dart';
import 'package:ecomadmin/providers/model_post_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductPostProvider extends ModelPostProvider {
  ProductPostProvider({required super.helper});

  late Either<dynamic, List<Category>> categories;
  bool categoriesLoading = true;

  final Map<String, dynamic> _body = {
    'title': TextEditingController(),
    'price': TextEditingController(),
    "images": <XFile>[],
    'category': null,
    'subcategory': null,
    'description': TextEditingController()
  };

  @override
  Map<String, dynamic> get body => _body;

  addImages(List<XFile> images) {
    body['images'].addAll(images);
    notifyListeners();
  }

  setField(String key, dynamic value) {
    logger.i(value);
    body[key] = value;
    notifyListeners();
  }

  //todo images upload
  @override
  Map<String, dynamic> processData() => {
        'title': body['title'].text,
        'price': body['price'].text,
        'images': [],
      };

  void removeFile(XFile file) {
    body['images'].remove(file);
    notifyListeners();
  }

  fetshCategories() async {
    final res = await ModelHelper(
      route: 'categories',
      converterMethod: (res) => Category.fromMap(res),
    ).fetshAll();
    categories = res.fold(
      (l) => Left(l),
      (res) => Right(
        res.map((c) => c as Category).toList(),
      ),
    );
    categoriesLoading = false;
    notifyListeners();
  }
}
