import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/helpers/cookie_helpers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthApi {
  static final baseUrl = '${dotenv.env['BASE_URL']}/auth';
  static Future<dynamic> getAuth() async {
    final endpoint = baseUrl;
    final cookie = await getSessionCookie();
    logger.i(cookie);
    final res = await Dio().get(
      endpoint,
      options: Options(
        headers: {'Cookie': 'session=$cookie'},
      ),
    );
    logger.i(res.data);
    return res.data;
  }

  static Future<dynamic> instaLogin(String username, String password) async {
    final endpoint = "${dotenv.env['BASE_URL']}/insta/login";
    final creds = {'username': username, 'password': password};
    final cookie = await getSessionCookie();
    final res = await Dio().post(
      endpoint,
      data: jsonEncode(creds),
      options: Options(
        headers: {'Cookie': 'session=$cookie'},
      ),
    );
    return res.data;
  }

  static Future<dynamic> login(String username, String password) async {
    final endpoint = "$baseUrl/login";
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
