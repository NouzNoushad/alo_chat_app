ChatRoomModel chatRoomModelFromMap(Map<String, dynamic> data) =>
    ChatRoomModel.fromMap(data);

Map<String, dynamic> chatRoomModelToMap(ChatRoomModel data) => data.toMap();

class ChatRoomModel {
  String chatRoomId;
  Map<String, dynamic> participants;
  String lastMessage;
  DateTime createdOn;

  ChatRoomModel({
    required this.chatRoomId,
    required this.participants,
    required this.lastMessage,
    required this.createdOn,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> json) => ChatRoomModel(
        chatRoomId: json["chat_room_id"],
        participants: json["participants"],
        lastMessage: json["last_message"],
        createdOn: json["created_on"].toDate(),
      );

  Map<String, dynamic> toMap() => {
        "chat_room_id": chatRoomId,
        "participants": participants,
        "last_message": lastMessage,
        "created_on": createdOn,
      };
}
