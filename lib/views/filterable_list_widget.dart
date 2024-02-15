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
    return Scaffold(
      floatingActionButton: widget.route != 'orders'
          ? FloatingActionButton(
              onPressed: () async {
                final added = await context.push(
                  '/add/${widget.route}',
                );
                if (added == true) {
                  widget.provider.getList();
                }
              },
              child: const Icon(
                Icons.add_circle_sharp,
                color: Colors.black,
              ),
            )
          : null,
      body: Column(
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
                                itemCount: data.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () async {
                                    if (widget.canLook) {
                                      final didUpdate = await context.push(
                                          '/${widget.route}/${data[index].id}');

                                      if (didUpdate == true) {
                                        widget.provider.getList();
                                      }
                                    }
                                  },
                                  onLongPress: () {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                        actions: [
                                          CupertinoActionSheetAction(
                                            onPressed: () async {
                                              final changed = await context.push(
                                                  '/${widget.route}/${data[index].id}');
                                              if (changed == true) {
                                                widget.provider.getList();
                                              }
                                            },
                                            child: Text(
                                              widget.route == 'orders'
                                                  ? "Plus d'informations"
                                                  : 'Modifer les informations',
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
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
                                                            ScaffoldMessenger
                                                                    .of(context)
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
                                  child:
                                      widget.itemBuilder(context, data[index]),
                                ),
                              ),
                      ),
                onRefresh: () async => await requestData()),
          ),
        ],
      ),
    );
  }
}
