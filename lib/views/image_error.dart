import 'package:flutter/material.dart';

class ImageError extends StatelessWidget {
  final double? height;
  final double? width;
  const ImageError({
    this.height,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          Text('Error loading image'),
        ]),
      ),
    );
  }
}
