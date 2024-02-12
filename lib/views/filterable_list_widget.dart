import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/providers/filtrable_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterableListWidget extends StatefulWidget {
  final String route;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final FilterableListProvider provider;
  const FilterableListWidget(
      {required this.itemBuilder,
      required this.provider,
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
                                onTap: () async {
                                  final added = await context.push(
                                      '/${widget.route}/${data[index].id}');

                                  if (added == true) {
                                    requestData();
                                  }
                                },
                                onLongPress: () {
                                  //todo
                                },
                                child: widget.itemBuilder(context, data[index]),
                              ),
                            ),
                    ),
              onRefresh: () async => await requestData()),
        )
      ],
    );
  }
}
