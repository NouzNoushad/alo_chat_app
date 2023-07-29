import 'package:alo_chat_app/complete_profile/screens/complete_profile.dart';
import 'package:alo_chat_app/model/user_model.dart';
import 'package:alo_chat_app/sign_up/service/sign_up_service.dart';
import 'package:alo_chat_app/sign_up/service/validator_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../widgets/dialog_box.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.signUpService}) : super(SignUpInitial());
  SignUpService signUpService;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode signUpFullNameFocusNode = FocusNode();
  FocusNode signUpEmailFocusNode = FocusNode();
  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpConfirmPasswordFocusNode = FocusNode();

  ValidatorService validatorService = ValidatorService();

  String? nameValidator(String? value) {
    return validatorService.nameValidator(fullNameController.text);
  }

  String? emailValidator(String? value) {
    return validatorService.emailValidator(emailController.text);
  }

  String? passwordValidator(String? value) {
    return validatorService.passwordValidator(passwordController.text);
  }

  String? confirmPasswordValidator(String? value) {
    return validatorService.confirmPasswordValidator(
        confirmPasswordController.text, passwordController.text);
  }

  createUserAccount(context) async {
    var navigator = Navigator.of(context);
    String name = fullNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    var response =
        await signUpService.createUserAccount(context, name, email, password);
    if (response == SignUpStatus.successful) {
      UserModel userModel = SignUpService.userProfile;
      // showAlertDialog(
      //   context: context,
      //   title: 'Success',
      //   content: 'Created your new account',
      //   status: Status.success,
      // );
      // Navigate to Complete profile page
      navigator.pushReplacement(MaterialPageRoute(
          builder: (context) => CompleteProfile(
                userModel: userModel,
                profileType: ProfileType.complete,
              )));
    } else if (response == SignUpStatus.exists) {
      showAlertDialog(
        context: context,
        title: 'Error',
        content: 'User already exists',
        status: Status.failed,
      );
    } else if (response == SignUpStatus.failed) {
      showAlertDialog(
        context: context,
        title: 'Error',
        content: 'Something went wrong',
        status: Status.failed,
      );
    }
    Future.delayed(const Duration(seconds: 2), () {
      fullNameController.text = '';
      emailController.text = '';
      passwordController.text = '';
      confirmPasswordController.text = '';
    });
  }

  @override
  Future<void> close() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    return super.close();
  }
}
