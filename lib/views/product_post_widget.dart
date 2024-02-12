import 'package:ecomadmin/providers/product_post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
          formTf('Titre', TextInputType.text),
          const SizedBox(
            height: 15,
          ),
          formTf(
            'Prix',
            TextInputType.number,
            formatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
            onPressed: () async {
              //todo do the images pick logic
              final imagePicker = ImagePicker();
              final images = await imagePicker.pickMultiImage();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.add), Text('ajouter des images')],
            ),
          ),
          //to add images
          // ListView.builder(itemBuilder: (context, index) => Image(),)
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  TextFormField formTf(String text, inputType,
      {List<TextInputFormatter>? formatters}) {
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
