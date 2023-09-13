import 'dart:io';

import 'package:alo_chat_app/core/constants.dart';
import 'package:alo_chat_app/model/chat_room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../model/message_model.dart';

class ChatRoomService {
  sendMessage(
    String senderUid,
    String senderName,
    String message,
    ChatRoomModel chatRoom,
    String isReply,
    String refMessage,
    String refName,
    String refId,
    int refIndex,
    String file,
    String fileName,
  ) async {
    String fileUrl = "";
    if (file == "") {
      fileUrl = "";
    } else {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('messagePic')
          .child(const Uuid().v1())
          .putFile(File(file));
      fileUrl = await snapshot.ref.getDownloadURL();
    }
    MessageModel messageModel = MessageModel(
        senderUid: senderUid,
        senderName: senderName,
        message: message,
        messageId: const Uuid().v1(),
        createdOn: DateTime.now(),
        isReply: isReply,
        refMessage: refMessage,
        refName: refName,
        refId: refId,
        refIndex: refIndex,
        file: fileUrl,
        lastSeen: false,
        fileName: fileName);

    FirebaseFirestore.instance
        .collection(chatRoomDbName)
        .doc(chatRoom.chatRoomId)
        .collection(messageDbName)
        .doc(messageModel.messageId)
        .set(messageModelToMap(messageModel))
        .then((value) {
      print('Message send');
    });

    chatRoom.lastMessage = message;
    chatRoom.seen ++;
    chatRoom.fromId = senderUid;
    chatRoom.createdOn = DateTime.now();

    FirebaseFirestore.instance
        .collection(chatRoomDbName)
        .doc(chatRoom.chatRoomId)
        .set(chatRoomModelToMap(chatRoom))
        .then((value) {
      print('Set last Message');
    });
  }

  updateSeenMessage(ChatRoomModel chatRoom) {
    chatRoom.seen = 0;
    chatRoom.fromId = '';
    FirebaseFirestore.instance
        .collection(chatRoomDbName)
        .doc(chatRoom.chatRoomId)
        .set(chatRoomModelToMap(chatRoom))
        .then((value) {
      print('Set last seen Message');
    });
  }

  updateLastSeenMessage(MessageModel messageModel, ChatRoomModel chatRoom) {
    messageModel.lastSeen = true;
    FirebaseFirestore.instance
        .collection(chatRoomDbName)
        .doc(chatRoom.chatRoomId)
        .collection(messageDbName)
        .doc(messageModel.messageId)
        .set(messageModelToMap(messageModel))
        .then((value) {
      print('Message updated');
    });
  }

  deleteMessage(ChatRoomModel chatRoom, String messageId) {
    FirebaseFirestore.instance
        .collection(chatRoomDbName)
        .doc(chatRoom.chatRoomId)
        .collection(messageDbName)
        .doc(messageId)
        .delete()
        .then((value) {
      print('Message deleted');
    });
  }
}
