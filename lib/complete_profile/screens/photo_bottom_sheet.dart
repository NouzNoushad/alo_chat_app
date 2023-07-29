import 'package:alo_chat_app/alo_status/cubit/alo_status_cubit.dart';
import 'package:alo_chat_app/complete_profile/cubit/complete_profile_cubit.dart';
import 'package:alo_chat_app/complete_profile/screens/profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';

photoBottomSheet(context, size, type) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: size.height * 0.2,
          padding: const EdgeInsets.all(15.0),
          color: type == ChatType.chat
              ? CustomColors.backgroundColor
              : CustomColors.backgroundColor2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                type == ChatType.chat ? 'Profile photo' : 'Status photo',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: type == ChatType.chat
                        ? CustomColors.backgroundColor2
                        : CustomColors.backgroundColor1),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                builder: (context, state) {
                  CompleteProfileCubit completeProfile =
                      BlocProvider.of<CompleteProfileCubit>(context);
                  AloStatusCubit statusCubit =
                      BlocProvider.of<AloStatusCubit>(context);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProfilePhoto(
                        title: 'Camera',
                        icon: Icons.photo_camera,
                        radius: size.height * 0.030,
                        onTap: type == ChatType.chat
                            ? () {
                                completeProfile.pickProfileImage(
                                    context, ImageSource.camera);
                              }
                            : () {
                                statusCubit.captureStatusImage(
                                    context, ImageSource.camera);
                              },
                      ),
                      ProfilePhoto(
                        title: 'Gallery',
                        icon: Icons.image,
                        radius: size.height * 0.030,
                        onTap: type == ChatType.chat
                            ? () {
                                completeProfile.pickProfileImage(
                                    context, ImageSource.gallery);
                              }
                            : () {
                                statusCubit.captureStatusImage(
                                    context, ImageSource.gallery);
                              },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      });
}
