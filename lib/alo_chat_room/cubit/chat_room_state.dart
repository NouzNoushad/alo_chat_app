part of 'chat_room_cubit.dart';

@immutable
abstract class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class TextChanged extends ChatRoomState{}

class ShowReferenceMessage extends ChatRoomState{}

class CancelReplyMessage extends ChatRoomState{}

class SendReplyMessage extends ChatRoomState{}

class DisplayDeleteIcon extends ChatRoomState{}

class DeleteMessage extends ChatRoomState{}

class RecordTimerState extends ChatRoomState{}

class AudioLoadingState extends ChatRoomState{}