import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/providers/filtrable_list_provider.dart';
import 'package:flutter/material.dart';

class FilterableListWidget extends StatefulWidget {
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final FilterableListProvider provider;
  const FilterableListWidget(
      {required this.itemBuilder, required this.provider, super.key});

  @override
  State<FilterableListWidget> createState() => _FilterableListWidgetState();
}

class _FilterableListWidgetState<T> extends State<FilterableListWidget> {
  @override
  void initState() {
    super.initState();
    logger.d('getting');
    widget.provider.getList();
  }

  requestData() async {
    await widget.provider.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchField(onChanged: (value) => widget.provider.runFilter(value)),
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
                              itemBuilder: (context, index) =>
                                  widget.itemBuilder(context, data[index]))),
              onRefresh: () async => await requestData()),
        )
      ],
    );
  }
}
