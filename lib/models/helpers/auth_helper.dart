import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/models/services/auth_api.dart';

class AuthHelper {
  static Future<Either<dynamic, Admin>> getAuth() async {
    try {
      final res = await AuthApi.getAuth();
      return Right(Admin.fromMap(res));
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      logger.e(e.response?.data['message']);
      return Left(e.response?.statusCode);
    } catch (e) {
      logger.e(e);

      return const Left(500);
    }
  }

  static Future<Either<dynamic, Admin>> login(
      String username, String password) async {
    try {
      final res = await AuthApi.login(username, password);
      logger.i('login res $res');
      return Right(Admin.fromMap(res));
    } on DioException catch (e) {
      logger.e(e.response?.data['message']);
      return Left(e.response?.statusCode);
    } catch (e) {
      logger.e(e);
      return const Left(500);
    }
  }
}
