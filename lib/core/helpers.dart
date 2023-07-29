import 'package:alo_chat_app/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  late SharedPreferences sharedPreferences;
  Future<String?> getEmail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(emailKey);
  }

  Future<String?> getName() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(nameKey);
  }

  setEmail(email) async {
    await sharedPreferences.setString(emailKey, email);
  }

  setName(name) async {
    await sharedPreferences.setString(nameKey, name);
  }

  clearSharedPreferences() async {
    await sharedPreferences.remove(emailKey);
    await sharedPreferences.remove(nameKey);
  }
}
