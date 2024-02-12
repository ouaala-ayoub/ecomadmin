import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/providers/product_post_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'image_widget.dart';

class ProductPostWidget extends StatelessWidget {
  const ProductPostWidget({super.key, required this.provider});
  final ProductPostProvider provider;

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
              controller: provider.body['title']),
          const SizedBox(
            height: 15,
          ),
          formTf('Prix', TextInputType.number,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              controller: provider.body['price']),
          const SizedBox(
            height: 10,
          ),
          FormField<List<XFile>>(
            autovalidateMode: AutovalidateMode.always,
            initialValue: provider.body['images'],
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
                      provider.addImages(images);
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
                    style: TextStyle(color: Colors.red),
                  )
              ],
            ),
          ),
          //to add images
          const SizedBox(
            height: 10,
          ),
          if (provider.body['images'].isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              itemCount: provider.body['images'].length,
              itemBuilder: (context, index) => ImageWidget(
                  file: provider.body['images'][index] as XFile,
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
                              child: Text("Supprimer"))
                        ],
                      ),
                    );
                  }),
            ),

          // ListView.builder(itemBuilder: (context, index) => Image(),)
          const SizedBox(
            height: 15,
          ),
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
