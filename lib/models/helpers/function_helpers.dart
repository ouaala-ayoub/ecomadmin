import 'package:flutter/material.dart';

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

Container searchField({required Function(String) onChanged}) {
  return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
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
