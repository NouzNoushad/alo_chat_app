Map<String, dynamic> messageModelToMap(MessageModel data) => data.toMap();

class MessageModel {
  String senderUid;
  String senderName;
  String message;
  String messageId;
  DateTime createdOn;
  String isReply;
  String refMessage;
  String refName;
  int refIndex;
  String file;
  String fileName;
  String refId;

  MessageModel({
    required this.senderUid,
    required this.senderName,
    required this.message,
    required this.messageId,
    required this.createdOn,
    required this.isReply,
    required this.refMessage,
    required this.refName,
    required this.refIndex,
    required this.file,
    required this.fileName,
    required this.refId,
  });

  Map<String, dynamic> toMap() => {
        "sender_uid": senderUid,
        "sender_name": senderName,
        "message": message,
        "message_id": messageId,
        "created_on": createdOn,
        "is_reply": isReply,
        "ref_message": refMessage,
        "ref_name": refName,
        "ref_id": refId,
        "ref_index": refIndex,
        "file": file,
        "file_name": fileName,
      };
}
