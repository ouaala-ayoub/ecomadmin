import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/providers/category_edit_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryEditPage extends StatelessWidget {
  final CategoryEditProvider provider;
  final BuildContext modelPostContext;
  static bool changed = false;
  final String id;

  const CategoryEditPage(
      {required this.modelPostContext,
      required this.id,
      required this.provider,
      super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.pop(changed);
      },
      child: Column(
        children: [
          Expanded(
            child: ListView(
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
                                  controller: provider.body['subcategories']
                                      [index],
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
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  provider.updateModel(id, onFail: (e) {
                    logger.e(e);
                    showInformativeDialog(
                      context,
                      'Erreur innatendue , réessayer',
                      'erreur',
                    );
                  }, onSuccess: (res) {
                    logger.i(res);
                    const snackBar = SnackBar(
                      content: Text('Informations mise a jour avec success'),
                    );
                    ScaffoldMessenger.of(modelPostContext)
                        .showSnackBar(snackBar);
                    changed = true;
                  });
                },
                child: const Text('Modifier les informations'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
