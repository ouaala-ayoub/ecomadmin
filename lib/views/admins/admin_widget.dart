import 'package:ecomadmin/models/core/admin.dart';
import 'package:flutter/material.dart';

class AdminWidget extends StatelessWidget {
  final Admin admin;
  const AdminWidget({required this.admin, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            alignedSpawnedText('username : ', admin.username),
            alignedSpawnedText('password : ', admin.password)
          ],
        ),
      ),
    );
  }

  Align alignedSpawnedText(start, end) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 18),
          children: [
            TextSpan(
                text: start,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: end),
          ],
        ),
      ),
    );
  }
}
