import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/helpers/cookie_helpers.dart';

class AuthApi {
  static const baseUrl = 'http://10.0.2.2:3000/auth';
  static Future<dynamic> getAuth() async {
    const endpoint = baseUrl;
    final cookie = await getSessionCookie();
    final res = await Dio().get(endpoint,
        options: Options(headers: {'Cookie': 'session=$cookie'}));
    logger.i(res.data);
    return res.data;
  }

  static Future<dynamic> login(String username, String password) async {
    const endpoint = "$baseUrl/login";
    final creds = {'username': username, 'password': password};
    final res = await Dio().post(
      endpoint,
      data: jsonEncode(creds),
    );

    final cookieValue = res.headers['Set-Cookie']?[0].split('=')[1];
    if (cookieValue == null) {
      throw Exception('Error retrieving cookie');
    }
    logger.i('writing $cookieValue');
    writeSessionCookie(cookieValue);
    return res.data;
  }
}
