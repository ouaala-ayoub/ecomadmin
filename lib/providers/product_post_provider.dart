import 'package:ecomadmin/providers/model_post_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductPostProvider extends ModelPostProvider {
  ProductPostProvider({required super.helper});

  final Map<String, dynamic> _body = {
    'title': TextEditingController(),
    'price': TextEditingController(),
    "images": <XFile>[],
    'description': TextEditingController()
  };

  @override
  Map<String, dynamic> get body => _body;

  addImages(List<XFile> images) {
    body['images'].addAll(images);
    notifyListeners();
  }

  @override
  processData() {
    body['title'] = body['title'].text;
    body['price'] = body['price'].text;
    //body['images'] = await uploadImages(body['images']);
  }

  void removeFile(XFile file) {
    body['images'].remove(file);
    notifyListeners();
  }
}
