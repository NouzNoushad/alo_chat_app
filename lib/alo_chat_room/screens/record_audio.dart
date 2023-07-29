import 'package:alo_chat_app/alo_chat_room/screens/flow_shader_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/colors.dart';
import '../../model/chat_room_model.dart';
import '../../model/user_model.dart';
import '../cubit/chat_room_cubit.dart';

class RecordAudio extends StatefulWidget {
  final ChatRoomCubit chatRoomCubit;
  final UserModel sender;
  final ChatRoomModel chatRoom;
  const RecordAudio(
      {super.key,
      required this.chatRoomCubit,
      required this.sender,
      required this.chatRoom});

  @override
  State<RecordAudio> createState() => _RecordAudioState();
}

class _RecordAudioState extends State<RecordAudio>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> scaleAnimation;
  late Animation<double> timerAnimation;

  double timerWidth = 0;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 600));
    scaleAnimation = Tween<double>(begin: 1, end: 2).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0,
          0.6,
          curve: Curves.elasticInOut,
        )))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth = MediaQuery.of(context).size.width - 4 * 4;
    timerAnimation = Tween<double>(begin: timerWidth + 8, end: 0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.2, 1, curve: Curves.easeIn)));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -3,
          right: -timerAnimation.value,
          child: Container(
            height: 55,
            width: timerWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: CustomColors.backgroundColor1,
            ),
            child: Row(children: [
              const SizedBox(
                width: 8,
              ),
              Text(
                widget.chatRoomCubit.recordDuration,
                style: const TextStyle(
                  color: CustomColors.backgroundColor2,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const FlowShaderMask(
                  child: Row(
                children: [
                  Icon(
                    Icons.keyboard_arrow_left,
                    color: CustomColors.backgroundColor2,
                  ),
                  Text(
                    'Slide to Cancel',
                    style: TextStyle(
                      color: CustomColors.backgroundColor2,
                    ),
                  ),
                ],
              )),
              const SizedBox(
                width: 50,
              ),
            ]),
          ),
        ),
        BlocBuilder<ChatRoomCubit, ChatRoomState>(
          builder: (context, state) {
            ChatRoomCubit chatRoomCubit =
                BlocProvider.of<ChatRoomCubit>(context);
            return GestureDetector(
              onLongPressDown: (_) {
                chatRoomCubit.recordOnLongPressDown(animationController);
              },
              onLongPress: () {
                chatRoomCubit.recordOnLongPress(animationController);
              },
              onLongPressEnd: (end) async {
                chatRoomCubit.recordOnLongPressEnd(context, animationController,
                    end, widget.sender, widget.chatRoom);
              },
              onLongPressCancel: () {
                chatRoomCubit.recordOnLongPressCancel(animationController);
              },
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: chatRoomCubit.audioLoading
                    ? const CircularProgressIndicator()
                    : const CircleAvatar(
                        radius: 25,
                        backgroundColor: CustomColors.backgroundColor1,
                        child: Icon(
                          Icons.mic,
                          color: CustomColors.backgroundColor2,
                        )),
              ),
            );
          },
        ),
      ],
    );
  }
}
