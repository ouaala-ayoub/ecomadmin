import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/providers/filtrable_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterableListWidget extends StatefulWidget {
  final String route;
  final bool canLook;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final FilterableListProvider provider;
  const FilterableListWidget(
      {required this.itemBuilder,
      required this.provider,
      this.canLook = true,
      super.key,
      required this.route});
  @override
  State<FilterableListWidget> createState() => _FilterableListWidgetState();
}

class _FilterableListWidgetState<T> extends State<FilterableListWidget> {
  @override
  void initState() {
    super.initState();
    widget.provider.getList();
  }

  requestData() async {
    await widget.provider.getList();
    widget.provider.searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchField(
          onChanged: (query) => widget.provider.runFilter(query),
          textFieldController: widget.provider.searchController,
        ),
        Expanded(
          child: RefreshIndicator.adaptive(
              child: widget.provider.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : widget.provider.found.fold(
                      (e) => Center(
                        child: Text('$e'),
                      ),
                      (data) => data.isEmpty
                          ? const Center(
                              child: Text('Pas de données'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  if (widget.canLook) {
                                    context.push(
                                        '/${widget.route}/${data[index].id}');
                                  }
                                },
                                onLongPress: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                      actions: [
                                        if (widget.route != 'categories')
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              context.push(
                                                  '/${widget.route}/${data[index].id}');
                                            },
                                            child: const Text(
                                              "Plus d'informations",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        CupertinoActionSheetAction(
                                          isDestructiveAction: true,
                                          onPressed: () {
                                            showAdaptiveDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog.adaptive(
                                                title:
                                                    const Text('Supprimer ?'),
                                                content: const Text(
                                                  'Vous êtes sur le point de supprimer ! procéder ?',
                                                ),
                                                actions: [
                                                  FilledButton(
                                                    onPressed: () {
                                                      widget.provider
                                                          .deleteElement(
                                                        data[index].id,
                                                        onSuccess: (res) {
                                                          logger.i(res);
                                                          const snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                'Supprimée avec success'),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                          context.pop();
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
                                                    },
                                                    child: const Text('Oui'),
                                                  ),
                                                  OutlinedButton(
                                                    onPressed: () =>
                                                        context.pop(),
                                                    child: const Text('Non'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Text('Supprimer'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: widget.itemBuilder(context, data[index]),
                              ),
                            ),
                    ),
              onRefresh: () async => await requestData()),
        ),
      ],
    );
  }
}
