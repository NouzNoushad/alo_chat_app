import 'package:alo_chat_app/core/constants.dart';
import 'package:alo_chat_app/core/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../model/chat_room_model.dart';
import '../service/alo_home_service.dart';

part 'alo_home_state.dart';

class AloHomeCubit extends Cubit<AloHomeState> {
  final AloHomeService aloHomeService;
  AloHomeCubit({required this.aloHomeService}) : super(AloHomeInitial());
  int selectedIndex = 0;
  ChatMenu? selectedMenu;
  bool popUpDelete = false;
  ChatRoomModel? chatRoom;

  onTapTabBar(index) {
    selectedIndex = index;
    emit(ChangeTabs());
  }

  onSelectedMenu(value) {
    selectedMenu = value;
    emit(SelectMenuState());
  }

  popUpDeletedIcon(ChatRoomModel chatRoomModel) {
    popUpDelete = true;
    chatRoom = chatRoomModel;
    print(
        '/////////////////////////////////////////////// popup delete: $popUpDelete');
    emit(DeleteIconState());
  }

  cancelDeleteIcon() {
    popUpDelete = false;
    emit(DeleteIconState());
  }

  deleteChats() async {
    print(
        '/////////////////////////////////////////////// popup delete: ${chatRoom!.chatRoomId}');
    await aloHomeService.deleteChats(chatRoom!);
  }

  logoutUser(context) async {
    SharedPreferencesHelper helper = SharedPreferencesHelper();
    helper.clearSharedPreferences();
  }
}
