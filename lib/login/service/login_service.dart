import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

class LoginService {
  late SharedPreferences sharedPreferences;
  static LoginStatus status = LoginStatus.pending;

  Future<LoginStatus> loginUser(email, password) async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('============>>>>>>>>>>>>>>>>>>>>> signed in, $response');
      User? user = response.user;
      if (user != null) {
        await sharedPreferences.setString(nameKey, user.displayName.toString());
        await sharedPreferences.setString(emailKey, user.email.toString());
        status = LoginStatus.successful;
      } else {
        status = LoginStatus.noUser;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        status = LoginStatus.noUser;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        status = LoginStatus.wrongPass;
      }
    } catch (e) {
      print(e);
      status = LoginStatus.failed;
    }
    return status;
  }
}
