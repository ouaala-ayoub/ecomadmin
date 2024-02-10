import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/helper.dart';
import 'package:ecomadmin/models/services/model_api.dart';

class ModelHelper extends Helper {
  ModelHelper({required this.route, required this.converterMethod})
      : _api = ModelApi(route: route),
        super(route: route) {
    logger.d('helper with route $route');
  }

  @override
  final String route;
  final dynamic Function(dynamic) converterMethod;
  final ModelApi _api;

  @override
  Future<Either<dynamic, List<dynamic>>> fetshAll() async {
    try {
      final res = await _api.fetshAll();
      return Right(res.map((e) => converterMethod(e)).toList());
    } on DioException catch (dioException) {
      logger.e(dioException.response?.data['message']);
      throw Exception(dioException);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<dynamic, List<dynamic>>> getElement(String id) async {
    try {
      final res = await _api.fetshById(id);
      return Right(converterMethod(res));
    } on DioException catch (dioException) {
      logger.e(dioException.response?.data['message']);
      throw Exception(dioException);
    } catch (e) {
      return Left(e);
    }
  }
}
