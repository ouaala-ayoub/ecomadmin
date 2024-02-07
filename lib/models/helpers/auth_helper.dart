import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/models/services/aurh_api.dart';

class AuthHelper {
  static Future<Either<dynamic, Admin>> getAuth() async {
    try {
      final res = await AuthApi.getAuth();
      return Right(Admin.fromMap(res));
    } catch (e) {
      logger.e(e);
      return Left(e);
    }
  }

  static Future<Either<dynamic, Admin>> login(
      String username, String password) async {
    try {
      final res = await AuthApi.login(username, password);
      return Right(Admin.fromMap(res));
    } on DioException catch (e) {
      return Left(e.response?.data['message']);
    } catch (e) {
      logger.e(e);
      return Left(e);
    }
  }
}
