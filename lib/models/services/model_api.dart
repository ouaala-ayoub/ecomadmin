import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/helpers/cookie_helpers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ModelApi {
  final String route;
  final _baseUrl = dotenv.env['BASE_URL'];
  ModelApi({required this.route}) {
    logger.i('api with route $route');
  }

  Future<List<dynamic>> fetshAll() async {
    final endpoint = '$_baseUrl/$route';
    final res = await Dio().get(endpoint, options: await getCookieOption());
    return res.data;
  }

  Future<dynamic> fetshById(String id) async {
    final endpoint = '$_baseUrl/$route/$id';
    logger.i(endpoint);
    final res = await Dio().get(endpoint, options: await getCookieOption());
    logger.i(res.data);
    return res.data;
  }

  Future<dynamic> postModel(Map<String, dynamic> body) async {
    final endpoint = '$_baseUrl/$route';
    final res = await Dio().post(
      endpoint,
      options: await getCookieOption(),
      data: jsonEncode(body),
    );
    return res.data;
  }

  // Future<Either<dynamic, dynamic>> deleteElement(String id) {}
}
