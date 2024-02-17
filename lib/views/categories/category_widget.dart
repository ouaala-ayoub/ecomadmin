import 'package:ecomadmin/models/core/category.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('${category.title}'),
      children: [
        const ListTile(
          title: Text('Subcategories :'),
          textColor: Colors.red,
        ),
        ...category.subcategories!.map(
          (subcategory) => ListTile(
            title: Text(subcategory),
          ),
        )
      ],
    );
  }
}
