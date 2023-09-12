import 'package:alo_chat_app/alo_chat_room/cubit/chat_room_cubit.dart';
import 'package:alo_chat_app/alo_chat_room/screens/audio_container.dart';
import 'package:alo_chat_app/alo_chat_room/screens/image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../core/colors.dart';
import '../../model/user_model.dart';
import '../../widgets/chat_bubble.dart';

class ChatRoomListItem extends StatefulWidget {
  final int index;
  final dynamic element;
  final UserModel userModel;
  final ChatRoomCubit chatRoomCubit;
  const ChatRoomListItem(
      {super.key,
      required this.index,
      required this.element,
      required this.userModel,
      required this.chatRoomCubit});

  @override
  State<ChatRoomListItem> createState() => _ChatRoomListItemState();
}

class _ChatRoomListItemState extends State<ChatRoomListItem> {
  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: () {
        widget.chatRoomCubit.messageFocusNode.requestFocus();
        widget.chatRoomCubit.isReply = true;
        widget.chatRoomCubit.showReferenceMessage(
            widget.element['sender_name'],
            widget.element['message'],
            widget.element['message_id'],
            widget.index);
      },
      child: Align(
        alignment: widget.element['sender_uid'] == widget.userModel.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 10, bottom: 5, right: 10, top: 5),
          child: CustomPaint(
            painter: ChatBubble(
              color: widget.element['sender_uid'] == widget.userModel.uid
                  ? CustomColors
                      .backgroundLightColor // Color.fromRGBO(223, 255, 201, 1)
                  : CustomColors.backgroundLightColor2,
              alignment: widget.element['sender_uid'] == widget.userModel.uid
                  ? Alignment.topRight
                  : Alignment.topLeft,
            ),
            child: Wrap(
              direction: Axis.vertical,
              children: [
                widget.element['is_reply'] == "false"
                    ? Container()
                    : Padding(
                        padding: widget.element['sender_uid'] ==
                                widget.userModel.uid
                            ? const EdgeInsets.only(left: 10, top: 6, right: 18)
                            : const EdgeInsets.only(
                                left: 18, top: 6, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            print('hellow');
                            widget.chatRoomCubit.itemScrollController.scrollTo(
                                index: widget.element['ref_index'],
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.element['sender_uid'] ==
                                            widget.userModel.uid
                                        ? CustomColors.purpleColor
                                        : CustomColors.greenColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8.0),
                                      topLeft: Radius.circular(8.0),
                                    ),
                                  ),
                                  width: 5.0,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.element['sender_uid'] ==
                                            widget.userModel.uid
                                        ? const Color.fromARGB(
                                            255, 247, 255, 237)
                                        : const Color.fromARGB(
                                            255, 243, 241, 226),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  constraints: BoxConstraints(
                                    minHeight: 40,
                                    minWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, left: 10, bottom: 6, right: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.element['sender_uid'] ==
                                                  widget.userModel.uid
                                              ? "You"
                                              : widget.element['ref_name'],
                                          style: TextStyle(
                                              color: widget.element[
                                                          'sender_uid'] ==
                                                      widget.userModel.uid
                                                  ? CustomColors.purpleColor
                                                  : CustomColors.greenColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          widget.element['ref_message'] ?? '',
                                          style: const TextStyle(
                                              color: CustomColors
                                                  .backgroundDarkColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                Container(
                  margin: widget.element['sender_uid'] == widget.userModel.uid
                      ? const EdgeInsets.only(
                          left: 10, top: 12, right: 18, bottom: 4)
                      : const EdgeInsets.only(
                          left: 18, top: 12, right: 10, bottom: 4),
                  alignment:
                      widget.element['sender_uid'] == widget.userModel.uid
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  child: Column(
                    crossAxisAlignment:
                        widget.element['sender_uid'] == widget.userModel.uid
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      widget.element['message'] != ""
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.element['message'] ?? "",
                                textAlign: widget.element['sender_uid'] ==
                                        widget.userModel.uid
                                    ? TextAlign.left
                                    : TextAlign.right,
                                // key: _messageKey,
                                style: const TextStyle(
                                    color: CustomColors.backgroundDarkColor),
                              ),
                            )
                          : Container(),
                      widget.element['file'] != ""
                          ? showFileAttachment(context, widget.element)
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                DateFormat.jm().format(
                                    widget.element['created_on'].toDate()),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: CustomColors.backgroundDarkColor,
                                    fontSize: 11),
                              ),
                            ),
                            widget.element['sender_uid'] == widget.userModel.uid
                                ? Icon(Icons.done_all,
                                    color: widget.element['last_seen']
                                        ? CustomColors.backgroundColor1
                                        : Colors.grey,
                                    size: 18)
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showFileAttachment(context, message) {
    if (message != null) {
      var fileType = message['file_name'].toString().substring(0, 5);
      return fileType == 'image'
          ? Container(
              height: 250,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: CustomColors.backgroundLightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImageViewer(
                            title: message['file_name'],
                            imageProvider: NetworkImage(message['file']),
                            loadingBuilder: (context, event) {
                              return Container(
                                  color: CustomColors.backgroundDarkColor,
                                  child: Center(
                                    child: Text(
                                      event == null
                                          ? "0%"
                                          : "${(100 * (event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? event.cumulativeBytesLoaded))).floor()}%",
                                      style: const TextStyle(
                                          color: CustomColors
                                              .backgroundLightColor2),
                                    ),
                                  ));
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(),
                          )));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: message['file'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(),
                  ),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: CustomColors.backgroundLightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(4),
              child: AudioContainer(filePath: message['file']),
            );
    }
  }
}
