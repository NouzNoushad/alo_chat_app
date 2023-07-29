import 'package:alo_chat_app/alo_status/cubit/alo_status_cubit.dart';
import 'package:alo_chat_app/alo_status/screens/text_status.dart';
import 'package:alo_chat_app/core/colors.dart';
import 'package:alo_chat_app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../alo_chats/screens/chats_list.dart';
import '../../complete_profile/screens/photo_bottom_sheet.dart';
import '../../widgets/loading_indicator.dart';

class AloStatus extends StatefulWidget {
  const AloStatus({super.key});

  @override
  State<AloStatus> createState() => _AloStatusState();
}

class _AloStatusState extends State<AloStatus> {
  late AloStatusCubit aloStatusCubit;

  @override
  void initState() {
    aloStatusCubit = BlocProvider.of<AloStatusCubit>(context);
    aloStatusCubit.rearrangeStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor2,
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TextStatus()),
          ),
          child: const CircleAvatar(
            backgroundColor: CustomColors.backgroundColor1,
            child: Icon(
              Icons.edit,
              color: CustomColors.backgroundColor2,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: () {
            photoBottomSheet(context, size, ChatType.status);
          },
          child: const CircleAvatar(
            backgroundColor: CustomColors.backgroundColor1,
            radius: 28,
            child: Icon(
              Icons.photo_camera,
              size: 25,
              color: CustomColors.backgroundColor2,
            ),
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: StreamBuilder(
          stream: aloStatusCubit.statusStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CustomLoadingIndicator();
            }
            if (snapshot.data.isEmpty) {
              return createStatus(size);
            }
            // return Container();
            return BlocBuilder<AloStatusCubit, AloStatusState>(
                builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: ChatsList(
                      snapshot: snapshot.data,
                      chatType: ChatType.status,
                    ),
                  ),
                ],
              );
            });
          }),
    );
  }

  Widget createStatus(size) => Wrap(
        children: [
          InkWell(
            onTap: () => photoBottomSheet(context, size, ChatType.status),
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 20, 6, 15),
              child: Row(children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: CustomColors.backgroundColor1,
                        child: Icon(
                          Icons.person_rounded,
                          size: 40,
                          color: CustomColors.backgroundColor2,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: CustomColors.backgroundLightColor2,
                        child: Icon(
                          Icons.add,
                          size: 18,
                          color: CustomColors.backgroundColor1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.backgroundDarkColor1,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Tap to add status update',
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.backgroundColor1,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      );
}
