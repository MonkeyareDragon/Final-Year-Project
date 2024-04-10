import 'package:loginsignup/controller/session_manager.dart';
import 'package:loginsignup/model/session/user_session.dart';

Future<UserSession> getSessionOrThrow() async {
  final UserSession? session = await SessionManager.getSession();
  if (session == null) {
    throw Exception('No session found');
  }
  return session;
}