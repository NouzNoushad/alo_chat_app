import 'package:alo_chat_app/core/colors.dart';
import 'package:alo_chat_app/login/screen/login_screen.dart';
import 'package:alo_chat_app/sign_up/cubit/sign_up_cubit.dart';
import 'package:alo_chat_app/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/auth_button.dart';

class AloChatSignUp extends StatefulWidget {
  const AloChatSignUp({super.key});

  @override
  State<AloChatSignUp> createState() => _AloChatSignUpState();
}

class _AloChatSignUpState extends State<AloChatSignUp> {
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  SignUpCubit signUpCubit =
                      BlocProvider.of<SignUpCubit>(context);
                  return Form(
                    key: signUpFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChatTextFormField(
                          hintText: 'Full Name',
                          controller: signUpCubit.fullNameController,
                          icon: FontAwesomeIcons.userLarge,
                          keyboardType: TextInputType.name,
                          validator: signUpCubit.nameValidator,
                          focusNode: signUpCubit.signUpFullNameFocusNode,
                          onTapOutside: (event) =>
                              signUpCubit.signUpFullNameFocusNode.unfocus(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ChatTextFormField(
                          hintText: 'Email',
                          icon: FontAwesomeIcons.at,
                          controller: signUpCubit.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: signUpCubit.emailValidator,
                          focusNode: signUpCubit.signUpEmailFocusNode,
                          onTapOutside: (event) =>
                              signUpCubit.signUpEmailFocusNode.unfocus(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ChatTextFormField(
                          hintText: 'Password',
                          icon: FontAwesomeIcons.lock,
                          controller: signUpCubit.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: signUpCubit.passwordValidator,
                          focusNode: signUpCubit.signUpPasswordFocusNode,
                          onTapOutside: (event) =>
                              signUpCubit.signUpPasswordFocusNode.unfocus(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ChatTextFormField(
                          hintText: 'Confirm Password',
                          icon: FontAwesomeIcons.lock,
                          controller: signUpCubit.confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: signUpCubit.confirmPasswordValidator,
                          focusNode: signUpCubit.signUpConfirmPasswordFocusNode,
                          onTapOutside: (event) => signUpCubit
                              .signUpConfirmPasswordFocusNode
                              .unfocus(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          const AloChatLogin())),
                              child: const Text(
                                'Already have an account? Login',
                                style: TextStyle(
                                  color: CustomColors.backgroundColor1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        AuthButton(
                          buttonText: 'sign up',
                          onPressed: () async {
                            if (signUpFormKey.currentState!.validate()) {
                              signUpFormKey.currentState!.save();
                              await signUpCubit.createUserAccount(
                                context);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
