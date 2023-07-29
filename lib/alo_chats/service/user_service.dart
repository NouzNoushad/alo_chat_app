import 'package:alo_chat_app/core/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants.dart';
import '../../model/user_model.dart';

class UserService {
  SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
  Future<UserModel> getUserDetails() async {
    String? savedEmail = await sharedPreferencesHelper.getEmail();
    var savedUser = await FirebaseFirestore.instance
        .collection(dbName)
        .where('email', isEqualTo: savedEmail)
        .get();
    return userModelFromMap(savedUser.docs[0].data());
  }
}
