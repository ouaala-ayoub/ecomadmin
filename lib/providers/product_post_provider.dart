import 'package:dartz/dartz.dart';
import 'package:ecomadmin/models/core/category.dart';
import 'package:ecomadmin/models/helpers/images_uploader.dart';
import 'package:ecomadmin/models/helpers/model_helper.dart';
import 'package:ecomadmin/providers/model_post_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductPostProvider extends ModelPostProvider {
  ProductPostProvider({required super.helper});

  late Either<dynamic, List<Category>> categories;
  late Either<dynamic, List<String>> subcategories = const Right([]);
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
    body[key] = value;
    if (key == "category") {
      getSubcategories(value as Category);
    }
    // logger.i("category body value is ${body[key]}");
    notifyListeners();
  }

  getSubcategories(Category? category) {
    subcategories = categories.fold(
      (l) => Left(l),
      (categories) => Right(
        categories
                .firstWhere(
                  (element) => element.id == category?.id,
                )
                .subcategories ??
            [],
      ),
    );
  }

  //todo images upload
  @override
  Future<Map<String, dynamic>> processData() async {
    final images = await ImagesUploader.uploadImages(body['images']);
    return images.fold(
        (e) => {},
        (images) => {
              'title': body['title'].text,
              'price': body['price'].text,
              'images': images,
              'category': body['category']!.title,
              'subcategory': body['subcategory'],
              'description': body['description'].text
            });
  }

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
