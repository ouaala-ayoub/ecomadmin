import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  const ErrorPage({required this.message, super.key});

  //todo refresh button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SelectableText(message, style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
