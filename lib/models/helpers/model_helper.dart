import 'package:dartz/dartz.dart';
import 'package:ecomadmin/models/core/helper.dart';
import 'package:ecomadmin/models/services/model_api.dart';

class ModelHelper<T> extends Helper {
  ModelHelper({required this.converterMethod, required this.route})
      : _api = ModelApi(route: route);

  final String route;
  final T Function(dynamic) converterMethod;
  final ModelApi _api;

  @override
  Future<Either<dynamic, List<T>>> fetshAll() async {
    try {
      final res = await _api.fetshAll();
      return Right(res.map((e) => converterMethod(res)).toList());
    } catch (e) {
      return Left(e);
    }
  }
}
