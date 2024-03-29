import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../models/core/helper.dart';

class FilterableListProvider extends ChangeNotifier {
  FilterableListProvider(this.helper);

  final searchController = TextEditingController();
  final Helper helper;
  bool loading = false;
  Either<dynamic, List<dynamic>> list = const Right([]);
  Either<dynamic, List<dynamic>> _found = const Right([]);
  Either<dynamic, List<dynamic>> get found => _found;

  deleteElement(String id,
      {required Function(dynamic) onFail, Function(dynamic)? onSuccess}) async {
    loading = true;
    final deleted = await helper.deleteElement(id);
    deleted.fold((e) {
      onFail(e);
    }, (res) {
      getList();
      onSuccess?.call(res);
    });
    loading = false;
    notifyListeners();
  }

  getList() async {
    loading = true;
    list = await helper.fetshAll();
    _found = list;
    loading = false;
    notifyListeners();
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      _found = list;
    } else {
      _found = list.fold((l) => Left(l), (r) {
        return Right(r
            .where((element) =>
                element
                    .toString()
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ==
                true)
            .toList());
      });
    }
    notifyListeners();
  }
}
