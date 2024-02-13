import 'package:ecomadmin/main.dart';
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
          formTf('Titre', TextInputType.text,
              controller: widget.provider.body['title']),
          const SizedBox(
            height: 15,
          ),
          formTf('Prix', TextInputType.number,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              controller: widget.provider.body['price']),
          const SizedBox(
            height: 10,
          ),
          FormField<List<XFile>>(
            autovalidateMode: AutovalidateMode.always,
            initialValue: widget.provider.body['images'],
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
          FormField<String?>(
            initialValue: widget.provider.body['category'],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Entrer une catégorie';
              } else {
                return null;
              }
            },
            builder: (field) => widget.provider.categoriesLoading
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
                    (categories) => DropdownButtonFormField<String?>(
                      decoration:
                          const InputDecoration(label: Text('Categories')),
                      value: widget.provider.body['category'],
                      items: categories
                          .map(
                            (c) => DropdownMenuItem<String>(
                              child: Text('${c.title}'),
                              //!the value of category is id
                              value: c.id,
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          widget.provider.setField('category', value),
                    ),
                  ),
          )

          // DropdownButtonFormField<String>(
          //   value: //todo,
          //   items: [
          //     DropdownMenuItem(
          //       child: Text('testing'),
          //     ),
          //     DropdownMenuItem(
          //       child: Text('testing'),
          //     ),
          //     DropdownMenuItem(
          //       child: Text('testing'),
          //     ),
          //     DropdownMenuItem(
          //       child: Text('testing'),
          //     ),
          //   ],
          //   onChanged: (value) {},
          // ),
        ],
      ),
    );
  }

  TextFormField formTf(String text, inputType,
      {List<TextInputFormatter>? formatters,
      required TextEditingController controller}) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(text),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      inputFormatters: formatters,
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Entrez le $text';
        }
        return null;
      },
    );
  }
}
