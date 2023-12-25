import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future logOut() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString('CurrentUserName', null);
  await preferences.setString('CurrentUserEmail', null);
  await preferences.setString('CurrentUserRole', null);
  await preferences.setString('CurrentUserToken', null);
  await preferences.setString('CurrentUserId', null);
  await preferences.setString('pinExist', null);
  await preferences.setInt('mPin', null);
}

Future<void> studentLogout(String userToken) async {
  final url = "https://api-dashboard.intrack.in/v1/parentLogout";
  final response = await http.put(
    Uri.parse(url),
    headers: {"authorization": "Bearer " + userToken},
  );
  if (response.statusCode == 200) {
    print(response.body);
  }
}

Future<void> teacherLogout(String userToken) async {
  final url = "https://api-dashboard.intrack.in/v1/teacherLogout";
  final response = await http.put(
    Uri.parse(url),
    headers: {"authorization": "Bearer " + userToken},
  );
  if (response.statusCode == 200) {
    print(response.body);
  }
}
