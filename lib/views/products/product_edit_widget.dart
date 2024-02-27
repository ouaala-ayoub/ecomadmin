import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/category.dart';
import 'package:ecomadmin/models/core/product.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/providers/product_edit_provider.dart';
import 'package:ecomadmin/views/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProductEditWidget extends StatelessWidget {
  final BuildContext modelPageContext;
  final Product product;
  final ProductEditProvider provider;
  const ProductEditWidget(
      {required this.product,
      required this.provider,
      required this.modelPageContext,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Form(
            key: provider.key,
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  formTf('Entrez le Titre', TextInputType.text,
                      controller: provider.body['title']),
                  const SizedBox(
                    height: 15,
                  ),
                  formTf('Entrez le Prix', TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: provider.body['price']),
                  const SizedBox(
                    height: 10,
                  ),
                  FormField<dynamic>(
                    initialValue: provider.body['images'],
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      logger.d('images value $value');
                      return value?.isEmpty == true
                          ? 'Choisissez des images !'
                          : null;
                    },
                    builder: (state) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () async {
                              //todo do the images pick logic
                              final imagePicker = ImagePicker();
                              final images = await imagePicker.pickMultiImage();
                              provider.addImages(images);
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add),
                                Text('ajouter des images')
                              ],
                            ),
                          ),
                        ),
                        if (state.errorText != null)
                          Text(
                            state.errorText!,
                            style: const TextStyle(color: Colors.red),
                          )
                      ],
                    ),
                  ),
                  //to add images
                  const SizedBox(
                    height: 10,
                  ),
                  if (provider.body['images']
                      .whereType<XFile>()
                      .toList()
                      .isNotEmpty)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.body['images']
                          .whereType<XFile>()
                          .toList()
                          .length,
                      itemBuilder: (context, index) => ImageWidget(
                        file: provider.body['images']
                            .whereType<XFile>()
                            .toList()[index],
                        onLongPress: (file) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      provider.removeFile(file);
                                      context.pop();
                                    },
                                    child: const Text("Supprimer"))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  if (provider.body['images']
                      .whereType<String>()
                      .toList()
                      .isNotEmpty)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.body['images']
                          .whereType<String>()
                          .toList()
                          .length,
                      itemBuilder: (context, index) => NetworkImageWidget(
                        imageUrl: provider.body['images']
                            .whereType<String>()
                            .toList()[index],
                        onLongPress: (url) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    provider.removeFile(url);
                                    context.pop();
                                  },
                                  child: const Text("Supprimer"),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(
                    height: 15,
                  ),
                  FormField<Category?>(
                    initialValue: provider.body['category'],
                    validator: (value) {
                      logger.i('category value $value');
                      if (value == null) {
                        return 'Entrer une catégorie';
                      } else {
                        return null;
                      }
                    },
                    builder: (state) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        provider.categoriesLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : provider.categories.fold(
                                (l) => OutlinedButton(
                                    onPressed: () => provider.fetshCategories(),
                                    child: const Column(
                                      children: [
                                        Text(
                                            'Erreur de chargement des categories'),
                                        Text('refresh'),
                                      ],
                                    )),
                                (categories) =>
                                    DropdownButtonFormField<Category>(
                                  decoration: InputDecoration(
                                    label: const Text('Categories'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  value: provider.body['category'],
                                  items: categories
                                      .map(
                                        (c) => DropdownMenuItem<Category>(
                                          //!the value of category is id
                                          value: c,
                                          child: Text('${c.title}'),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    provider.setField('category', value);
                                    state.didChange(value);
                                  },
                                ),
                              ),
                        if (state.errorText != null)
                          Text(
                            state.errorText!,
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FormField<String?>(
                    initialValue: provider.body['subcategory'],
                    validator: (value) {
                      // logger.i(value);
                      if (value == null) {
                        return 'Entrer une subcategory';
                      } else {
                        return null;
                      }
                    },
                    builder: (state) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        provider.categoriesLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : provider.subcategories.fold(
                                (l) => OutlinedButton(
                                    onPressed: () {},
                                    child: const Column(
                                      children: [
                                        Text(
                                            'Erreur de chargement des subcategories'),
                                        Text('refresh'),
                                      ],
                                    )),
                                (subcategories) =>
                                    DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    label: const Text('Subcategories'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  value: provider.body['subcategory'],
                                  items: subcategories
                                      .map(
                                        (c) => DropdownMenuItem<String>(
                                          //!the value of category is id

                                          value: c,
                                          child: Text(c),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    provider.setField('subcategory', value);
                                    state.didChange(value);
                                  },
                                ),
                              ),
                        if (state.errorText != null)
                          Text(
                            state.errorText!,
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  formTf(
                    "Entrez la Description",
                    TextInputType.text,
                    controller: provider.body['description'],
                    lines: 5,
                    labelBehaviour: FloatingLabelBehavior.always,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (provider.key.currentState!.validate()) {
                  provider.updateModel(
                    product.id!,
                    onFail: (e) {
                      showInformativeDialog(
                        context,
                        'Erreur innatendue , réessayer',
                        'erreur',
                      );
                    },
                    onSuccess: (res) {
                      logger.i(res);
                      const snackBar = SnackBar(
                        content: Text('Informations mise a jour avec success'),
                      );
                      ScaffoldMessenger.of(modelPageContext)
                          .showSnackBar(snackBar);
                      // widget.modelPageContext.pop(true);
                    },
                  );
                }
              },
              child: const Text('Modifier les informations'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
