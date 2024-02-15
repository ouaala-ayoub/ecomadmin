import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/providers/category_post_provider.dart';
import 'package:flutter/material.dart';

class CategoryPostPage extends StatelessWidget {
  final CategoryPostProvider provider;

  const CategoryPostPage({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 10, right: 10),
      children: [
        const SizedBox(
          height: 10,
        ),
        formTf(
          'Categorie',
          TextInputType.text,
          controller: provider.body['title'],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => provider.addSubcategory(),
            child: const Text('Ajouter une subcategorie'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        provider.body['subcategories'].isEmpty
            ? const Center(child: Text('Pas de subcategories'))
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: provider.body['subcategories'].length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Flexible(
                        child: formTf(
                          'Subcategorie',
                          TextInputType.text,
                          controller: provider.body['subcategories'][index],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (index != 0)
                        GestureDetector(
                          child: const Icon(
                            Icons.highlight_remove_outlined,
                            color: Colors.red,
                          ),
                          onTap: () {
                            provider.removeSubcategoryAtIndex(index);
                          },
                        )
                    ],
                  ),
                ),
              )
      ],
    );
  }
}
