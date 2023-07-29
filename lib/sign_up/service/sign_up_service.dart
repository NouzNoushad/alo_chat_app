import 'package:alo_chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

class SignUpService {
  late SharedPreferences sharedPreferences;
  static SignUpStatus status = SignUpStatus.pending;
  static late UserModel userProfile;

  Future<SignUpStatus> createUserAccount(context, name, email, password) async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await user?.updateDisplayName(name);
      if (user != null) {
        print(
            '//////////////////////////=========>>>>>>>>>>>>> user id: ${user.uid}');
        String uid = user.uid;
        UserModel userModel = UserModel(
            uid: uid,
            fullName: name,
            nickName: '',
            email: email,
            phoneNo: '',
            profilePic: '',
            about: '', 
            createdOn: DateTime.now());
        userProfile = userModel;
        await FirebaseFirestore.instance
            .collection(dbName)
            .doc(uid)
            .set(userModelToMap(userModel))
            .then((value) async {
          await sharedPreferences.setString(nameKey, name);
          await sharedPreferences.setString(emailKey, email);
          await sharedPreferences.setString(uidKey, uid);
          var savedName = sharedPreferences.getString(nameKey);
          print(
              '//////////////////////////=========>>>>>>>>>>>>> saved Name: $savedName');
          status = SignUpStatus.successful;
        }).catchError((err) {
          status = SignUpStatus.failed;
          print('Error occured: $err');
        });
      } else {
        status = SignUpStatus.failed;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        status = SignUpStatus.exists;
      }
    } catch (e) {
      print(e);
      status = SignUpStatus.failed;
    }
    return status;
  }
}
