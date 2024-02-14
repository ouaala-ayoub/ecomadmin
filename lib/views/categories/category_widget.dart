import 'package:ecomadmin/models/core/category.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  final Category category;

  const CategoryWidget({required this.category, super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool shouldShow = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          shouldShow = !shouldShow;
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.category.title}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  shouldShow
                      ? const Icon(Icons.arrow_drop_up_rounded)
                      : const Icon(Icons.arrow_drop_down_rounded)
                ],
              ),
              if (shouldShow)
                Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Subcategories :',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.category.subcategories!.length,
                      itemBuilder: (context, index) => Text(
                        '-${widget.category.subcategories![index]}',
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
