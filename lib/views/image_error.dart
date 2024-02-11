import 'package:flutter/material.dart';

class ImageError extends StatelessWidget {
  const ImageError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(
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
