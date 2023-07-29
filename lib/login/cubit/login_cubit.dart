import 'package:alo_chat_app/alo_home/screens/alo_home_screen.dart';
import 'package:alo_chat_app/login/service/login_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/constants.dart';
import '../../sign_up/service/validator_service.dart';
import '../../widgets/dialog_box.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginService}) : super(LoginInitial());
  LoginService loginService;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode signUpEmailFocusNode = FocusNode();
  FocusNode signUpPasswordFocusNode = FocusNode();

  ValidatorService validatorService = ValidatorService();

  String? emailValidator(String? value) {
    return validatorService.emailValidator(emailController.text);
  }

  String? passwordValidator(String? value) {
    return validatorService.passwordValidator(passwordController.text);
  }

  loginUser(context) async {
    var navigator = Navigator.of(context);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    var response = await loginService.loginUser(email, password);
    if (response == LoginStatus.successful) {
      showAlertDialog(
        context: context,
        title: 'Success',
        content: 'You are successfully logged In',
        status: Status.success,
      );
      Future.delayed(const Duration(seconds: 2), () {
        // Navigate to Home page
        navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => const AloHomeScreen()));
      });
    } else if (response == LoginStatus.noUser) {
      showAlertDialog(
        context: context,
        title: 'Error',
        content: 'No user found, signup first',
        status: Status.failed,
      );
    } else if (response == LoginStatus.wrongPass) {
      showAlertDialog(
        context: context,
        title: 'Error',
        content: 'Wrong password, try again',
        status: Status.failed,
      );
    } else if (response == LoginStatus.failed) {
      showAlertDialog(
        context: context,
        title: 'Error',
        content: 'Something went wrong',
        status: Status.failed,
      );
    }
    Future.delayed(const Duration(seconds: 2), () {
      emailController.text = '';
      passwordController.text = '';
    });
  }

  @override
  Future<void> close() {
    emailController.clear();
    passwordController.clear();
    return super.close();
  }
}
