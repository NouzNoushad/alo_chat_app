import 'package:alo_chat_app/alo_chats/cubit/alo_chats_cubit.dart';
import 'package:alo_chat_app/widgets/recent_updates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../alo_chat_room/screens/alo_chat_room.dart';
import '../../alo_status/screens/alo_status_story.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../model/chat_room_model.dart';
import 'chats_list_container.dart';

class ChatsList extends StatefulWidget {
  final List snapshot;
  final ChatType chatType;
  const ChatsList({super.key, required this.snapshot, required this.chatType});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  late AloChatsCubit aloChatsCubit;
  @override
  void initState() {
    aloChatsCubit = BlocProvider.of<AloChatsCubit>(context);
    aloChatsCubit.getUserModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.snapshot.length,
      separatorBuilder: (context, index) {
        if (widget.chatType == ChatType.status && index == 0) {
          return const StatusRecentUpdate();
        }
        return const SizedBox(
          height: 8,
        );
      },
      padding: widget.chatType == ChatType.search
          ? const EdgeInsets.symmetric(horizontal: 10, vertical: 20)
          : const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      itemBuilder: (context, index) {
        var user = widget.snapshot[index];
        return Padding(
          padding: widget.chatType == ChatType.search
              ? const EdgeInsets.symmetric(horizontal: 0, vertical: 0)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ChatsListContainer(
              imageUrl: widget.chatType == ChatType.search
                  ? user.profilePic
                  : user.profileImage,
              userName: widget.chatType == ChatType.search
                  ? user.nickName
                  : user.userName,
              aboutStatus: widget.chatType == ChatType.search
                  ? user.about
                  : aloChatsCubit.formatDateTime(
                      user.createdOn, ChatType.status),
              createdOn: '',
              seenWidget: Container(),
              radius: widget.chatType == ChatType.search ? 28 : 31.5,
              backgroundColor: widget.chatType == ChatType.search
                  ? CustomColors.backgroundColor2
                  : CustomColors.backgroundColor1,
              onTap: widget.chatType == ChatType.search
                  ? () async {
                      var navigator = Navigator.of(context);
                      ChatRoomModel? chatRoom =
                          await aloChatsCubit.getChatRoomModel(user);
                      if (chatRoom!.chatRoomId.isNotEmpty) {
                        print(
                            '////////////////===>>>>>>>>>> userModel, ${aloChatsCubit.user!.fullName}');
                        navigator.push(MaterialPageRoute(
                            builder: (context) => AloChatRoom(
                                  targetUser: user,
                                  userModel: aloChatsCubit.user!,
                                  chatRoom: chatRoom,
                                )));
                      }
                    }
                  : () {
                      var navigator = Navigator.of(context);
                      navigator.push(MaterialPageRoute(
                          builder: (context) =>
                              AloStatusStory(statusModel: user)));
                    }),
        );
      },
    );
  }
}
