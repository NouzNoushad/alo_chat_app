import 'package:alo_chat_app/alo_chats/cubit/alo_chats_cubit.dart';
import 'package:alo_chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../alo_chat_room/screens/alo_chat_room.dart';
import '../../alo_home/cubit/alo_home_cubit.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../widgets/loading_indicator.dart';
import 'chat_search_delegate.dart';
import 'chats_list_container.dart';

class AloChats extends StatefulWidget {
  const AloChats({super.key});

  @override
  State<AloChats> createState() => _AloChatsState();
}

class _AloChatsState extends State<AloChats> {
  late AloChatsCubit aloChatsCubit;

  @override
  void initState() {
    print('init chat');
    aloChatsCubit = BlocProvider.of<AloChatsCubit>(context);
    aloChatsCubit.getUserModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgroundColor2,
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.backgroundColor1,
          onPressed: () {
            showSearch(
                context: context,
                delegate:
                    AloChatSearchDelegate(searchType: SearchType.allChats));
          },
          child: const Icon(
            Icons.message_rounded,
            color: CustomColors.backgroundColor2,
            size: 25,
          ),
        ),
        body: BlocBuilder<AloChatsCubit, AloChatsState>(
            builder: (context, state) {
          AloHomeCubit aloHomeCubit = BlocProvider.of<AloHomeCubit>(context);
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(chatRoomDbName)
                  .where('participants.${aloChatsCubit.user?.uid}',
                      isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    itemBuilder: (context, index) {
                      String participant = aloChatsCubit
                          .fetchParticipants(snapshot.data!.docs[index]);
                      return FutureBuilder<UserModel>(
                          future: aloChatsCubit.getUserModelById(participant),
                          builder: (context, userData) {
                            if (userData.hasData) {
                              UserModel userModel = userData.data as UserModel;
                              print('////////////////////${userModel.email}');
                              return InkWell(
                                onLongPress: () {
                                  aloHomeCubit.popUpDeletedIcon(
                                      aloChatsCubit.chatRoom!);
                                },
                                child: ChatsListContainer(
                                  imageUrl: userModel.profilePic,
                                  userName: userModel.nickName,
                                  aboutStatus: aloChatsCubit
                                          .chatRoom?.lastMessage
                                          .toString() ??
                                      '',
                                  createdOn: aloChatsCubit.formatDateTime(
                                      aloChatsCubit.chatRoom?.createdOn,
                                      ChatType.chat),
                                  backgroundColor:
                                      CustomColors.backgroundColor2,
                                  radius: 30,
                                  seenWidget: aloChatsCubit.chatRoom?.fromId == aloChatsCubit.user?.uid ? Container() : aloChatsCubit.chatRoom?.seen ??
                                          false
                                      ? Container()
                                      : const Icon(
                                          Icons.error,
                                          color: CustomColors.backgroundColor1,
                                          size: 25,
                                        ),
                                  onTap: () {
                                    var navigator = Navigator.of(context);
                                    navigator.push(MaterialPageRoute(
                                        builder: (context) => AloChatRoom(
                                              targetUser: userModel,
                                              userModel: aloChatsCubit.user!,
                                              chatRoom: aloChatsCubit.chatRoom!,
                                            )));
                                  },
                                ),
                              );
                            }
                            return Container();
                          });
                    },
                  );
                }
                return const CustomLoadingIndicator();
              });
        }));
  }
}
