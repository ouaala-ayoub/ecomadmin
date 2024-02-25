import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImagesUploader {
  static Future<Either<dynamic, List<String>>> uploadImages(
      List<XFile> images) async {
    // images.map((image) => logger.i(createUniqueImageName(extension: )));
    // final mapper = <String, String>{};
    final urls = <String>[];
    final firebaseRef = FirebaseStorage.instance.ref();
    for (var image in images) {
      try {
        final ext = getFileExtension(image);
        final fileName = createUniqueImageName(extension: ext);
        final metadata = SettableMetadata(
          contentType: 'image/$ext',
        );
        final uploadTask = await firebaseRef
            .child('products/$fileName')
            .putFile(File(image.path), metadata);
        final url = await uploadTask.ref.getDownloadURL();
        // mapper[url] = image.name;
        urls.add(url);
      } catch (e) {
        logger.e(e);
        return Left(e);
      }
    }
    return Right(urls);
  }
}
