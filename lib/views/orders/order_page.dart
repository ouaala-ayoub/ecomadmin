import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/order.dart';
import 'package:ecomadmin/providers/order_page_provider.dart';
import 'package:ecomadmin/views/orders/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderPage extends StatefulWidget {
  final Order order;
  final OrderPageProvider provider;
  const OrderPage({required this.order, required this.provider, super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.pop(widget.provider.body['status'] != widget.order.status);
      },
      child: ListView(
        children: [
          OrderWidget(
            order: widget.order,
            canUpdate: true,
            status: widget.provider.body['status'],
            onChanged: (value) {
              widget.provider.setStatus(value!);
              widget.provider.updateModel(widget.order.id!, onFail: (e) {
                logger.e(e);
              }, onSuccess: (res) {
                logger.i(res);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: orderSource(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const Text(
                'Commandée le :',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Text(widget.order.createdAt.toString())
            ]),
          )
        ],
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
          child: InfoWidget(keey: 'Nom: ', value: widget.order.name),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InfoWidget(
            keey: 'Numero du téléphone: ',
            value: widget.order.phoneNumber,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InfoWidget(keey: 'Adresse: ', value: widget.order.address),
        ),
      ],
    );
  }
}
