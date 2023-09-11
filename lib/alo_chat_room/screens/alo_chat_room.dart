import 'package:alo_chat_app/alo_chat_room/cubit/chat_room_cubit.dart';
import 'package:alo_chat_app/alo_chat_room/screens/chat_room_list.dart';
import 'package:alo_chat_app/core/colors.dart';
import 'package:alo_chat_app/model/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../complete_profile/screens/profile_photo.dart';
import '../../model/chat_room_model.dart';
import '../../widgets/delete_button.dart';
import 'record_audio.dart';

class AloChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final UserModel userModel;
  final ChatRoomModel chatRoom;
  const AloChatRoom(
      {super.key,
      required this.targetUser,
      required this.userModel,
      required this.chatRoom});

  @override
  State<AloChatRoom> createState() => _AloChatRoomState();
}

class _AloChatRoomState extends State<AloChatRoom> {
  late ChatRoomCubit chatRoomCubit;
  @override
  void initState() {
    chatRoomCubit = BlocProvider.of<ChatRoomCubit>(context);
    chatRoomCubit.typing = false;
    super.initState();
  }

  @override
  void dispose() {
    chatRoomCubit.messageController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.chatRoom.seen) {
      chatRoomCubit.updateSeenMessage(widget.chatRoom);
    }
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: WillPopScope(
        onWillPop: () async {
          if (chatRoomCubit.showDeleteIcon) {
            Fluttertoast.showToast(
                msg: 'Cancel delete: click top left back arrow',
                backgroundColor: CustomColors.whiteColor,
                textColor: CustomColors.backgroundColor1);
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<ChatRoomCubit, ChatRoomState>(
                builder: (context, state) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    color: CustomColors.backgroundColor1,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: chatRoomCubit.showDeleteIcon
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    chatRoomCubit.disableDeleteIcon(),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: CustomColors.backgroundColor2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: DeleteButton(
                                  onPressed: () {
                                    chatRoomCubit.deleteMessage(widget.chatRoom,
                                        chatRoomCubit.messageId);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          )
                        : Row(children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: CustomColors.backgroundColor2,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.targetUser.profilePic,
                                      height: 50,
                                      width: 50,
                                      placeholder: (context, url) =>
                                          Container(),
                                      errorWidget: (context, url, error) =>
                                          Container(),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.targetUser.nickName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.backgroundColor2),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                  );
                },
              ),
              Expanded(
                child: Column(children: [
                  Expanded(
                    child: ChatRoomList(
                      userModel: widget.userModel,
                      chatRoom: widget.chatRoom,
                    ),
                  ),
                  BlocBuilder<ChatRoomCubit, ChatRoomState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CustomColors.backgroundColor1,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      chatRoomCubit.isReply == true
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.only(top: 6),
                                              decoration: BoxDecoration(
                                                color: CustomColors
                                                    .backgroundLightColor2,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: CustomColors
                                                            .greenColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                            30.0,
                                                          ),
                                                          topLeft:
                                                              Radius.circular(
                                                            30.0,
                                                          ),
                                                        ),
                                                      ),
                                                      width: 7.0,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              chatRoomCubit
                                                                          .refName ==
                                                                      widget
                                                                          .userModel
                                                                          .nickName
                                                                  ? "You"
                                                                  : chatRoomCubit
                                                                      .refName,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15,
                                                                color: CustomColors
                                                                    .greenColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              chatRoomCubit
                                                                  .refMessage,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                        onTap: () => chatRoomCubit
                                                            .cancelReplyMessage(),
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: const Icon(
                                                              Icons.close,
                                                              size: 14),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller: chatRoomCubit
                                                  .messageController,
                                              focusNode: chatRoomCubit
                                                  .messageFocusNode,
                                              style: const TextStyle(
                                                color: CustomColors
                                                    .backgroundColor2,
                                              ),
                                              maxLines: null,
                                              cursorColor:
                                                  CustomColors.backgroundColor2,
                                              onChanged: (value) =>
                                                  chatRoomCubit.onTextChanged(),
                                              decoration: const InputDecoration(
                                                hintText: 'Message',
                                                hintStyle: TextStyle(
                                                    color: CustomColors
                                                        .backgroundColor2),
                                                contentPadding: EdgeInsets.zero,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showUploadFileBottomSheet(
                                                  context,
                                                  chatRoomCubit,
                                                  widget.userModel,
                                                  widget.chatRoom);
                                            },
                                            icon: const Icon(Icons.attach_file),
                                            color:
                                                CustomColors.backgroundColor2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              chatRoomCubit.typing
                                  ? GestureDetector(
                                      onTap: () {
                                        bool isReply = chatRoomCubit.isReply;
                                        String refMessage = isReply
                                            ? chatRoomCubit.refMessage
                                            : "";
                                        String refName = isReply
                                            ? chatRoomCubit.refName
                                            : "";
                                        String refId =
                                            isReply ? chatRoomCubit.refId : "";
                                        int refIndex = isReply
                                            ? chatRoomCubit.refIndex
                                            : -1;
                                        chatRoomCubit.sendMessage(
                                            widget.userModel,
                                            widget.chatRoom,
                                            isReply,
                                            refMessage,
                                            refName,
                                            refId,
                                            refIndex,
                                            "",
                                            "");
                                      },
                                      child: const CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            CustomColors.backgroundColor1,
                                        child: Icon(
                                          Icons.send,
                                          color: CustomColors.backgroundColor2,
                                        ),
                                      ),
                                    )
                                  : RecordAudio(
                                      chatRoomCubit: chatRoomCubit,
                                      sender: widget.userModel,
                                      chatRoom: widget.chatRoom,
                                    )
                            ]),
                      );
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showUploadFileBottomSheet(context, ChatRoomCubit chatRoomCubit,
      UserModel userModel, ChatRoomModel chatRoom) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            color: CustomColors.backgroundColor2,
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ProfilePhoto(
                  title: 'Camera',
                  icon: Icons.photo_camera,
                  radius: 30,
                  onTap: () => {
                    chatRoomCubit.showFilePicker(
                        ImageSource.camera, userModel, chatRoom),
                    Navigator.pop(context)
                  },
                ),
                ProfilePhoto(
                  title: 'Gallery',
                  icon: Icons.image,
                  radius: 30,
                  onTap: () => {
                    chatRoomCubit.showFilePicker(
                        ImageSource.gallery, userModel, chatRoom),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }
}
