import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final Widget prefixIcon;
  final String label;
  final TextEditingController controller;
  final Function(String)? onChanged;
  const StyledTextField({
    this.onChanged,
    required this.prefixIcon,
    required this.controller,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        child: TextField(
          controller: controller,
          maxLines: 1,
          minLines: 1,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            label: Text(label),
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
          ),
        ));
  }
}
