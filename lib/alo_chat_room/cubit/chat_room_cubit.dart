import 'dart:async';
import 'dart:io';

import 'package:alo_chat_app/alo_chat_room/service/chat_room_service.dart';
import 'package:alo_chat_app/model/chat_room_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../core/colors.dart';
import '../../model/audios.dart';
import '../../model/message_model.dart';
import '../../model/user_model.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRoomService chatRoomService;
  ChatRoomCubit({required this.chatRoomService}) : super(ChatRoomInitial());
  final GroupedItemScrollController itemScrollController =
      GroupedItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  TextEditingController messageController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();
  bool typing = false;
  bool isReply = false;
  String refMessage = "";
  String refName = "";
  String refId = "";
  String messageId = "";
  int refIndex = -1;
  bool showDeleteIcon = false;

  // Record
  DateTime? startTime;
  Timer? timer;
  String recordDuration = '00:00';

  // Audio
  final player = AudioPlayer();
  Duration? duration;
  bool audioLoading = false;

  initPlayer(filePath) async {
    print(
        '/////////////////======================>>>>>>>>>>>>>>>>>>>>>>>>> FilePath: $filePath');
    try {
      Duration? audioDuration = await player
          .setAudioSource(AudioSource.uri(Uri.parse(filePath)), preload: false);
      print('audio Duration: $duration');
      duration = audioDuration;
    } on Exception catch (err) {
      print('///////////////// Error: $err');
    }
  }

  onTextChanged() {
    if (messageController.text.isEmpty) {
      typing = false;
      emit(TextChanged());
    } else {
      typing = true;
      emit(TextChanged());
    }
  }

  showFilePicker(
      ImageSource source, UserModel sender, ChatRoomModel chatRoom) async {
    ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: source);
    if (file != null) {
      String filePath = file.path;
      String fileName = 'image_${filePath.split('/').last}';
      sendFile(sender, chatRoom, filePath, fileName);
    }
  }

  sendFile(UserModel sender, ChatRoomModel chatRoom, String file,
      String fileName) async {
    String senderUid = sender.uid;
    String senderName = sender.nickName;
    String onRightSwap = isReply ? "true" : "false";
    print('//////////////////////////// File Path, $fileName');
    await chatRoomService.sendMessage(senderUid, senderName, '', chatRoom,
        onRightSwap, '', '', '', -1, file, fileName);
  }

  updateSeenMessage(ChatRoomModel chatRoom) async {
    await chatRoomService.updateSeenMessage(chatRoom);
  }

  updateLastSeenMessage(
      QueryDocumentSnapshot message, ChatRoomModel chatRoom) async {
    Map<String, dynamic> messageMap = message.data() as Map<String, dynamic>;
    MessageModel messageModel = messageModelFromMap(messageMap);
    await chatRoomService.updateLastSeenMessage(messageModel, chatRoom);
  }

  sendMessage(
      UserModel sender,
      ChatRoomModel chatRoom,
      bool onRightSwap,
      String refMessage,
      String refName,
      String refId,
      int refIndex,
      String file,
      String fileName) async {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      messageController.clear();
      messageFocusNode.unfocus();
      String isReply = onRightSwap ? "true" : "false";
      String senderUid = sender.uid;
      String senderName = sender.nickName;
      await chatRoomService.sendMessage(
        senderUid,
        senderName,
        message,
        chatRoom,
        isReply,
        refMessage,
        refName,
        refId,
        refIndex,
        file,
        fileName,
      );
    }

    isReply = false;
    typing = false;

    emit(SendReplyMessage());
  }

  deleteMessage(
    ChatRoomModel chatRoom,
    String messageId,
  ) async {
    if (messageId != "") {
      await chatRoomService.deleteMessage(chatRoom, messageId);
      showDeleteIcon = false;
      emit(DeleteMessage());
    }
  }

  showReferenceMessage(String name, String message, String uid, int index) {
    refName = name;
    refMessage = message;
    refId = uid;
    refIndex = index;
    emit(ShowReferenceMessage());
  }

  getReferenceMessageIndex(element) {}

  cancelReplyMessage() {
    isReply = false;
    emit(CancelReplyMessage());
  }

  displayDeleteIcon(String msgId) {
    showDeleteIcon = true;
    messageId = msgId;
    print('////////////////// showDeleteIcon: $showDeleteIcon,, $messageId');
    emit(DisplayDeleteIcon());
  }

  disableDeleteIcon() {
    showDeleteIcon = false;
    emit(DisplayDeleteIcon());
  }

  recordOnLongPressDown(controller) {
    print('Long press down');
    controller.forward();
  }

  recordOnLongPress(controller) async {
    print('Long Pressed');
    var record = Record();
    if (await record.hasPermission()) {
      String path = (await getExternalStorageDirectory())!.path;
      print('////////////////========>>>>>>>>> record path, $path');
      await record.start(
        path: '$path/${DateTime.now().millisecondsSinceEpoch}.m4a',
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
      startTime = DateTime.now();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final minuteDuration = DateTime.now().difference(startTime!).inMinutes;
        final secondDuration =
            DateTime.now().difference(startTime!).inSeconds % 60;
        String minute = minuteDuration < 10
            ? '0$minuteDuration'
            : minuteDuration.toString();
        String second = secondDuration < 10
            ? '0$secondDuration'
            : secondDuration.toString();
        recordDuration = '$minute:$second';
        emit(RecordTimerState());
      });
    }
  }

  bool isCancelled(BuildContext context, Offset offset) {
    var size = MediaQuery.of(context).size.width * 0.2;
    return offset.dx < -size;
  }

  stopTimer() {
    timer?.cancel();
    timer = null;
    startTime = null;
    recordDuration = '00:00';
  }

  recordOnLongPressEnd(BuildContext context, AnimationController controller,
      LongPressEndDetails end, UserModel sender, ChatRoomModel chatRoom) async {
    print('Long Press End');
    if (isCancelled(context, end.localPosition)) {
      stopTimer();
      Timer(const Duration(milliseconds: 1400), () async {
        controller.reverse();
        String? filePath = await Record().stop();
        File(filePath!).delete();
        print(
            '///////////////////////////// ==......... filePath Deleted, $filePath');
        Fluttertoast.showToast(
            msg: "Audio record canceled",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: CustomColors.whiteColor,
            textColor: CustomColors.backgroundDarkColor,
            fontSize: 14.0);
      });
    } else {
      controller.reverse();
      stopTimer();
      String? filePath = await Record().stop();
      if (filePath != null) {
        showAudioLoading();
        Audios.files.add(filePath);
        String fileName = 'audio_${filePath.split('/').last}';
        print(
            '///////////////////////////// ==......... filePath, $filePath, fileName $fileName');
        Future.delayed(const Duration(seconds: 1), () {
          sendFile(sender, chatRoom, filePath, fileName);
          showAudioLoading();
        });
      }
    }
  }

  showAudioLoading() {
    audioLoading = !audioLoading;
    print(
        '///////////////////////////// ==.........>>>>>>>>>>>> audio loading, $audioLoading');
    emit(AudioLoadingState());
  }

  recordOnLongPressCancel(controller) {
    print('Long press cancel');
    controller.reverse();
  }

  playAudio() {
    player.play();
  }

  pauseAudio() {
    player.pause();
  }

  repeatAudio(Duration duration) {
    player.seek(duration);
  }

  String playerDuration(Duration duration) {
    var minute =
        duration.inMinutes < 10 ? "0${duration.inMinutes}" : duration.inMinutes;
    var second =
        duration.inSeconds < 10 ? "0${duration.inSeconds}" : duration.inSeconds;
    return '$minute:$second';
  }
}
