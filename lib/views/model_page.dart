import 'package:ecomadmin/providers/model_page_provider.dart';
import 'package:ecomadmin/views/error_page.dart';
import 'package:flutter/material.dart';

class ModelPage extends StatefulWidget {
  final String modelId;
  final ModelPageProvider modelPageProvider;
  final Widget Function(dynamic) widgetBuilder;
  const ModelPage(
      {required this.modelPageProvider,
      required this.widgetBuilder,
      required this.modelId,
      super.key});

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  @override
  void initState() {
    super.initState();
    widget.modelPageProvider.fetshModelById(widget.modelId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.modelPageProvider;
    return Scaffold(
      appBar: AppBar(title: Text('to change')),
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.model.fold(
              (e) => ErrorPage(message: e.toString()),
              (model) => widget.widgetBuilder(model),
            ),
    );
  }
}
