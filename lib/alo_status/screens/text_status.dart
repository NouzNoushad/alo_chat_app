import 'package:alo_chat_app/alo_status/cubit/alo_status_cubit.dart';
import 'package:alo_chat_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:screenshot/screenshot.dart';

class TextStatus extends StatefulWidget {
  const TextStatus({
    super.key,
  });

  @override
  State<TextStatus> createState() => _TextStatusState();
}

class _TextStatusState extends State<TextStatus> {
  late AloStatusCubit aloStatusCubit;
  @override
  void initState() {
    aloStatusCubit = BlocProvider.of<AloStatusCubit>(context);
    aloStatusCubit.statusTextFocusNode.requestFocus();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    aloStatusCubit.statusTextFocusNode.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AloStatusCubit, AloStatusState>(
          builder: (context, state) {
            return Container(
              color: aloStatusCubit.randomColor,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        aloStatusCubit.statusTextFocusNode.unfocus();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: CustomColors.whiteColor,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.title,
                            color: CustomColors.whiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: aloStatusCubit.generateRandomColor,
                          icon: const Icon(
                            Icons.palette,
                            color: CustomColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Screenshot(
                    controller: aloStatusCubit.screenshotController,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      color: aloStatusCubit.randomColor,
                      child: TextField(
                        textAlign: TextAlign.center,
                        focusNode: aloStatusCubit.statusTextFocusNode,
                        cursorColor: CustomColors.whiteColor,
                        showCursor: false,
                        maxLines: null,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            decorationThickness: 0,
                            color: CustomColors.whiteColor),
                        decoration: const InputDecoration(
                            hintText: 'Type a status',
                            hintStyle: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                                color: Colors.white24),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black26,
                  alignment: Alignment.bottomRight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: GestureDetector(
                    onTap: () => aloStatusCubit.captureScreenShot(context),
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: CustomColors.backgroundColor2,
                      child: Icon(
                        Icons.send,
                        color: CustomColors.backgroundColor1,
                      ),
                    ),
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
