import 'package:alo_chat_app/alo_chat_room/cubit/chat_room_cubit.dart';
import 'package:alo_chat_app/alo_chat_room/service/chat_room_service.dart';
import 'package:alo_chat_app/alo_chats/cubit/alo_chats_cubit.dart';
import 'package:alo_chat_app/alo_chats/service/alo_chats_service.dart';
import 'package:alo_chat_app/alo_status/cubit/alo_status_cubit.dart';
import 'package:alo_chat_app/alo_status/service/alo_status_service.dart';
import 'package:alo_chat_app/complete_profile/cubit/complete_profile_cubit.dart';
import 'package:alo_chat_app/complete_profile/service/complete_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'alo_home/cubit/alo_home_cubit.dart';
import 'alo_home/service/alo_home_service.dart';
import 'core/colors.dart';
import 'login/cubit/login_cubit.dart';
import 'login/screen/login_screen.dart';
import 'login/service/login_service.dart';
import 'sign_up/cubit/sign_up_cubit.dart';
import 'sign_up/service/sign_up_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignUpCubit(signUpService: SignUpService()),
        ),
        BlocProvider(
          create: (context) => LoginCubit(loginService: LoginService()),
        ),
        BlocProvider(
          create: (context) => AloHomeCubit(aloHomeService: AloHomeService()),
        ),
        BlocProvider(
          create: (context) => CompleteProfileCubit(
              completeProfileService: CompleteProfileService()),
        ),
        BlocProvider(
          create: (context) =>
              AloChatsCubit(aloChatsService: AloChatsService()),
        ),
        BlocProvider(
          create: (context) =>
              ChatRoomCubit(chatRoomService: ChatRoomService()),
        ),
        BlocProvider(
          create: (context) =>
              AloStatusCubit(aloStatusService: AloStatusService()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: CustomColors.primarySwatch,
        ),
        debugShowCheckedModeBanner: false,
        // home: CompleteProfile(
        //   profileType: ProfileType.complete,
        //   userModel: UserModel(
        //       uid: '',
        //       nickName: '',
        //       fullName: '',
        //       email: '',
        //       phoneNo: '',
        //       profilePic: '',
        //       about: ''),
        // ),
        home: const AloChatLogin(),
      ),
    );
  }
}
