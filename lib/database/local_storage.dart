import 'package:shared_preferences/shared_preferences.dart';

// These are used to save data in local machine so that if we
// clase app and again open it then login doesn't required
final String loginKey = 'LOGINKEY';
final String userNameKey = 'USERNAMEKEY';
final String emailKey = 'EMAILKEY';

String myName = 'User';

Future storeLoginStatus(bool isLogIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool('LOGINKEY', isLogIn);
}

Future storeUserName(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString('USERNAMEKEY', userName);
}

Future storeEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString('EMAILKEY', email);
}

Future getLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getBool('LOGINKEY');
}

Future getStoredUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getString('USERNAMEKEY');
}

Future getStoredEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getString('EMAILKEY');
}
