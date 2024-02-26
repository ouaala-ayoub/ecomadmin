import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomadmin/views/image_error.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageWidget extends StatelessWidget {
  final XFile file;
  final Function(XFile) onLongPress;
  const ImageWidget({
    super.key,
    required this.file,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => onLongPress(file),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Image.file(
          fit: BoxFit.contain,
          File(file.path),
          height: 200,
        ),
      ),
    );
  }
}

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final Function(String) onLongPress;
  const NetworkImageWidget(
      {required this.imageUrl, required this.onLongPress, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => onLongPress(imageUrl),
      child: CachedNetworkImage(
        fit: BoxFit.contain,
        height: 200,
        imageUrl: imageUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          height: 200,
          child: Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
        ),
        errorWidget: (context, url, error) => const ImageError(
          height: 200,
        ),
      ),
    );
  }
}
