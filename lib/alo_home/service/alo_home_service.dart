import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../model/chat_room_model.dart';

class AloHomeService {
  deleteChats(ChatRoomModel chatRoom) {
    FirebaseFirestore.instance
        .collection(chatRoomDbName)
        .doc(chatRoom.chatRoomId)
        .delete()
        .then((value) {
      print('Chat deleted');
      Fluttertoast.showToast(
          msg: 'Chat deleted',
          backgroundColor: CustomColors.whiteColor,
          textColor: CustomColors.backgroundColor1);
    });
  }
}
