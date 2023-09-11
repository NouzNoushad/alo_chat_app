import 'package:alo_chat_app/alo_chat_room/cubit/chat_room_cubit.dart';
import 'package:alo_chat_app/alo_chat_room/screens/room_list_item.dart';
import 'package:alo_chat_app/core/colors.dart';
import 'package:alo_chat_app/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:intl/intl.dart';

import '../../model/chat_room_model.dart';
import '../../model/user_model.dart';

class ChatRoomList extends StatefulWidget {
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  const ChatRoomList(
      {super.key, required this.chatRoom, required this.userModel});

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(chatRoomDbName)
            .doc(widget.chatRoom.chatRoomId)
            .collection(messageDbName)
            .orderBy('created_on', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot chatSnapshot = snapshot.data as QuerySnapshot;
              return BlocBuilder<ChatRoomCubit, ChatRoomState>(
                builder: (context, state) {
                  var chatRoomCubit = BlocProvider.of<ChatRoomCubit>(context);
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: StickyGroupedListView(
                          elements: chatSnapshot.docs.reversed.toList(),
                          groupBy: (element) => DateFormat.yMMMMd()
                              .format(element['created_on'].toDate()),
                          groupSeparatorBuilder: (element) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1,
                                vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1,
                                  color: CustomColors.backgroundColor),
                              color: CustomColors.backgroundLightColor2,
                            ),
                            child: Text(
                              DateFormat.yMMMMd()
                                  .format(element['created_on'].toDate()),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: CustomColors.backgroundDarkColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          order: StickyGroupedListOrder.DESC,
                          reverse: true,
                          shrinkWrap: true,
                          floatingHeader: true,
                          padding: EdgeInsets.zero,
                          stickyHeaderBackgroundColor: Colors.transparent,
                          itemScrollController:
                              chatRoomCubit.itemScrollController,
                          itemPositionsListener:
                              chatRoomCubit.itemPositionsListener,
                          indexedItemBuilder: (context, element, index) {
                            return InkWell(
                              overlayColor: MaterialStateProperty.all(
                                  const Color.fromARGB(76, 134, 43, 13)),
                              onLongPress: () {
                                chatRoomCubit
                                    .displayDeleteIcon(element['message_id']);
                              },
                              child: ChatRoomListItem(
                                index: index,
                                element: element,
                                userModel: widget.userModel,
                                chatRoomCubit: chatRoomCubit,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            chatRoomCubit.itemScrollController.scrollTo(
                                index: 0,
                                alignment: 30,
                                duration: const Duration(milliseconds: 200));
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white70,
                            radius: 17,
                            child: Icon(
                              Icons.keyboard_double_arrow_down,
                              color: Colors.grey.shade400,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('No Internet Connection'),
              );
            } else {
              return const Center(
                child: Text('Say hai to your new friend'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
