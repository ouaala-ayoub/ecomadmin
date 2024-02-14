import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomadmin/models/core/order.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/views/image_error.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatelessWidget {
  //todo
  final Order order;
  const OrderWidget({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            orderHeader(),
            const SizedBox(
              height: 5,
            ),
            orderBody(),
            const SizedBox(
              height: 5,
            ),
            orderSource()
          ],
        ),
      ),
    );
  }

  Column orderSource() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Commande de la part de :',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InfoWidget(keey: 'Nom: ', value: order.name),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InfoWidget(
            keey: 'Numero du téléphone: ',
            value: order.phoneNumber,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InfoWidget(keey: 'Adresse: ', value: order.address),
        ),
      ],
    );
  }

  Row orderBody() {
    return Row(
      children: [
        CachedNetworkImage(
          fit: BoxFit.fitWidth,
          height: 100,
          width: 100,
          imageUrl: order.product!.images[0],
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              SizedBox(
            height: 200,
            child: Center(
                child: CircularProgressIndicator(
                    value: downloadProgress.progress)),
          ),
          errorWidget: (context, url, error) => const ImageError(
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      order.product!.title!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      order.product!.category ?? '-',
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatPrice(order.product!.price),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('x${order.quantity}')
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Row orderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('id:${order.id}'),
        Text(
          order.status!,
          style: TextStyle(
            color: order.status! == 'Completed' ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.keey,
    required this.value,
  });

  final String? keey;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(text: keey),
          TextSpan(
              text: value, style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
