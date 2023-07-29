import 'dart:async';
import 'package:alo_chat_app/alo_chats/service/alo_chats_service.dart';
import 'package:alo_chat_app/alo_chats/service/user_service.dart';
import 'package:alo_chat_app/model/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../model/chat_room_model.dart';

part 'alo_chats_state.dart';

class AloChatsCubit extends Cubit<AloChatsState> {
  final AloChatsService aloChatsService;
  AloChatsCubit({required this.aloChatsService}) : super(AloChatsInitial());

  StreamController searchAllChatController = StreamController.broadcast();
  Stream get searchAllChatStream => searchAllChatController.stream;
  StreamSink get searchAllChatSink => searchAllChatController.sink;

  UserService userService = UserService();

  UserModel? user;
  ChatRoomModel? chatRoom;

  getUserModel() async {
    user = await userService.getUserDetails();
    emit(GetUserData());
  }

  Future<UserModel> getUserModelById(uid) async {
    return await aloChatsService.getUserModelById(uid);
  }

  String fetchParticipants(snapshot) {
    String participant = aloChatsService.fetchParticipants(snapshot, user);
    chatRoom = aloChatsService.chatRoom;
    return participant;
  }

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    UserModel user = await userService.getUserDetails();
    return await aloChatsService.getChatRoomModel(targetUser, user);
  }

  searchAllChats(query) async {
    List<UserModel> searchUser = await aloChatsService.searchAllChats(query);
    searchAllChatSink.add(searchUser);
  }

  Future<List<UserModel>> searchChats(query) async {
    UserModel user = await userService.getUserDetails();
    List<UserModel> searchChat = await aloChatsService.searchChats(query, user);
    return searchChat;
  }

  String formatDateTime(createdOn, chatType) {
    return aloChatsService.formatDateTime(createdOn, chatType);
  }
}
