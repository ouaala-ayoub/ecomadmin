import 'dart:io';
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
          File(file.path),
          height: 200,
        ),
      ),
    );
  }
}
