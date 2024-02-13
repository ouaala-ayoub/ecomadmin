import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/category.dart';
import 'package:ecomadmin/providers/product_post_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'image_widget.dart';

class ProductPostWidget extends StatefulWidget {
  const ProductPostWidget({super.key, required this.provider});
  final ProductPostProvider provider;

  @override
  State<ProductPostWidget> createState() => _ProductPostWidgetState();
}

class _ProductPostWidgetState extends State<ProductPostWidget> {
  @override
  void initState() {
    super.initState();
    widget.provider.fetshCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView(
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
          FormField<List<XFile>>(
            initialValue: widget.provider.body['images'],
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              logger.d(value);
              return value?.isEmpty == true ? 'Choisissez des images !' : null;
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
                      children: [Icon(Icons.add), Text('ajouter des images')],
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
          if (widget.provider.body['images'].isNotEmpty)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.provider.body['images'].length,
              itemBuilder: (context, index) => ImageWidget(
                  file: widget.provider.body['images'][index] as XFile,
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
                            onPressed: () => widget.provider.fetshCategories(),
                            child: const Column(
                              children: [
                                Text('Erreur de chargement des categories'),
                                Text('refresh'),
                              ],
                            )),
                        (categories) => DropdownButtonFormField<Category>(
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
                                Text('Erreur de chargement des subcategories'),
                                Text('refresh'),
                              ],
                            )),
                        (subcategories) => DropdownButtonFormField<String>(
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
                            widget.provider.setField('subcategory', value);
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
    );
  }

  TextFormField formTf(
    String text,
    TextInputType? inputType, {
    List<TextInputFormatter>? formatters,
    required TextEditingController controller,
    int? lines,
    FloatingLabelBehavior? labelBehaviour,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(text),
        floatingLabelBehavior: labelBehaviour,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      controller: controller,
      inputFormatters: formatters,
      keyboardType: inputType,
      maxLines: lines,
      minLines: lines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return text;
        }
        return null;
      },
    );
  }
}
