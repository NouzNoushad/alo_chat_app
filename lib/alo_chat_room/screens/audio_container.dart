import 'package:alo_chat_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../cubit/chat_room_cubit.dart';

class AudioContainer extends StatefulWidget {
  final String filePath;
  const AudioContainer({super.key, required this.filePath});

  @override
  State<AudioContainer> createState() => _AudioContainerState();
}

class _AudioContainerState extends State<AudioContainer> {
  late ChatRoomCubit chatRoomCubit;
  @override
  void initState() {
    chatRoomCubit = BlocProvider.of<ChatRoomCubit>(context);
    chatRoomCubit.initPlayer(widget.filePath);
    super.initState();
  }

  @override
  void dispose() {
    chatRoomCubit.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatRoomCubit.initPlayer(widget.filePath);
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
      decoration: BoxDecoration(
        color: CustomColors.backgroundLightColor2,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(children: [
        StreamBuilder<PlayerState>(
            stream: chatRoomCubit.player.playerStateStream,
            builder: ((context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return GestureDetector(
                  onTap: chatRoomCubit.player.play,
                  child: const Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: CustomColors.backgroundColor1,
                  ),
                );
              } else if (playing != true) {
                return GestureDetector(
                  onTap: chatRoomCubit.player.play,
                  child: const Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: CustomColors.backgroundColor1,
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return GestureDetector(
                  onTap: chatRoomCubit.player.pause,
                  child: const Icon(
                    Icons.pause,
                    size: 30,
                    color: CustomColors.backgroundColor1,
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () => chatRoomCubit.player.seek(Duration.zero),
                  child: const Icon(
                    Icons.replay,
                    size: 30,
                    color: CustomColors.backgroundColor1,
                  ),
                );
              }
            })),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: StreamBuilder<Duration>(
              stream: chatRoomCubit.player.positionStream,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      LinearProgressIndicator(
                        value: snapshot.data!.inMilliseconds /
                            (chatRoomCubit.duration?.inMilliseconds ?? 1),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        chatRoomCubit.playerDuration(
                          snapshot.data! == Duration.zero
                              ? chatRoomCubit.player.duration ?? Duration.zero
                              : snapshot.data!,
                        ),
                        style: const TextStyle(
                          color: CustomColors.backgroundDarkColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: LinearProgressIndicator(
                      backgroundColor: CustomColors.backgroundColor1,
                    ),
                  );
                }
              })),
        ),
      ]),
    );
  }
}
