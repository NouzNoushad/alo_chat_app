import 'package:alo_chat_app/alo_home/cubit/alo_home_cubit.dart';
import 'package:alo_chat_app/alo_status/screens/alo_status.dart';
import 'package:alo_chat_app/complete_profile/screens/complete_profile.dart';
import 'package:alo_chat_app/core/colors.dart';
import 'package:alo_chat_app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../alo_chats/screens/alo_chats.dart';
import '../../alo_chats/screens/chat_search_delegate.dart';
import '../../login/screen/login_screen.dart';
import '../../widgets/delete_button.dart';

class AloHomeScreen extends StatefulWidget {
  const AloHomeScreen({super.key});

  @override
  State<AloHomeScreen> createState() => _AloHomeScreenState();
}

class _AloHomeScreenState extends State<AloHomeScreen> {
  getWidgets(index) {
    switch (index) {
      case 0:
        return const AloChats();
      case 1:
        return const AloStatus();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocBuilder<AloHomeCubit, AloHomeState>(builder: (context, state) {
        AloHomeCubit aloHomeCubit = BlocProvider.of<AloHomeCubit>(context);
        return Scaffold(
          backgroundColor: CustomColors.backgroundColor2,
          appBar: AppBar(
            backgroundColor: CustomColors.backgroundColor1,
            automaticallyImplyLeading: false,
            leading: aloHomeCubit.popUpDelete
                ? GestureDetector(
                    onTap: () {
                      aloHomeCubit.cancelDeleteIcon();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: CustomColors.backgroundColor2,
                    ),
                  )
                : null,
            title: aloHomeCubit.popUpDelete
                ? Container()
                : const Text(
                    'AloChat',
                    style: TextStyle(
                      color: CustomColors.backgroundColor2,
                    ),
                  ),
            actions: aloHomeCubit.popUpDelete
                ? [
                    DeleteButton(
                      onPressed: () {
                        aloHomeCubit.deleteChats();
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ]
                : [
                    IconButton(
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: AloChatSearchDelegate(
                                searchType: SearchType.chats));
                      },
                      icon: const Icon(Icons.search_outlined),
                      color: CustomColors.backgroundColor2,
                    ),
                    chatPopupMenuButton(aloHomeCubit),
                  ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(35),
              child: TabBar(
                  indicatorColor: CustomColors.backgroundColor2,
                  labelColor: CustomColors.backgroundColor2,
                  unselectedLabelColor:
                      CustomColors.backgroundColor2.withOpacity(0.6),
                  labelPadding: const EdgeInsets.all(10),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: aloHomeCubit.onTapTabBar,
                  tabs: [
                    chatBottomTabs('Chats'),
                    chatBottomTabs('Status'),
                  ]),
            ),
          ),
          body: getWidgets(aloHomeCubit.selectedIndex),
        );
      }),
    );
  }

  Widget chatBottomTabs(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 16,
        ),
      );

  Widget chatPopupMenuButton(AloHomeCubit aloHomeCubit) =>
      PopupMenuButton<ChatMenu>(
          color: CustomColors.backgroundColor2,
          initialValue: aloHomeCubit.selectedMenu,
          onSelected: aloHomeCubit.onSelectedMenu,
          position: PopupMenuPosition.under,
          itemBuilder: (context) => <PopupMenuEntry<ChatMenu>>[
                PopupMenuItem<ChatMenu>(
                  value: ChatMenu.settings,
                  child: const Text(
                    'Settings',
                    style: TextStyle(color: CustomColors.backgroundDarkColor1),
                  ),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CompleteProfile(
                                profileType: ProfileType.update,
                              )));
                    });
                  },
                ),
                PopupMenuItem<ChatMenu>(
                  value: ChatMenu.logout,
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: CustomColors.backgroundDarkColor1),
                  ),
                  onTap: () {
                    print(
                        '/////////////////////////////=========================............logout');
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const AloChatLogin()));
                    });
                  },
                ),
              ]);
}
