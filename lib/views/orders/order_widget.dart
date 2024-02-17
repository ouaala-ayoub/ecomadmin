import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/order.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/views/image_error.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class OrderWidget extends StatelessWidget {
  //todo
  final Order order;
  final bool canUpdate;
  final String? status;
  final Function(String?)? onChanged;
  const OrderWidget(
      {this.status,
      this.canUpdate = false,
      required this.order,
      super.key,
      this.onChanged});

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
            // orderSource()
          ],
        ),
      ),
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
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      order.product!.title!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      order.product!.category ?? '-',
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
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
    final isCompleted = order.status! == 'Completed';
    final icon = isCompleted ? Icons.check : Icons.timelapse;
    final color = isCompleted ? Colors.green : Colors.orange;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'id:${order.id}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        canUpdate
            ? Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: status,
                    items: const [
                      DropdownMenuItem(
                        value: 'Completed',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, color: Colors.green),
                            Text(
                              'Completed',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Pending',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timelapse, color: Colors.orange),
                            Text(
                              'Pending',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      logger.i(value);
                      onChanged?.call(value);
                    },
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: color,
                  ),
                  Text(
                    order.status!,
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                ],
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
