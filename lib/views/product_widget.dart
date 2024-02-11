import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomadmin/models/core/product.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:flutter/material.dart';

import 'image_error.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  const ProductWidget({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.images.isNotEmpty ? product.images[0] : '';
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          CachedNetworkImage(
            fit: BoxFit.fitWidth,
            height: 200,
            imageUrl: imageUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(
              height: 200,
              child: Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress)),
            ),
            errorWidget: (context, url, error) => const ImageError(),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(
              product.title ?? '-',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(
              formatPrice(product.price),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
