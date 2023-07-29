import 'package:alo_chat_app/core/colors.dart';
import 'package:alo_chat_app/login/cubit/login_cubit.dart';
import 'package:alo_chat_app/sign_up/screen/sign_up_screen.dart';
import 'package:alo_chat_app/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/auth_button.dart';

class AloChatLogin extends StatefulWidget {
  const AloChatLogin({super.key});

  @override
  State<AloChatLogin> createState() => _AloChatLoginState();
}

class _AloChatLoginState extends State<AloChatLogin> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                LoginCubit loginCubit = BlocProvider.of<LoginCubit>(context);
                return Form(
                  key: loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChatTextFormField(
                        hintText: 'Email',
                        icon: FontAwesomeIcons.at,
                        controller: loginCubit.emailController,
                        validator: loginCubit.emailValidator,
                        focusNode: loginCubit.signUpEmailFocusNode,
                        onTapOutside: (event) =>
                            loginCubit.signUpEmailFocusNode.unfocus(),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ChatTextFormField(
                        hintText: 'Password',
                        icon: FontAwesomeIcons.lock,
                        controller: loginCubit.passwordController,
                        validator: loginCubit.passwordValidator,
                        focusNode: loginCubit.signUpPasswordFocusNode,
                        onTapOutside: (event) =>
                            loginCubit.signUpPasswordFocusNode.unfocus(),
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
                                        const AloChatSignUp())),
                            child: const Text(
                              "Don't have an account? Sign Up",
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
                        buttonText: 'login',
                        onPressed: () async {
                          if (loginFormKey.currentState!.validate()) {
                            loginFormKey.currentState!.save();
                            await loginCubit.loginUser(
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
    );
  }
}
