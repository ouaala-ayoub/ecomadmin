import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/helper.dart';
import 'package:ecomadmin/models/services/model_api.dart';

class ModelHelper extends Helper {
  ModelHelper({required this.converterMethod, required this.route})
      : _api = ModelApi(route: route);

  final String route;
  final dynamic Function(dynamic) converterMethod;
  final ModelApi _api;

  @override
  Future<Either<dynamic, List<dynamic>>> fetshAll() async {
    try {
      final res = await _api.fetshAll();
      // logger.i(res);
      return Right(res.map((e) => converterMethod(e)).toList());
    } on DioException catch (dioException) {
      logger.e(dioException.response?.data['message']);
      throw Exception(dioException);
    } catch (e) {
      return Left(e);
    }
  }
}