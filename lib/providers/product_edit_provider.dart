import 'package:dartz/dartz.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/category.dart';
import 'package:ecomadmin/models/core/product.dart';
import 'package:ecomadmin/models/helpers/images_uploader.dart';
import 'package:ecomadmin/models/helpers/model_helper.dart';
import 'package:ecomadmin/providers/model_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductEditProvider extends ModelPageProvider {
  ProductEditProvider({required super.helper});

  final GlobalKey<FormState> key = GlobalKey();
  late Either<dynamic, List<Category>> categories;
  late Either<dynamic, List<String>> subcategories = const Right([]);
  bool categoriesLoading = true;

  final Map<String, dynamic> _body = {
    'title': TextEditingController(),
    'price': TextEditingController(),
    "images": <dynamic>[],
    'category': null,
    'subcategory': null,
    'description': TextEditingController()
  };

  Map<String, dynamic> get body => _body;

  @override
  fetshModelById(String id) async {
    await super.fetshModelById(id);
    super
        .model
        .fold((l) => null, (product) async => await initialiseData(product));
  }

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

  @override
  Future<Map<String, dynamic>> processData() async {
    final files = (body['images'] as List<dynamic>).whereType<XFile>().toList();
    final oldImages =
        (body['images'] as List<dynamic>).whereType<String>().toList();

    final images = await ImagesUploader.uploadImages(files);
    return images.fold((e) => {}, (newImages) {
      newImages.addAll(oldImages);
      logger.i(newImages);
      return {
        'title': body['title'].text,
        'price': body['price'].text,
        'images': newImages,
        'category': body['category']!.title,
        'subcategory': body['subcategory'],
        'description': body['description'].text
      };
    });
  }

  void removeFile(dynamic images) {
    body['images'].remove(images);
    notifyListeners();
  }

  fetshCategories({Function(List<Category>)? onSuccess}) async {
    final res = await ModelHelper(
      route: 'categories',
      converterMethod: (res) => Category.fromMap(res),
    ).fetshAll();
    categories = res.fold(
      (l) => Left(l),
      (res) {
        final list = res.map((c) => c as Category).toList();

        return Right(list);
      },
    );
    categories.fold((l) => null, (categories) => onSuccess?.call(categories));

    categoriesLoading = false;
    notifyListeners();
  }

  initialiseData(Product product) async {
    logger.d('inited data $product');
    body['title'] = TextEditingController(text: product.title);
    body['price'] = TextEditingController(text: product.price.toString());
    body['images'] = product.images;
    body['description'] = TextEditingController(text: product.description);
    await fetshCategories(onSuccess: (categories) {
      final indexCat =
          categories.indexWhere((element) => element.title == product.category);
      if (indexCat != -1) {
        body['category'] = categories[indexCat];
        getSubcategories(categories[indexCat]);
        final index = categories[indexCat]
            .subcategories!
            .indexWhere((element) => element == product.subcategory);

        if (index != -1) {
          body['subcategory'] = categories[indexCat].subcategories![index];
        }
      } else {
        body['category'] = null;
        body['subcategory'] = null;
      }
    });
  }
}
