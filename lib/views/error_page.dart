import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  final Function() onRefresh;
  const ErrorPage({required this.message, required this.onRefresh, super.key});

  //todo refresh button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
              message,
              style: const TextStyle(color: Colors.red),
            ),
            FilledButton(
              onPressed: onRefresh,
              child: const Text('Refresh'),
            )
          ],
        ),
      ),
    );
  }
}
