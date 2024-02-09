import 'package:flutter_secure_storage/flutter_secure_storage.dart';

getSessionCookie() async {
  const storage = FlutterSecureStorage();
  final session = await storage.read(key: 'session_cookie');
  return session;
}

writeSessionCookie(String cookie) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'session_cookie', value: cookie);
}

deleteSessionCookie() async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'session_cookie');
}
