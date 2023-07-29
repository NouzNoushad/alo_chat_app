import 'package:alo_chat_app/core/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants.dart';
import '../../model/chat_room_model.dart';
import '../../model/user_model.dart';

class AloChatsService {
  SharedPreferencesHelper helper = SharedPreferencesHelper();
  ChatRoomModel? chatRoom;

  Future<UserModel> getUserModelById(uid) async {
    UserModel? userModel;
    var userById =
        await FirebaseFirestore.instance.collection(dbName).doc(uid).get();
    if (userById.data() != null) {
      userModel = userModelFromMap(userById.data()!);
    }
    print('//////////////////// uid $uid, userModel ${userModel!.email}');
    return userModel;
  }

  String fetchParticipants(snapshot, user) {
    Map<String, dynamic> chatRoomSnapshot = snapshot.data();
    chatRoom = chatRoomModelFromMap(chatRoomSnapshot);
    List<String> participantsKey = chatRoom!.participants.keys.toList();
    participantsKey.remove(user?.uid);
    print('////////////////${participantsKey[0]}');
    return participantsKey[0];
  }

  Future<ChatRoomModel?> getChatRoomModel(
      UserModel targetUser, UserModel user) async {
    ChatRoomModel? chatRoomModel;
    print('/////////////////////// TargetUser, ${targetUser.uid}');
    print('/////////////////////// SavedUser, ${user.uid}');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(chatRoomDbName)
        .where('participants.${user.uid}', isEqualTo: true)
        .where('participants.${targetUser.uid}', isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var chatRoomData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoomModel =
          chatRoomModelFromMap(chatRoomData as Map<String, dynamic>);
      chatRoomModel = existingChatRoomModel;
      print('Chat room already created');
    } else {
      ChatRoomModel newChatRoomModel = ChatRoomModel(
          chatRoomId: const Uuid().v1(),
          participants: {
            user.uid.toString(): true,
            targetUser.uid.toString(): true
          },
          lastMessage: '',
          createdOn: DateTime.now());

      await FirebaseFirestore.instance
          .collection(chatRoomDbName)
          .doc(newChatRoomModel.chatRoomId)
          .set(chatRoomModelToMap(newChatRoomModel))
          .then((value) {
        chatRoomModel = newChatRoomModel;
        print('new chat room created');
      }).catchError((err) {
        print('something went wrong');
      });
    }
    return chatRoomModel;
  }

  Future<List<UserModel>> searchAllChats(query) async {
    String? savedEmail = await helper.getEmail();
    QuerySnapshot<Map<String, dynamic>> users =
        await FirebaseFirestore.instance.collection(dbName).get();
    List<UserModel> searchUsers = users.docs
        .map((user) => userModelFromMap(user.data()))
        .where((user) =>
            user.nickName.contains(query) || user.phoneNo.contains(query))
        .toList();
    searchUsers.removeWhere((user) => user.email == savedEmail);
    return searchUsers;
  }

  Future<List<UserModel>> searchChats(query, user) async {
    List<UserModel> chatList = [];
    QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseFirestore
        .instance
        .collection(chatRoomDbName)
        .where('participants.${user?.uid}', isEqualTo: true)
        .get();
    for (var snapshot in snapshots.docs) {
      print('////////////////////// snapshot $snapshot');
      String participant = fetchParticipants(snapshot, user);
      UserModel userModel = await getUserModelById(participant);
      chatList.add(userModel);
    }
    print('////////////////////// chatList $chatList');
    List<UserModel> searchChat = chatList
        .where((user) =>
            user.nickName.contains(query) || user.phoneNo.contains(query))
        .toList();
    print('////////////////////// searchList $searchChat');
    return searchChat;
  }

  getChats(user) {
    var participants = FirebaseFirestore.instance
        .collection(chatRoomDbName)
        .where('participants.${user?.uid}', isEqualTo: true)
        .get();
    print('/////////////////////////// participants: $participants');
  }

  String formatDateTime(createdOn, chatType) {
    int now = DateTime.now().day;
    int statusDay = int.parse(DateFormat.d().format(createdOn));
    String time = DateFormat.jm().format(createdOn);
    if (statusDay == now) {
      return chatType == ChatType.chat ? time : 'Today $time';
    } else if (statusDay == now - 1) {
      return chatType == ChatType.chat ? 'Yesterday' : 'Yesterday $time';
    } else {
      return chatType == ChatType.chat
          ? DateFormat.yMMMMd().format(createdOn)
          : DateFormat.yMMMMd().add_jm().format(createdOn);
    }

    // for(int k = 0 ; k<snapshot.documents.length; k++){
    //         dynamic  stotyTime;
    //         dynamic timeDifference = DateTime.now().difference(DateTime.parse((snapshot.documents[k].data['StatusTime']))).inHours;
    //         if(timeDifference >= 1){
    //           stotyTime = timeDifference.toString()+" hours ago";
    //          }else{
    //            stotyTime = DateTime.now().difference(DateTime.parse((snapshot.documents[k].data['StatusTime']))).inMinutes;
    //          if(stotyTime>=1 ){
    //            stotyTime = stotyTime.toString()+" minutes ago";
    //           }else{
    //             stotyTime = "Just now";
    //           }
    //          }
    //         if(timeDifference < 24){
    //           baseModel.add(
    //             BaseModel( //0
    //               storyData: snapshot.documents[k].data['StatusData'],
    //               colorData: Colors.teal,//
    //               storyDate: stotyTime
    //               storyType: snapshot.documents[k].data['DataType'],
    //               //(DateFormat('dd-MM-yyyy hh:mm a').format(snapshot.documents[k].data['StatusTime'].toDate())).toString().split(" ")[1]
    //             ),
    //           );
    //         }else{
    //         Fluttertoast.showToast(msg: "above 24 hours$k");
    //         }
    //       }
  }
}
