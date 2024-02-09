import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:ecomadmin/providers/filtrable_list_provider.dart';
import 'package:flutter/material.dart';

class FilterableListWidget<T> extends StatefulWidget {
  final Widget Function(BuildContext, T) itemBuilder;
  final FilterableListProvider<T> provider;
  const FilterableListWidget(
      {required this.itemBuilder, required this.provider, super.key});

  @override
  State<FilterableListWidget> createState() => _FilterableListWidgetState<T>();
}

class _FilterableListWidgetState<T> extends State<FilterableListWidget> {
  @override
  void initState() {
    super.initState();
    widget.provider.getList();
  }

  requestData() {
    widget.provider.getList();
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
                              child: Text('Pas de bureaux'),
                            )
                          : ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) =>
                                  widget.itemBuilder(context, data[index]))),
              onRefresh: () => requestData()),
        )
      ],
    );
  }
}
