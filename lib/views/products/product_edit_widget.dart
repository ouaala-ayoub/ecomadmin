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

class ProductEditWidget extends StatefulWidget {
  final BuildContext modelPageContext;
  final Product product;
  final ProductEditProvider provider;
  const ProductEditWidget(
      {required this.product,
      required this.provider,
      required this.modelPageContext,
      super.key});

  @override
  State<ProductEditWidget> createState() => _ProductEditWidgetState();
}

class _ProductEditWidgetState extends State<ProductEditWidget> {
  @override
  void initState() {
    super.initState();
    widget.provider.initialiseData(widget.product);
  }

  @override
  Widget build(BuildContext buildContext) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Form(
            key: widget.provider.key,
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  formTf('Entrez le Titre', TextInputType.text,
                      controller: widget.provider.body['title']),
                  const SizedBox(
                    height: 15,
                  ),
                  formTf('Entrez le Prix', TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: widget.provider.body['price']),
                  const SizedBox(
                    height: 10,
                  ),
                  FormField<dynamic>(
                    initialValue: widget.provider.body['images'],
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
                              widget.provider.addImages(images);
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
                  if (widget.provider.body['images']
                      .whereType<XFile>()
                      .toList()
                      .isNotEmpty)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.provider.body['images']
                          .whereType<XFile>()
                          .toList()
                          .length,
                      itemBuilder: (context, index) => ImageWidget(
                          file: widget.provider.body['images']
                              .whereType<XFile>()
                              .toList()[index],
                          onLongPress: (file) {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        widget.provider.removeFile(file);
                                        context.pop();
                                      },
                                      child: const Text("Supprimer"))
                                ],
                              ),
                            );
                          }),
                    ),
                  if (widget.provider.body['images']
                      .whereType<String>()
                      .toList()
                      .isNotEmpty)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.provider.body['images']
                          .whereType<String>()
                          .toList()
                          .length,
                      itemBuilder: (context, index) => NetworkImageWidget(
                          imageUrl: widget.provider.body['images']
                              .whereType<String>()
                              .toList()[index],
                          onLongPress: (url) {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        widget.provider.removeFile(url);
                                        context.pop();
                                      },
                                      child: const Text("Supprimer"))
                                ],
                              ),
                            );
                          }),
                    ),

                  const SizedBox(
                    height: 15,
                  ),
                  FormField<Category?>(
                    initialValue: widget.provider.body['category'],
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
                        widget.provider.categoriesLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : widget.provider.categories.fold(
                                (l) => OutlinedButton(
                                    onPressed: () =>
                                        widget.provider.fetshCategories(),
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
                                  value: widget.provider.body['category'],
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
                                    widget.provider.setField('category', value);
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
                    initialValue: widget.provider.body['subcategory'],
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
                        widget.provider.categoriesLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : widget.provider.subcategories.fold(
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
                                  value: widget.provider.body['subcategory'],
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
                                    widget.provider
                                        .setField('subcategory', value);
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
                    controller: widget.provider.body['description'],
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
                if (widget.provider.key.currentState!.validate()) {
                  widget.provider.updateModel(
                    widget.product.id!,
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
                      ScaffoldMessenger.of(widget.modelPageContext)
                          .showSnackBar(snackBar);
                      // widget.modelPageContext.pop();
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
