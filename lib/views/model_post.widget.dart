import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/providers/model_post_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModelPostWidget extends StatelessWidget {
  final Widget Function(ModelPostProvider) formBuilder;
  final ModelPostProvider provider;
  const ModelPostWidget(
      {required this.formBuilder, required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter')),
      body: Form(
        key: provider.formKey,
        child: Column(children: [
          Expanded(child: formBuilder(provider)),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (provider.formKey.currentState!.validate()) {
                    final req = provider.processData();
                    provider.addModel(
                      req,
                      onSuccess: (res) {
                        logger.i(res);
                        const snackBar = SnackBar(
                          content: Text('Ajoutée avec success'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        context.pop();
                      },
                      onFail: (e) {
                        logger.e(e);
                        showInformativeDialog(
                          context,
                          'Erreur innatendue , réessayer',
                          'erreur',
                        );
                      },
                    );
                  }
                },
                child: const Text('Ajouter'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }
}
