// import 'package:lexin/LoginPage/models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future saveCurrentLogin(
  String name,
  String email,
  String role,
  String userToken,
  String userId,
  String parentId,
  String classId,
  String sectionId,
  String studentPic,
  int mPin,
  bool pinExist,
) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString('CurrentUserName', name);
  await preferences.setString('CurrentUserEmail', email);
  await preferences.setString('CurrentUserRole', role);
  await preferences.setString('CurrentUserToken', userToken);
  await preferences.setString('CurrentUserId', userId);
  await preferences.setString('parentId', parentId);
  await preferences.setString('classId', classId);
  await preferences.setString('sectionId', sectionId);
  await preferences.setString('studentPic', studentPic);
  if (mPin != null) {
    await preferences.setInt('mPin', mPin);
  }
  await preferences.setBool('pinExist', pinExist);
}
