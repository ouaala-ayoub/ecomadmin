import 'package:ecomadmin/providers/filtrable_list_provider.dart';
import 'package:flutter/material.dart';

class FilterableListWidget<T> extends StatefulWidget {
  final FilterableListProvider<T> provider;
  const FilterableListWidget({required this.provider, super.key});

  @override
  State<FilterableListWidget> createState() => _FilterableListWidgetState<T>();
}

class _FilterableListWidgetState<T> extends State<FilterableListWidget> {
  @override
  void initState() {
    super.initState();
    // widget.provider.getList();
  }

  requestData() {
    // widget.provider.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('testing')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
