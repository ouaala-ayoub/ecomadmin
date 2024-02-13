import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

errorFromStatusCode(int? code) {
  switch (code) {
    case 401:
      return "Nom d'utilsateur ou mot de passe incorrect";
    case 500:
      return 'Erreur Inattendue ';
    default:
      return null;
  }
}

Future showInformativeDialog(
    BuildContext context, String content, String title) {
  return showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
            title: Text(title),
            content: Text(content),
            actions: [
              FilledButton(
                onPressed: () => context.pop(),
                child: Text('OK'),
              )
            ],
          ));
}

Container searchField(
    {required Function(String) onChanged,
    required TextEditingController textFieldController}) {
  return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        controller: textFieldController,
        onChanged: (value) {
          onChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Chercher',
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 165, 161, 161), fontSize: 14),
          prefixIcon: const Padding(
              padding: EdgeInsets.all(12), child: Icon(Icons.search)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ));
}

String formatPrice(int? price) {
  // Using the Flutter's NumberFormat class for currency formatting
  final formatter = NumberFormat.currency(
    //todo dirham at the right
    customPattern: '#,##0.00 \u00A4',
    symbol: 'MAD', // You can customize the currency symbol
    decimalDigits: 0, // Specify the number of decimal places
  );

  // Format the price and return as a string
  return price != null ? formatter.format(price) : '-';
}

String createUniqueImageName({required String extension}) {
  final random = Random.secure();
  final now = DateTime.now().millisecondsSinceEpoch;
  final bytes =
      Uint8List.fromList(List.generate(6, (_) => random.nextInt(256)));
  final hex =
      bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  return '$now.$hex.$extension';
}

String getFileExtension(XFile xFile) {
  String path = xFile.path;
  int dotIndex = path.lastIndexOf('.');
  if (dotIndex != -1 && dotIndex < path.length - 1) {
    String extension = path.substring(dotIndex + 1);
    return extension;
  }
  return 'unknown';
}
