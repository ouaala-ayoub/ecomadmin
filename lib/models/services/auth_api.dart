import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecomadmin/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthApi {
  static const baseUrl = 'http://localhost:3000/auth';
  static Future<dynamic> getAuth() async {
    const endpoint = baseUrl;
    final cookie = await _getSessionCookie();
    logger.i('got $cookie');
    final res = await Dio().get(endpoint,
        options: Options(headers: {'Cookie': 'session=$cookie'}));
    logger.i(res.data);
    return res.data;
  }

  static Future<dynamic> login(String username, String password) async {
    const endpoint = "$baseUrl/login";
    final creds = {'username': username, 'password': password};
    final res = await Dio().post(endpoint, data: jsonEncode(creds));
    //todo get session cookie
    //! error getting headers due to security ?
    logger.i(res.headers['set-cookie']);
    final cookieValue = res.headers['set-cookie']?[0].split('=')[1];
    if (cookieValue == null) {
      throw Exception('Error retrieving cookie');
    }
    logger.i('writing $cookieValue');
    _writeSessionCookie(cookieValue);
    return res.data;
  }

  static _getSessionCookie() async {
    const storage = FlutterSecureStorage();
    final session = await storage.read(key: 'session_cookie');
    return session;
  }

  static _writeSessionCookie(String cookie) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'session_cookie', value: cookie);
  }
}
