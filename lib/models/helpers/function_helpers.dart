import 'package:flutter/material.dart';
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
